//
//  ProfileTopView.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.12.2020.
//

import Foundation
import UIKit

protocol ProfileTopViewModel {
    var profileImage: String? { get }
    var swapsCount: Int { get }
    var raiting: Double { get }
}
class ProfileTopView: UIView {
    private lazy var imageView: WebImageView  = {
        let imageView = WebImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "profileImagePlaceholder")
        return imageView
    }()
    
    private lazy var label1: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        #warning("Множественное число")
        label.text = "Обменов"
        label.textColor = .mainTextColor()
        label.font = UIFont.circeRegular(with: 13)
        return label
    }()
    
    private lazy var label2: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Рейтинг"
        label.textColor = .mainTextColor()
        label.font = UIFont.circeRegular(with: 13)
        return label
    }()
    
    private lazy var swapsCountLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.8666666667, green: 0.7098039216, blue: 0.2352941176, alpha: 1)
//        label.text = "5"
        label.font = UIFont.circeBold(with: 18)
        return label
    }()
    
    private lazy var raitingLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.8666666667, green: 0.7098039216, blue: 0.2352941176, alpha: 1)
//        label.text = "4.5"
        label.font = UIFont.circeBold(with: 18)
        return label
    }()
    
    private lazy var separator: UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
        return view
    }()
    
    private lazy var centerView: UIView = {
        let view = UIView.getRoundView(backgroundColor: .clear, borderWidth: 1, borderColor: #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1).cgColor)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var leftBackView: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    private lazy var rightBackView: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
//    init(topViewModel: ProfileTopViewModel) {
//        super.init(frame: .zero)
//    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConstraints()
        backgroundColor = .clear
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(topViewModel: ProfileTopViewModel) {
        swapsCountLabel.text = "\(topViewModel.swapsCount)"
        raitingLabel.text = String(format: "%.1f", topViewModel.raiting)
        #warning("IMAGE")
    }
    
    private func setupConstraints() {
//        addSubview(separator)
        addSubview(imageView)
        addSubview(centerView)
        centerView.addSubview(separator)
        centerView.addSubview(leftBackView)
        centerView.addSubview(rightBackView)
        leftBackView.addSubview(label1)
        rightBackView.addSubview(label2)
        
        leftBackView.addSubview(swapsCountLabel)
        rightBackView.addSubview(raitingLabel)
        
        NSLayoutConstraint.activate([
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor),
            imageView.widthAnchor.constraint(equalTo: heightAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        #warning("константу в зависимости от экрана")
        NSLayoutConstraint.activate([
            centerView.trailingAnchor.constraint(equalTo: trailingAnchor),
            centerView.topAnchor.constraint(equalTo: topAnchor),
            centerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            centerView.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 35)
        ])
        
        NSLayoutConstraint.activate([
            separator.centerXAnchor.constraint(equalTo: centerView.centerXAnchor),
            separator.bottomAnchor.constraint(equalTo: centerView.bottomAnchor),
            separator.topAnchor.constraint(equalTo: centerView.topAnchor),
            separator.widthAnchor.constraint(equalToConstant: CGFloat(1))
        ])
        
        NSLayoutConstraint.activate([
            leftBackView.leadingAnchor.constraint(equalTo: centerView.leadingAnchor),
            leftBackView.topAnchor.constraint(equalTo: centerView.topAnchor),
            leftBackView.bottomAnchor.constraint(equalTo: centerView.bottomAnchor),
            leftBackView.widthAnchor.constraint(equalTo: centerView.widthAnchor, multiplier: CGFloat(0.49))
        ])
        
        NSLayoutConstraint.activate([
            rightBackView.trailingAnchor.constraint(equalTo: centerView.trailingAnchor),
            rightBackView.topAnchor.constraint(equalTo: centerView.topAnchor),
            rightBackView.bottomAnchor.constraint(equalTo: centerView.bottomAnchor),
            rightBackView.widthAnchor.constraint(equalTo: centerView.widthAnchor, multiplier: CGFloat(0.49))
        ])
        
        NSLayoutConstraint.activate([
            label1.centerXAnchor.constraint(equalTo: leftBackView.centerXAnchor),
            label1.bottomAnchor.constraint(equalTo: leftBackView.bottomAnchor, constant: -3)
        ])
        
        NSLayoutConstraint.activate([
            label2.centerXAnchor.constraint(equalTo: rightBackView.centerXAnchor),
            label2.bottomAnchor.constraint(equalTo: rightBackView.bottomAnchor, constant: -3)
        ])
        
        NSLayoutConstraint.activate([
            swapsCountLabel.centerXAnchor.constraint(equalTo: leftBackView.centerXAnchor),
            swapsCountLabel.bottomAnchor.constraint(equalTo: label1.topAnchor, constant: 6)
        ])
        
        NSLayoutConstraint.activate([
            raitingLabel.centerXAnchor.constraint(equalTo: rightBackView.centerXAnchor),
            raitingLabel.bottomAnchor.constraint(equalTo: label2.topAnchor, constant: 6)
        ])
    }
}

// MARK: - SwiftUI
import SwiftUI

struct ProfileTopViewProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let alienProfileVC = MainTabBarController()

        func makeUIViewController(context: Context) -> some MainTabBarController {
            return alienProfileVC
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

        }
    }
}


