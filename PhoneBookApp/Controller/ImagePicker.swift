//
//  ImagePicker.swift
//  PhoneBookApp
//
//  Created by Lukas Kontur on 4/26/20.
//  Copyright © 2020 Lukas Kontur. All rights reserved.
//

import SwiftUI
import Combine

final class ImagePicker : ObservableObject {

    static let shared : ImagePicker = ImagePicker()

    private init() {}  //force using the singleton: ImagePicker.shared

    let view = ImagePicker.View()
    let coordinator = ImagePicker.Coordinator()

    // Bindable Object part
    let willChange = PassthroughSubject<Image?, Never>()

    @Published var image: Image? = nil {
        didSet {
            if image != nil {
                willChange.send(image)
            }
        }
    }
    @Published var name: String? = nil
}


extension ImagePicker {

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        // UIImagePickerControllerDelegate
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            let imageURL = info[UIImagePickerController.InfoKey.imageURL] as! URL
            ImagePicker.shared.name = imageURL.absoluteString
            ImagePicker.shared.image = Image(uiImage: uiImage)
            picker.dismiss(animated:true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated:true)
        }
    }


    struct View: UIViewControllerRepresentable {

        func makeCoordinator() -> Coordinator {
            ImagePicker.shared.coordinator
        }

        func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker.View>) -> UIImagePickerController {
            let picker = UIImagePickerController()
            picker.delegate = context.coordinator
            return picker
        }

        func updateUIViewController(_ uiViewController: UIImagePickerController,
                                    context: UIViewControllerRepresentableContext<ImagePicker.View>) {

        }

    }

}
