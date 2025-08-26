//
//  ReviewMakePhotoAddView.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 7/7/25.
//

import PhotosUI
import SwiftUI

import ComposableArchitecture

struct ReviewMakePhotoAddView: View {
    @ObservedObject var viewStore: ViewStoreOf<ReviewMakeFeature>
    
    var body: some View {
        Button(action: { viewStore.send(.addPhotoButtonTapped) }) {
            addPhotoButton // 그대로 재사용
        }
        .confirmationDialog(
            "review_add_photo".localized(), // 시트 제목
            isPresented: viewStore.binding(
                get: \.isShowingPhotoActionSheet,
                send: ReviewMakeFeature.Action.setPhotoActionSheet
            ),
            titleVisibility: .visible
        ) {
            Button("review_photo_library".localized()) { viewStore.send(.photoMenuLibraryTapped) }
            Button("review_take_photo".localized()) { viewStore.send(.photoMenuCameraTapped) }
            Button("cancel".localized(), role: .cancel) {}
        }
        .padding(.top, 24)
        .padding(.horizontal, 24)
    }
    
    private var addPhotoButton: some View {
        ZStack(alignment: .center) {
            RoundedRectangle(cornerRadius: 12)
                .stroke(Colors.Primary.primary55, lineWidth: 1.5)
                .frame(height: 48)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.clear)
                )
            
            HStack(spacing: 6) {
                Image("cameraIcon")
                    .resizable()
                    .frame(width: 20, height: 20)
                
                Text("review_add_photos_cta".localized() + " (\(viewStore.photoCount)/5)")
                    .fontStyle(Fonts.body1Medium)
                    .foregroundStyle(Colors.Primary.primary55)
            }
        }
    }
}

struct PhotoPickerView: UIViewControllerRepresentable {
    let limit: Int
    let onComplete: ([UIImage]) -> Void
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = limit
        config.filter = .images
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }
    func updateUIViewController(_: PHPickerViewController, context _: Context) {}
    
    final class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: PhotoPickerView
        init(parent: PhotoPickerView) { self.parent = parent }
        
        func picker(_ picker: PHPickerViewController,
                    didFinishPicking results: [PHPickerResult])
        {
            picker.dismiss(animated: true)
            
            guard !results.isEmpty else { parent.onComplete([]); return }
            
            var images: [UIImage] = []
            let group = DispatchGroup()
            for item in results {
                group.enter()
                _ = item.itemProvider.loadObject(ofClass: UIImage.self) { object, _ in
                    if let img = object as? UIImage { images.append(img) }
                    group.leave()
                }
            }
            group.notify(queue: .main) {
                self.parent.onComplete(images)
            }
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    let onCapture: (UIImage?) -> Void
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let camera = UIImagePickerController()
        camera.sourceType = .camera
        camera.delegate = context.coordinator
        return camera
    }
    
    func makeCoordinator() -> Coordinator { Coordinator(parent: self) }
    func updateUIViewController(_: UIImagePickerController, context _: Context) {}
    
    final class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView
        init(parent: CameraView) { self.parent = parent }
        
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
        {
            let image = info[.originalImage] as? UIImage
            picker.dismiss(animated: true) { self.parent.onCapture(image) }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true) { self.parent.onCapture(nil) }
        }
    }
}
