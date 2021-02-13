//
//  OrderTitleView.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 22.12.2020.
//

import Foundation
import UIKit

protocol OrderTitleViewModel {
    var userName: String { get }
    var userLastName: String { get }
    var userPhoto: URL? { get }
    var userCity: String { get }
}

class OrderTitleView: UIView {
    private var imageView: WebImageView = {
       let view = WebImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "personImage")
        return view
    }()
    private var nameLabel: UILabel = {
       let label = UILabel()
        label.text = "Настя Якимова"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.circeRegular(with: 20)
        label.textColor = #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
        return label
    }()
    private var cityLabel: UILabel = {
        let label = UILabel()
        label.text = "Санкт-Петербург"
        label.font = UIFont.circeRegular(with: 16)
        label.textColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = FeedOrderConstants.userImageHeight / 2
    }
    func configure(model: OrderTitleViewModel) {
        nameLabel.text = "\(model.userName) \(model.userLastName)"
        cityLabel.text = model.userCity
        imageView.set(imageURL: model.userPhoto?.absoluteString)
    }
}

//MARK: - Constraints
extension OrderTitleView {
    private func setupConstraints() {
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(cityLabel)
        
        NSLayoutConstraint.activate([
            imageView.heightAnchor.constraint(equalToConstant: FeedOrderConstants.userImageHeight),
            imageView.widthAnchor.constraint(equalToConstant: FeedOrderConstants.userImageHeight),
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: FeedOrderConstants.TopView.imageLabelDistance),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: FeedOrderConstants.TopView.nameLabelTopOffset)
        ])
        
        NSLayoutConstraint.activate([
            cityLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: FeedOrderConstants.TopView.imageLabelDistance),
            cityLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: FeedOrderConstants.TopView.cityLabelBottomInset)
        ])
        
        
    }
}

// MARK: - SwiftUI
import SwiftUI

struct TitleViewFOVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let feedOrderVC = MainTabBarController()

        func makeUIViewController(context: Context) -> some MainTabBarController {
            return feedOrderVC
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

        }
    }
}


