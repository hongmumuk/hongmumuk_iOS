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
        
        var reviewText = ""
        var textCount: Int { reviewText.count }
        
        var errorMessage = ""
        var reviewTextStatus: ReviewMakeTextView.TextStatus = .normal
    }
    
    enum Action: Equatable {
        // ─ UI 이벤트
        case starButtonTapped(Int)
        case addPhotoButtonTapped
        case noticeButtonTapped
        case setPhotoActionSheet(Bool)
        case writeButtonTapped
        
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
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
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
                let room = max(0, 5 - state.photos.count)
                state.photos.append(contentsOf: images.prefix(room))
                return .none
                
            case let .cameraShot(image):
                if state.canAddMore { state.photos.append(image) }
                state.isShowingCamera = false
                return .none
                
            case .dismissSheet:
                state.isShowingPhotoPicker = false
                state.isShowingCamera = false
                state.isShowingPhotoAuthAlert = false
                state.isShowingCameraAuthAlert = false
                state.isShowingNoticeAlert = false
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
                    state.errorMessage = "리뷰는 최소 20자 이상 입력해 주세요."
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
