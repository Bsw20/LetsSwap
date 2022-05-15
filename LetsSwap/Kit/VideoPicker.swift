//
//  VideoPicker.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 21.04.2022.
//

import Foundation
import UIKit


public protocol VideoPickerDelegate: class {
    func didSelect(view: VideoPicker, videoURL: NSURL?)
}

open class VideoPicker: NSObject {

    private let pickerController: UIImagePickerController
    private weak var presentationController: UIViewController?
    private weak var delegate: VideoPickerDelegate?

    public init(presentationController: UIViewController, delegate: VideoPickerDelegate) {
        self.pickerController = UIImagePickerController()

        super.init()

        self.presentationController = presentationController
        self.delegate = delegate

        self.pickerController.delegate = self
        self.pickerController.allowsEditing = true
        self.pickerController.mediaTypes = ["public.movie"]
    }

    private func action(for type: UIImagePickerController.SourceType, title: String) -> UIAlertAction? {
        guard UIImagePickerController.isSourceTypeAvailable(type) else {
            return nil
        }

        return UIAlertAction(title: title, style: .default) { [ weak self] _ in
            self?.pickerController.sourceType = type
            guard let self = self else {return}
            self.presentationController?.present(self.pickerController, animated: true)
        }
    }

    public func present(from sourceView: UIView) {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        if let action = self.action(for: .camera, title: "Take video") {
            alertController.addAction(action)
        }
        if let action = self.action(for: .photoLibrary, title: "Video library") {
            alertController.addAction(action)
        }

        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))


        self.presentationController?.present(alertController, animated: true)
    }

    private func pickerController(_ controller: UIImagePickerController, didSelect image: UIImage?) {
    }
}

extension VideoPicker: UIImagePickerControllerDelegate {

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.pickerController(picker, didSelect: nil)
    }

    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let videoURL = info[.mediaURL] as? NSURL else {
            picker.dismiss(animated: true, completion: nil)
            self.delegate?.didSelect(view: self, videoURL: nil)
            return
        }
        picker.dismiss(animated: true, completion: nil)

        self.delegate?.didSelect(view: self, videoURL: videoURL)
    }
}

extension VideoPicker: UINavigationControllerDelegate {

}
