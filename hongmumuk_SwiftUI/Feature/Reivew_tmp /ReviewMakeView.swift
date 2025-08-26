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
    
    private let bullets = [
        "review_guideline_honest_experience".localized(),
        "review_guideline_profanity_policy".localized(),
        "review_guideline_topics".localized(),
        "review_guideline_own_photos".localized(),
        "review_guideline_help_others".localized()
    ]
    .map { "· \($0)" }
    
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
            .presentationBackground(.black)
        }
        .sheet(isPresented: Binding(
            get: { viewStore.isShowingNoticeAlert },
            set: { _, _ in viewStore.send(.dismissSheet) }
        )) {
            ReviewMakeNoticeModalView(
                title: "review_guidelines_title".localized(),
                content: bullets.joined(separator: "\n"),
                onDismiss: {
                    viewStore.send(.dismissSheet)
                },
                agreeAction: {
                    viewStore.send(.dismissSheet)
                }
            )
        }
        .alert("review_gallery_permission_needed".localized(), isPresented: viewStore.binding(
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
            Text("review_photo_permission_needed".localized())
        })
        .alert("review_camera_permission_needed".localized(), isPresented: viewStore.binding(
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
            Text("review_photo_permission_needed".localized())
        })
        .alert("review_discard_confirm_title".localized(), isPresented: viewStore.binding(
            get: \.isShowingCloseAlert,
            send: .dismissSheet
        ),
        actions: {
            Button("cancel".localized(), role: .none) {
                dismiss()
            }
            
            Button("review_keep_writing".localized(), role: .none) {}
        }, message: {
            Text("review_discard_warning".localized())
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
