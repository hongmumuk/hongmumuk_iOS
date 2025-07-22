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
        
        var isShowingPhotoActionSheet = false
    }
    
    enum Action: Equatable {
        // ─ UI 이벤트
        case starButtonTapped(Int)
        case addPhotoButtonTapped
        case noticeButtonTapped
        case setPhotoActionSheet(Bool)
        case writeButtonTapped
        
        // ─ 사진 메뉴
        case photoMenuLibraryTapped
        case photoMenuCameraTapped
        
        // ─ Picker / Camera 결과 & 공통 닫기
        case photoPickerFinished([UIImage])
        case cameraShot(UIImage)
        case dismissSheet
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .starButtonTapped(index):
                state.starRate = Double(index + 1)
                return .none
            
            case .addPhotoButtonTapped:
                state.isShowingPhotoActionSheet = true
                return .none
            
            case .noticeButtonTapped:
                return .none
                
            case .writeButtonTapped:
                state.isWriteActive = true
                return .none
            
            case .photoMenuLibraryTapped:
                guard state.canAddMore else { return .none }
                state.isShowingPhotoPicker = true
                return .none
            
            case .photoMenuCameraTapped:
                guard state.canAddMore else { return .none }
                state.isShowingCamera = true
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
                return .none

            case let .setPhotoActionSheet(isShow):
                state.isShowingPhotoActionSheet = isShow
                return .none
            }
        }
    }
}
