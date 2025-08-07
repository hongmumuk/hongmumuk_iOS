//
//  ReviewMakeView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 7/7/25.
//

import PhotosUI
import SwiftUI

import ComposableArchitecture

struct ReviewMakeView: View {
    private let store: StoreOf<ReviewMakeFeature>
    @ObservedObject var viewStore: ViewStoreOf<ReviewMakeFeature>
    var onComplete: (Bool) -> Void
    @SwiftUI.Environment(\.dismiss) var dismiss
    
    init(store: StoreOf<ReviewMakeFeature>, onComplete: @escaping (Bool) -> Void) {
        self.store = store
        viewStore = ViewStore(store, observe: { $0 })
        self.onComplete = onComplete
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ReviewMakeHeaderView(viewStore: viewStore)
            ReviewMakeStarView(viewStore: viewStore)
            ReviewMakeTextView(viewStore: viewStore)
            ReviewMakePhotoAddView(viewStore: viewStore)
            ReviewMakePhotoView(viewStore: viewStore)
            Spacer()
            ReviewMakeNoticeView(viewStore: viewStore)
            ReviewWriteButton(viewStore: viewStore)
        }
        .onAppear {
            viewStore.send(.onAppear)
        }
        .onChange(of: viewStore.isDismiss) { _, isDismiss in
            if isDismiss {
                onComplete(true)
                dismiss()
            }
        }
        .dismissKeyboardOnTap()
        .sheet(isPresented: viewStore.binding(
            get: \.isShowingPhotoPicker,
            send: .dismissSheet
        )
        ) {
            PhotoPickerView(
                limit: 5 - viewStore.photoCount
            ) { images in
                viewStore.send(.photoPickerFinished(images))
            }
        }
        .fullScreenCover(isPresented: viewStore.binding(
            get: \.isShowingCamera,
            send: .dismissSheet
        )
        ) {
            CameraView { image in
                if let image { viewStore.send(.cameraShot(image)) }
            }
        }
        .alert("갤러리 접근 권한이 필요합니다.", isPresented: viewStore.binding(
            get: \.isShowingPhotoAuthAlert,
            send: .dismissSheet
        ),
        actions: {
            Button("cancel".localized(), role: .none) {}
            
            Button("device_set".localized(), role: .none) {
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(appSettings) {
                        UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                    }
                }
            }
        }, message: {
            Text("갤러리 접근 권한이 필요합니다.".localized())
        })
        .alert("카메라 접근 권한이 필요합니다.", isPresented: viewStore.binding(
            get: \.isShowingCameraAuthAlert,
            send: .dismissSheet
        ),
        actions: {
            Button("cancel".localized(), role: .none) {}
            
            Button("device_set".localized(), role: .none) {
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    if UIApplication.shared.canOpenURL(appSettings) {
                        UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                    }
                }
            }
        }, message: {
            Text("카메라 접근 권한이 필요합니다.".localized())
        })
        .alert("리뷰 작성 유의사항", isPresented: viewStore.binding(
            get: \.isShowingNoticeAlert,
            send: .dismissSheet
        ),
        actions: {
            Button("확인했어요".localized(), role: .none) {}
        }, message: {
            Text("""
                · 솔직한 실제 방문 경험을 남겨 주세요.
                · 욕설, 비방, 허위 정보가 포함된 리뷰는 통보 없이 삭제될 수 있습니다.
                · 가게 음식, 분위기, 서비스 등 느낀 점을 자유롭게 작성해 주세요.
                · 사진은 직접 촬영한 이미지를 올려 주세요.
                · 타인이게 도움이 될 수 있는 정보를 작성해 주세요.
                """.localized()
            )
        })
        .alert("리뷰 작성을 취소하시겠습니까?", isPresented: viewStore.binding(
            get: \.isShowingCloseAlert,
            send: .dismissSheet
        ),
        actions: {
            Button("취소".localized(), role: .none) {
                dismiss()
            }
            
            Button("계속 작성하기".localized(), role: .none) {}
        }, message: {
            Text("작성 중인 내용은 저장되지 않습니다.".localized())
        })
        .onChange(of: viewStore.requestGalleryAuth) {
            if viewStore.requestGalleryAuth {
                PHPhotoLibrary.requestAuthorization(for: .readWrite) { new in
                    DispatchQueue.main.async {
                        viewStore.send(.photoLibraryAuth(new))
                    }
                }
            }
        }
        .onChange(of: viewStore.requestCameraAuth) {
            if viewStore.requestCameraAuth {
                AVCaptureDevice.requestAccess(for: .video) { new in
                    DispatchQueue.main.async {
                        if new {
                            viewStore.send(.photoCameraAuth(.authorized))
                        } else {
                            viewStore.send(.photoCameraAuth(.denied))
                        }
                    }
                }
            }
        }
    }
}
