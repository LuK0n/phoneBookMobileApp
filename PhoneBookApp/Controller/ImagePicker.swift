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
    let willChange = PassthroughSubject<UIImage?, Never>()

    @Published var image: UIImage? = nil {
        didSet {
            if image != nil {
                willChange.send(image)
                let img = image ?? UIImage(named: "book")!
                    if let data = img.jpegData(compressionQuality: 0.8) {
                        let filename = self.getDocumentsDirectory().appendingPathComponent("\(img.hashValue)")
                        try? data.write(to: filename)
                        self.name = filename
                    }
            } else {
                self.name = nil
            }
        }
    }
    @Published var name: URL? = nil
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}


extension ImagePicker {

    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

        // UIImagePickerControllerDelegate
        func imagePickerController(_ picker: UIImagePickerController,
                                   didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            let uiImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
            ImagePicker.shared.image = uiImage
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
