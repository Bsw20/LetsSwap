//
//  NameCityLabel.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 28.12.2020.
//

import Foundation
import UIKit

class NameCityLabel: UILabel {
    private lazy var nameLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .mainTextColor()
        label.font = UIFont.circeRegular(with: 22)
        label.text = "Настя Якимова"
        label.backgroundColor = .clear
        return label
    }()
    
    private lazy var cityLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
        label.font = UIFont.circeRegular(with: 17)
        label.text = "г. Санкт-Петербург"
        label.backgroundColor = .clear
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(name: String, city: String) {
        nameLabel.text = name
        cityLabel.text = "г. \(city)"
    }
    
    private func setupConstraints() {
        addSubview(nameLabel)
        addSubview(cityLabel)
        
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: topAnchor)
        ])
        
        NSLayoutConstraint.activate([
            cityLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 5),
            cityLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: cityLabel.bottomAnchor)
        ])
        
    }
}

// MARK: - SwiftUI
import SwiftUI

struct NameCityLabelProvider: PreviewProvider {
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
