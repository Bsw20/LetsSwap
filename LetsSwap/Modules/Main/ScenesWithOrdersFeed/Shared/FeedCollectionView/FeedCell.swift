//
//  FeedCell.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 17.12.2020.
//

import Foundation
import UIKit
import SwiftyBeaver

protocol BaseFeedCellViewModel {
    var title: String { get }
    var counterOffer: String { get }
    var photo: URL? { get }
    var isFree: Bool { get }
}


protocol FeedCellDelegate: AnyObject {
    func favouriteButtonDidTapped(cell: FeedCell)
}

final class FeedCell: UICollectionViewCell {
    enum FeedCellType {
        case mainFeedCell(cellViewModel: FeedViewModel.Cell)
        case myProfileCell(cellViewModel: MyProfileViewModel.FeedModel.Cell)
    }
    
    private var titleLabelHeightAnchor: NSLayoutConstraint!
    static let reuseId = "FeedCell"
    private var cellModel: BaseFeedCellViewModel?
    weak var delegate: FeedCellDelegate?
    
    private let containerView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.clipsToBounds = false
        

        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.backgroundColor = .clear
        label.font = UIFont.circeBold(with: 15)
        label.textColor = .mainTextColor()
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
    
    private lazy var imageView: WebImageView = {
       let imageView = WebImageView()
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
        button.isHidden = true

        
        return button
    }()
    
    private lazy var hiddenView: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.85)
        view.clipsToBounds = true
        #warning("Убрать константу")
        let label = UILabel()
        label.text = "Предложение скрыто"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.circeBold(with: 15)
        label.textColor = .mainTextColor()
        label.numberOfLines = 2
        label.textAlignment = .center
        
        view.addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35)
        ])
        return view
    }()
    
    
    
    @objc private func favouriteButtonTapped() {
        delegate?.favouriteButtonDidTapped(cell: self)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainBackground()
        
        addSubview(containerView)
        containerView.fillSuperview()
        favouriteButton.addTarget(self, action: #selector(favouriteButtonTapped), for: .touchUpInside)
        
    }
    override func layoutSubviews() {

        self.containerView.layer.cornerRadius = 21
//        self.containerView.clipsToBounds = true
        self.containerView.layer.masksToBounds = true
        
        containerView.layer.shadowColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        containerView.layer.shadowRadius = 3
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        titleLabel.text = cellModel?.title
        descriptionLabel.text = cellModel?.counterOffer
        if let userURL = cellModel?.photo {
            //TODO: подгрузка фотографии
//            imageView.image = UIImage(named: "personImage")
            imageView.set(imageURL: userURL.absoluteString)
            imageTypeConstraints()
        } else {
            descriptionTypeConstraints()
        }

        
        
        if let cellModel = cellModel {
            if (cellModel.isFree) {
                containerView.backgroundColor = .freeFeedCell()
            }
        }
        
        
        titleLabelHeightAnchor = titleLabel.heightAnchor.constraint(equalToConstant: calculateTitleLabelHeight())
        titleLabelHeightAnchor.priority = UILayoutPriority(750)
        titleLabelHeightAnchor.isActive = true
        print(titleLabel.text)
        print(calculateTitleLabelHeight())
        super.layoutSubviews()
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(cellType: FeedCellType) {
        switch cellType {
        
        case .mainFeedCell(cellViewModel: let cellViewModel):
            favouriteButton.isHidden = false
            hiddenView.isHidden = true
            if cellViewModel.isFavourite {
                setFavourite()
            }
            setupCell(cellModel: cellViewModel)
            
        case .myProfileCell(cellViewModel: let cellViewModel):
            if cellViewModel.isHidden {
                hiddenView.isHidden = false
            } else {
                hiddenView.isHidden = true
            }
            setupCell(cellModel: cellViewModel)
        }
    }
    
    private func setupCell(cellModel: BaseFeedCellViewModel) {
        self.cellModel = cellModel

    }
    
    override func prepareForReuse() {
        imageView.resetUrl()
        titleLabel.text = ""
        containerView.backgroundColor = .white
        setUnfavourite()
        hiddenView.isHidden = true
    }
    
    private func setUnfavourite() {
        favouriteButton.setImage(UIImage(named: "tabIcon"), for: .normal)
    }
    
    private func setFavourite() {
        favouriteButton.setImage(UIImage(named: "tabIconFilled"), for: .normal)
    }
}

//MARK: - Constraints
extension FeedCell {
    private func calculateTitleLabelHeight() -> CGFloat{
        guard let titleLabelText = titleLabel.text else {
        SwiftyBeaver.error("Text must allways be in here")
        fatalError("Text must allways be in here")
    }
        let textHeight = titleLabelText.height(width: bounds.width - FeedConstants.titleFeedCellInset.left - FeedConstants.titleFeedCellInset.right , font: titleLabel.font)
        let lineHeight = titleLabel.font.lineHeight
        let numberOfLines = (textHeight / lineHeight) >= CGFloat(titleLabel.numberOfLines) ? titleLabel.numberOfLines : Int(textHeight / lineHeight)
        
        let titleLabelHeight = CGFloat(numberOfLines) * lineHeight
        return titleLabelHeight
    }
    private func imageTypeConstraints() {

        containerView.addSubview(titleLabel)
        containerView.addSubview(imageView)

        imageView.addSubview(favouriteButton)
//        let titleLabelHeight = calculateTitleLabelHeight()
//        print(titleLabel.text)
//        print(titleLabelHeight)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: FeedConstants.titleFeedCellInset.top),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: FeedConstants.titleFeedCellInset.left),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -FeedConstants.titleFeedCellInset.right)
        ])

//        let titleHeightCons = titleLabel.heightAnchor.constraint(equalToConstant: titleLabelHeight)
//        titleHeightCons.priority = UILayoutPriority(750)
//        titleHeightCons.isActive = true
        

        NSLayoutConstraint.activate([
            imageView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: FeedConstants.titleFeedCellInset.bottom)
            
        ])
        NSLayoutConstraint.activate([
            favouriteButton.heightAnchor.constraint(equalToConstant: FeedConstants.favouriteButtonSize.height),
            favouriteButton.widthAnchor.constraint(equalToConstant: FeedConstants.favouriteButtonSize.width),
            favouriteButton.bottomAnchor.constraint(equalTo: imageView.bottomAnchor, constant: -(FeedConstants.favoutiteButtonInset.bottom)),
            favouriteButton.trailingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: -FeedConstants.favoutiteButtonInset.right)

        ])
        
        containerView.addSubview(hiddenView)
        hiddenView.fillSuperview()
        
    }
    
    private func descriptionTypeConstraints() {
        let titleLabelHeight = calculateTitleLabelHeight()
//        print(titleLabel.text)
//        print(titleLabelHeight)
        containerView.addSubview(titleLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(favouriteButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: containerView.topAnchor, constant: FeedConstants.titleFeedCellInset.top),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: FeedConstants.titleFeedCellInset.left),
//            titleLabel.heightAnchor.constraint(equalToConstant: titleLabelHeight),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -FeedConstants.titleFeedCellInset.right)
        ])
//        let titleHeightCons = titleLabel.heightAnchor.constraint(equalToConstant: titleLabelHeight)
//        titleHeightCons.priority = UILayoutPriority(750)
//        titleHeightCons.isActive = true
        
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
        containerView.addSubview(hiddenView)
        hiddenView.fillSuperview()
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
