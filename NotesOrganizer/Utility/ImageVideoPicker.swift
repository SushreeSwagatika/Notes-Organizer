//
//  ImagePicker.swift
//  NotesOrganizer
//
//  Created by Sushree Swagatika on 21/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import UIKit

public protocol ImageVideoPickerDelegate: class {
    func didSelect(image: UIImage?, url: URL?)
}

class ImageVideoPicker: NSObject {
    
    private let imagePickerController : UIImagePickerController
    private weak var delegate : ImageVideoPickerDelegate?
    private weak var presentationController : UIViewController?
    
    public init(presentationController: UIViewController, delegate: ImageVideoPickerDelegate) {
        self.imagePickerController = UIImagePickerController()
        super.init()
        
        self.presentationController = presentationController
        self.delegate = delegate
        
        self.imagePickerController.delegate = self
        self.imagePickerController.allowsEditing = true
        self.imagePickerController.mediaTypes = ["public.image", "public.video","public.movie"]
        self.imagePickerController.videoQuality = .typeHigh
    }
    
    private func pickerAction(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }
        
        return UIAlertAction(title: title, style: .default) { [unowned self] _ in
            self.imagePickerController.sourceType = type
            self.presentationController?.present(self.imagePickerController, animated: true)
        }
    }
    
    public func present(from sourceView: UIView) {
        
        let alertController = UIAlertController(title: "Add Image/Video", message: "Choose an option", preferredStyle: .actionSheet)
        
        if let action = self.pickerAction(for: .savedPhotosAlbum, title: "Camera roll") {
            alertController.addAction(action)
        }
        if let action = self.pickerAction(for: .photoLibrary, title: "Gallery") {
            alertController.addAction(action)
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            alertController.popoverPresentationController?.sourceView = sourceView
            alertController.popoverPresentationController?.sourceRect = sourceView.bounds
            alertController.popoverPresentationController?.permittedArrowDirections = [.down, .up]
        }
        
        self.presentationController?.present(alertController, animated: true)
    }
    
    private func pickerController(_ controller: UIImagePickerController, didSelectImage image: UIImage?, didSelectURL url: URL?) {
        controller.dismiss(animated: true, completion: nil)
        
        self.delegate?.didSelect(image: image, url: url)
    }
}

extension ImageVideoPicker: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelectImage: nil, didSelectURL: nil)
    }
    
    public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.editedImage] as? UIImage {
            return self.pickerController(picker, didSelectImage: image, didSelectURL: nil)
        }
        if let url = info[.mediaURL] as? URL {
            return self.pickerController(picker, didSelectImage: nil, didSelectURL: url)
        }
//        //uncomment this to save the video file to the media library
//        if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path) {
//            UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, nil, nil)
//        }
        return self.pickerController(picker, didSelectImage: nil, didSelectURL: nil)
    }
}
