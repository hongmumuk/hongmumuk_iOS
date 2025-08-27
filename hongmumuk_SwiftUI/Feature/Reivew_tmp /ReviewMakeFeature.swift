//
//  ReviewMakeFeature.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 7/7/25.
//

import ComposableArchitecture
import PhotosUI
import UIKit

struct ReviewMakeFeature: Reducer {
    enum ReviewMode: Equatable {
        case create(restaurantName: String, restaurantID: Int)
        case edit(restaurantName: String, restaurantID: Int, star: Int, content: String, photos: [UIImage])
    }
    
    struct State: Equatable {
        var starRate: Double = 0
        var photos: [UIImage] = []
        var isShowingPhotoPicker = false
        var isShowingCamera = false
        var isWriteActive = false
        
        var photoCount: Int { photos.count }
        var canAddMore: Bool { photos.count < 5 }
        
        var requestGalleryAuth = false
        var requestCameraAuth = false
        var isShowingPhotoActionSheet = false
        var isShowingPhotoAuthAlert = false
        var isShowingCameraAuthAlert = false
        var isShowingNoticeAlert = false
        var isShowingCloseAlert = false
        
        var reviewText = ""
        var textCount: Int { reviewText.count }
        
        var errorMessage = ""
        var reviewTextStatus: ReviewMakeTextView.TextStatus = .normal
        var reviewMode: ReviewMode
        var restaurantName = ""
        var restaurantID = 0
        
        var isDismiss = false
    }
    
    enum Action: Equatable {
        // ─ UI 이벤트
        case onAppear
        case starButtonTapped(Int)
        case addPhotoButtonTapped
        case noticeButtonTapped
        case setPhotoActionSheet(Bool)
        case writeButtonTapped
        case dismissButtonTapped
        
        // ─ 갤러리
        case photoMenuLibraryTapped
        case photoLibraryAuth(PHAuthorizationStatus)
        
        // ─ 카메라
        case photoMenuCameraTapped
        case photoCameraAuth(AVAuthorizationStatus)
        
        // ─ Picker / Camera 결과 & 공통 닫기
        case photoPickerFinished([UIImage])
        case cameraShot(UIImage)
        case dismissSheet
        
        case removePhoto(Int)
        
        case textChanged(String)
        
        case textFocusChanged(Bool)
        
        case reviewUploaded
        case reviewUploadError(WriteReviewError)
    }
    
    @Dependency(\.keychainClient) var keychainClient
    @Dependency(\.reviewClient) var reviewClient
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                switch state.reviewMode {
                case let .create(restaurantName, restaurantID):
                    state.restaurantName = restaurantName
                    state.restaurantID = restaurantID

                case let .edit(restaurantName, restaurantID, star, content, photos):
                    state.restaurantName = restaurantName
                    state.restaurantID = restaurantID
                    state.starRate = Double(star)
                    state.reviewText = content
                    state.photos = photos
                    state.isWriteActive = checkIsWriteActive(state: state)
                }

                return .none
                
            case let .starButtonTapped(index):
                state.starRate = Double(index + 1)
                state.isWriteActive = checkIsWriteActive(state: state)
                return .none
                
            case .addPhotoButtonTapped:
                state.isShowingPhotoActionSheet = true
                state.isWriteActive = checkIsWriteActive(state: state)
                return .none
                
            case .noticeButtonTapped:
                state.isShowingNoticeAlert = true
                return .none
                
            case .writeButtonTapped:
                state.isWriteActive = false
                let star = Int(state.starRate)
                let text = state.reviewText
                let photos = state.photos
                let rid = state.restaurantID

                return .run { send in
                    if let token = await keychainClient.getString(.accessToken) {
                        let model = WriteReviewModel(rid: rid, star: star, content: text)
                        
                        do {
                            let upload = try await reviewClient.postReview(token, model, photos)
                            
                            if upload {
                                await send(.reviewUploaded)
                            }
                            
                        } catch {
                            await send(.reviewUploadError(.unknown))
                        }
                    }
                }
                
            case .dismissButtonTapped:
                state.isShowingCloseAlert = true
                return .none

            // 성공
            case .reviewUploaded:
                state.isDismiss = true
                return .none
                
            // 실패
            case let .reviewUploadError(error):
                state.isWriteActive = true
                return .none
                
            case .photoMenuLibraryTapped:
                guard state.canAddMore else { return .none }
                let status = PHPhotoLibrary.authorizationStatus(for: .readWrite)
                
                return .run { send in
                    await send(.photoLibraryAuth(status))
                }
                
            case let .photoLibraryAuth(status):
                state.requestGalleryAuth = false
                
                switch status {
                case .authorized, .limited:
                    state.isShowingPhotoPicker = true
                case .denied, .restricted:
                    state.isShowingPhotoAuthAlert = true
                case .notDetermined:
                    state.requestGalleryAuth = true
                default:
                    break
                }
                
                return .none
                
            case .photoMenuCameraTapped:
                guard state.canAddMore else { return .none }
                let status = AVCaptureDevice.authorizationStatus(for: .video)
                
                return .run { send in
                    await send(.photoCameraAuth(status))
                }
                
            case let .photoCameraAuth(status):
                state.requestCameraAuth = false
                
                switch status {
                case .authorized:
                    state.isShowingCamera = true
                case .denied, .restricted:
                    state.isShowingCameraAuthAlert = true
                case .notDetermined:
                    state.requestCameraAuth = true
                default:
                    break
                }
                
                return .none
                
            case let .photoPickerFinished(images):
                let images = images.reversed()
                let room = max(0, 5 - state.photos.count)
                state.photos.insert(contentsOf: images.prefix(room), at: 0)
                return .none
                
            case let .cameraShot(image):
                state.photos.insert(image, at: 0)
                state.isShowingCamera = false
                return .none
                
            case .dismissSheet:
                state.isShowingPhotoPicker = false
                state.isShowingCamera = false
                state.isShowingPhotoAuthAlert = false
                state.isShowingCameraAuthAlert = false
                state.isShowingNoticeAlert = false
                state.isShowingCloseAlert = false
                return .none
                
            case let .setPhotoActionSheet(isShow):
                state.isShowingPhotoActionSheet = isShow
                return .none
                
            case let .removePhoto(index):
                guard state.photos.indices.contains(index) else { return .none }
                state.photos.remove(at: index)
                return .none
                
            case let .textChanged(text):
                state.reviewText = String(text.prefix(200))
                state.isWriteActive = checkIsWriteActive(state: state)
                return .none
                
            case let .textFocusChanged(isFocused):
                if !isFocused, state.textCount <= 20 {
                    state.errorMessage = "review_min_chars".localized()
                    state.reviewTextStatus = .error
                } else {
                    state.errorMessage = ""
                    state.reviewTextStatus = .normal
                }
                
                state.isWriteActive = checkIsWriteActive(state: state)
                
                return .none
            }
        }
    }
}

extension ReviewMakeFeature {
    func checkIsWriteActive(state: ReviewMakeFeature.State) -> Bool {
        return state.textCount >= 20 && state.starRate != 0.0
    }
}
