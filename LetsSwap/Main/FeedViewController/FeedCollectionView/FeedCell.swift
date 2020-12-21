//
//  FeedCell.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 17.12.2020.
//

import Foundation
import UIKit

protocol FeedCellViewModel {
    var title: String { get }
    var description: String { get }
    var counterOffer: String { get }
    var photo: URL? { get }
    var isFavourite: Bool { get }
    var isFree: Bool { get }
}

protocol FeedCellDelegate: AnyObject {
    func favouriteButtonDidTapped(indexPath: IndexPath)
}

final class FeedCell: UICollectionViewCell {
    static let reuseId = "FeedCell"
//    private let cellModel: FeedCellViewModel
    private var indexPath: IndexPath!
    weak var delegate: FeedCellDelegate?
    
    private let containerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 15,weight: .regular)
        return label
    }()
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.backgroundColor = .clear
        label.font = UIFont.systemFont(ofSize: 14,weight: .thin)
        label.textAlignment = .natural
        return label
    }()
    
    private lazy var imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private lazy var favouriteButton: UIButton = {
        let button = UIButton.init(image: UIImage(named: "tabIcon"), backgroundColor: .white, cornerRadius: 1, isShadow: true, borderColor: .black, borderWidth: 0)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = FeedConstants.favouriteButtonSize.height / 2
        button.clipsToBounds = true

        
        return button
    }()
    
    @objc private func favouriteButtonTapped() {
        delegate?.favouriteButtonDidTapped(indexPath: self.indexPath)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainBackground()
        
        addSubview(containerView)
        containerView.fillSuperview()
        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
//        self.layer.shadowColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
//        self.layer.shadowRadius = 3
//        self.layer.shadowOpacity = 0.5
//        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.layer.cornerRadius = 21
        self.containerView.clipsToBounds = true
        print("layout subviews")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(cellModel: FeedCellViewModel, indexPath: IndexPath) {
        titleLabel.text = cellModel.title
        self.indexPath = indexPath
        if cellModel.isFavourite {
            favouriteButton.backgroundColor = #colorLiteral(red: 0.4321040969, green: 0.2213571924, blue: 0.840117021, alpha: 1)
        }
        
        if cellModel.isFree {
            containerView.backgroundColor = .freeFeedCell()
        }
        
        if let userURL = cellModel.photo {
            //TODO: подгрузка фотографии
            imageView.image = UIImage(named: "personImage")
            imageTypeConstraints()
        } else {
            descriptionLabel.text = cellModel.description
            descriptionTypeConstraints()
        }
        
    }
    override func prepareForReuse() {
        imageView.image = nil
        containerView.backgroundColor = .white
        favouriteButton.backgroundColor = .white
    }
}

//MARK: - Constraints
extension FeedCell {
    private func imageTypeConstraints() {
        containerView.addSubview(titleLabel)
        containerView.addSubview(imageView)

        imageView.addSubview(favouriteButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: FeedConstants.titleFeedCellInset.top),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: FeedConstants.titleFeedCellInset.left),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -FeedConstants.titleFeedCellInset.right)
        ])

        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: FeedConstants.titleFeedCellInset.bottom)
//            imageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        NSLayoutConstraint.activate([
            favouriteButton.heightAnchor.constraint(equalToConstant: FeedConstants.favouriteButtonSize.height),
            favouriteButton.widthAnchor.constraint(equalToConstant: FeedConstants.favouriteButtonSize.width),
            favouriteButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -(FeedConstants.favoutiteButtonInset.bottom)),
            favouriteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -FeedConstants.favoutiteButtonInset.right)

        ])
    }
    
//    private func imageTypeConstraints() {
//        let clearView = UIView()
//        clearView.backgroundColor = .clear
//        containerView.addSubview(titleLabel)
//        containerView.addSubview(imageView)
//
//        titleLabel.addSubview(clearView)
//
//        clearView.addSubview(favouriteButton)
//
//        NSLayoutConstraint.activate([
//            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: FeedConstants.titleFeedCellInset.top),
//            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: FeedConstants.titleFeedCellInset.left),
//            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -FeedConstants.titleFeedCellInset.right)
//        ])
//
//        NSLayoutConstraint.activate([
//            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
//            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
//            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
//            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: FeedConstants.titleFeedCellInset.bottom)
////            imageView.heightAnchor.constraint(equalToConstant: 50)
//        ])
//
//        NSLayoutConstraint.activate([
//            clearView.topAnchor.constraint(equalTo: containerView.topAnchor),
//            clearView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
//            clearView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
//            clearView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
//        ])
//
//        NSLayoutConstraint.activate([
//            favouriteButton.heightAnchor.constraint(equalToConstant: FeedConstants.favouriteButtonSize.height),
//            favouriteButton.widthAnchor.constraint(equalToConstant: FeedConstants.favouriteButtonSize.width),
//            favouriteButton.bottomAnchor.constraint(equalTo: clearView.bottomAnchor, constant: -(FeedConstants.favoutiteButtonInset.bottom)),
//            favouriteButton.trailingAnchor.constraint(equalTo: clearView.trailingAnchor, constant: -FeedConstants.favoutiteButtonInset.right)
//
//        ])
//    }
    
    private func descriptionTypeConstraints() {
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(favouriteButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: FeedConstants.titleFeedCellInset.top),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: FeedConstants.titleFeedCellInset.left),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -FeedConstants.titleFeedCellInset.right)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.bottomAnchor.constraint(lessThanOrEqualTo: containerView.bottomAnchor, constant: -FeedConstants.descriptionFeedCellInset.bottom),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: FeedConstants.descriptionFeedCellInset.left),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -FeedConstants.descriptionFeedCellInset.right),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: FeedConstants.titleFeedCellInset.bottom)
        ])
        
        NSLayoutConstraint.activate([
            favouriteButton.heightAnchor.constraint(equalToConstant: FeedConstants.favouriteButtonSize.height),
            favouriteButton.widthAnchor.constraint(equalToConstant: FeedConstants.favouriteButtonSize.width),
            favouriteButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -(FeedConstants.favoutiteButtonInset.bottom)),
            favouriteButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -FeedConstants.favoutiteButtonInset.right)

        ])
    }
    
}

// MARK: - SwiftUI
import SwiftUI

struct FeedCellProvider: PreviewProvider {
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
