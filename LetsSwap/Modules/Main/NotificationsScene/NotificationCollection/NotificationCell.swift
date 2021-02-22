//
//  NotificationCell.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.01.2021.
//

import Foundation
import UIKit
import SnapKit


protocol NotificationCellDelegate: NSObjectProtocol {
    func refuseButtonTapped(cell: NotificationCell)
    func swapButtonTapped(cell: NotificationCell)
}

class NotificationCell: UICollectionViewCell {
    typealias NotificationType = Notification.NotificationType
    //MARK: - Variables
    weak var customDelegate: NotificationCellDelegate?
    //MARK: - Controls
    private let containerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    private var imageView: WebImageView = {
       let view = WebImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.768627451, green: 0.768627451, blue: 0.768627451, alpha: 1)
        return view
    }()
    
    private var nameLabel: UILabel = {
       let label = UILabel()
        label.text = "Максим Малышкин"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.circeRegular(with: 20)
        label.textColor = #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Хочет с вами махнуться на «Вышивка из стекла»"
        label.font = UIFont.circeRegular(with: 16)
        label.textColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        return label
    }()
    
    private var commentLabel: UILabel = {
        let label = UILabel()
        label.text = "Комментарий к обмену: очень красиво, хочу одну для своей сестры,  посмотри мои предложения, махнёмся на любое"
        label.font = UIFont.circeRegular(with: 16)
        label.textColor = #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        return label
    }()
    
    private var refuseButton: UIButton = {
        let button = LittleRoundButton.newButton(backgroundColor: .mainYellow(), text: "Отклонить", image: nil, font: .circeRegular(with: 13), textColor: .white)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1)
        return button
    }()
    
    private var yellowButton: UIButton = {
        let button = LittleRoundButton.newButton(backgroundColor: .mainYellow(), text: "Махнуться", image: nil, font: .circeRegular(with: 13), textColor: .white)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var chatImageView: UIImageView = {
       let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        view.image = #imageLiteral(resourceName: "matchedChatIcon")
        return view
    }()
    
    //MARK: - variables
    private var notificationType: NotificationType! {
        didSet {
            switch notificationType {
            case .mvpVersion(model: let model):
                nameLabel.text = String.username(name: model.name, lastname: model.lastname)
                commentLabel.text = model.comment
                descriptionLabel.text = model.description
                imageView.set(imageURL: model.image)
            default:
                break
            }
        }
    }
    static let reuseId = "NotificationCell"

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainBackground()
        containerView.backgroundColor = .clear
        
        
        addSubview(containerView)
        containerView.fillSuperview()
        
        yellowButton.addTarget(self, action: #selector(yellowButtonTapped), for: .touchUpInside)
        refuseButton.addTarget(self, action: #selector(refuseButtonTapped), for: .touchUpInside)
    }
    
    @objc private func yellowButtonTapped() {
//        switch notificationType {
//        case .unmatched:
//            print("unmatched")
//        case .matched:
//            print("matched")
//        case .mvpVersion:
//            print("mvp version")
//        case .none:
//            print("none")
//        }
        
        customDelegate?.swapButtonTapped(cell: self)
    }
    
    @objc private func refuseButtonTapped() {
//        switch notificationType {
//        case .unmatched:
//            print("unmatched")
//        case .matched:
//            print("matched")
//        case .mvpVersion:
//            print("mvp version")
//        case .none:
//            print("none")
//        }
        
        customDelegate?.refuseButtonTapped(cell: self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func set(notificationType: NotificationType) {
        self.notificationType = notificationType
        setupConstraints()
    }
    
    override func layoutSubviews() {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = NotificationSceneConstants.imageViewHeight / 2
    }
}

//MARK: - Constraints
extension NotificationCell {
    private func setupConstraints() {
        containerView.addSubview(imageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(commentLabel)
        containerView.addSubview(yellowButton)
        
        imageView.anchor(top: containerView.topAnchor,
                         leading: containerView.leadingAnchor,
                         bottom: nil,
                         trailing: nil,
                         size: CGSize(width: NotificationSceneConstants.imageViewHeight, height: NotificationSceneConstants.imageViewHeight))
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: containerView.topAnchor),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: NotificationSceneConstants.labelsLeadingOffset)
        ])
        
        #warning("TODO: description label trailing anchor fix")
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: NotificationSceneConstants.firstGapHeight),
            descriptionLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: NotificationSceneConstants.labelsLeadingOffset),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -100)
        ])
        #warning("TODO: description label trailing anchor fix")
        NSLayoutConstraint.activate([
            commentLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: NotificationSceneConstants.secondGapHeight),
            commentLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: NotificationSceneConstants.labelsLeadingOffset),
            commentLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
        
//        NSLayoutConstraint.activate([
//            yellowButton.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: NotificationSceneConstants.labelsLeadingOffset),
//                                        yellowButton.heightAnchor.constraint(equalToConstant: 40),
//            yellowButton.topAnchor.constraint(equalTo: commentLabel.bottomAnchor,constant: NotificationSceneConstants.thirdGapHeight)
//        ])
        
        
        switch notificationType {
        case .matched:
            containerView.addSubview(chatImageView)
            chatImageView.anchor(top: containerView.topAnchor,
                                 leading: nil,
                                 bottom: nil,
                                 trailing: trailingAnchor,
                                 size: NotificationSceneConstants.chatImageViewSize)
            nameLabel.trailingAnchor.constraint(equalTo: chatImageView.leadingAnchor, constant: -15).isActive = true
            yellowButton.setTitle("Перейти в чат", for: .normal)
            yellowButton.widthAnchor.constraint(equalToConstant: ("Перейти в чат".sizeOfString(usingFont: UIFont.circeRegular(with: 13))).width + 14 * 2).isActive = true
            
        case .unmatched:
            yellowButton.setTitle("Посмотреть предложения Максима", for: .normal)
            yellowButton.widthAnchor.constraint(equalToConstant: ("Посмотреть предложения Максима".sizeOfString(usingFont: UIFont.circeRegular(with: 13))).width + 14 * 2).isActive = true
        case .mvpVersion:
            let stackView = UIStackView(arrangedSubviews: [refuseButton, yellowButton], axis: .horizontal, spacing: 14)
            stackView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(stackView)
            
            stackView.snp.makeConstraints { (make) in
                make.left.right.equalTo(commentLabel)
                make.height.equalTo(40)
            }
            stackView.topAnchor.constraint(equalTo: commentLabel.bottomAnchor,constant: NotificationSceneConstants.thirdGapHeight).isActive = true
            
            
            break
        case .none:
            break
        }
        
        
        
    }
}

// MARK: - SwiftUI
import SwiftUI

struct NotificationCellProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let notifVC = MainTabBarController()

        func makeUIViewController(context: Context) -> some MainTabBarController {
            return notifVC
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

        }
    }
}


