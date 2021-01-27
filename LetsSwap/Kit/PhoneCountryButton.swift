//
//  PhoneCountryButton.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.01.2021.
//

import Foundation
import UIKit

class PhoneCountryButton: UIButton {
    private lazy var countryImageView: UIImageView = {
       let imageView = UIImageView(image: UIImage(named: "RU-ICON"))
        imageView.backgroundColor = .clear
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var countryLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "Россия"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.circeRegular(with: 20)
        label.textColor = .mainTextColor()
        return label
    }()
    
    private lazy var arrowView: UIImageView = {
       let view = UIImageView(image: UIImage(named: "arrowIcon"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func layoutSubviews() {
        setupConstraints()
    }
}

//MARK: - Constraints
extension PhoneCountryButton {
    private func setupConstraints() {
        addSubview(countryImageView)
        addSubview(countryLabel)
        addSubview(arrowView)
        
        NSLayoutConstraint.activate([
            countryImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            countryImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            countryImageView.widthAnchor.constraint(equalToConstant: 20),
            countryImageView.heightAnchor.constraint(equalToConstant: 16)
        ])
        
        NSLayoutConstraint.activate([
            countryLabel.leadingAnchor.constraint(equalTo: countryImageView.trailingAnchor, constant: 5),
            countryLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            arrowView.leadingAnchor.constraint(equalTo: countryLabel.trailingAnchor, constant: 5),
            arrowView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 2),
            arrowView.widthAnchor.constraint(equalToConstant: 4),
            arrowView.heightAnchor.constraint(equalToConstant: 8)
        ])
    }
}
