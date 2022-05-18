//
//  AddPhotoView.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 31.12.2020.
//

import Foundation
import UIKit
import SwiftyBeaver

protocol AddPhotoViewDelegate: NSObjectProtocol {
    func addPhotoViewTapped()
}

class AddPhotoView: UIView {
    let service = UserAPIService.shared
    weak var customDelegate: AddPhotoViewDelegate?
    
    private lazy var imageView: WebImageView = {
       let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .white
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowRadius = 1
        imageView.layer.shadowOpacity = 0.2
        imageView.layer.cornerRadius = EditProfileConstants.addPhotoViewSize.height / 2
        imageView.backgroundColor = .white
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var addPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "cameraIcon"), for: .normal)
        button.backgroundColor = .mainDetailsYellow()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.layer.cornerRadius = EditProfileConstants.addPhotoButtonHeight / 2
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        backgroundColor = .clear
        addPhotoButton.addTarget(self, action: #selector(photoButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - funcs
    public func setPhoto(image: UIImage?) {
        
        if let image = image {

            service.uploadImage(image: image) { (result) in
                switch result {
                case .success(let stringURL):
                    self.imageView.set(imageURL: stringURL)
                case .failure(let error):
                    UIApplication.showAlert(title: "Ошибка!", message: "Не получилось загрузить фотографию.")
                    SwiftyBeaver.error(error.localizedDescription)
                }
            }
        }
    }
    
    public func setPhoto(photoStringUrl: String?) {
        self.imageView.set(imageURL: photoStringUrl, placeholder: #imageLiteral(resourceName: "profileImagePlaceholder").withTintColor(.lightGray))
    }
    public func getPhotoUrl() -> StringURL {
        return imageView.getCurrentUrl
    }
    
    //MARK: - Objc funcs
    @objc private func photoButtonTapped() {
        customDelegate?.addPhotoViewTapped()


    }
}

//MARK: - Constraints
extension AddPhotoView {
    private func setupConstraints() {
        addSubview(imageView)
        addSubview(addPhotoButton)
        
        NSLayoutConstraint.activate([
                imageView.heightAnchor.constraint(equalTo: heightAnchor),
                imageView.widthAnchor.constraint(equalTo: heightAnchor),
                imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                imageView.leadingAnchor.constraint(equalTo: leadingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            addPhotoButton.trailingAnchor.constraint(equalTo: trailingAnchor),
            addPhotoButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            addPhotoButton.heightAnchor.constraint(equalToConstant: EditProfileConstants.addPhotoButtonHeight),
            addPhotoButton.widthAnchor.constraint(equalToConstant: EditProfileConstants.addPhotoButtonHeight)
        ])
        

    }
}


// MARK: - SwiftUI
import SwiftUI

struct AddPhotoViewProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let feedVC = MainTabBarController()

        func makeUIViewController(context: Context) -> some MainTabBarController {
            return feedVC
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

        }
    }
}
