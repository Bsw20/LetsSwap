//
//  CityView.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 31.12.2020.
//

import Foundation
import UIKit

class CityView: UIView {
    private lazy var label1: UILabel = UILabel.getNormalLabel(fontSize: 17, text: "Город", textColor: .greyTextColor())
    
    private lazy var cityLabel: UILabel = UILabel.getNormalLabel(fontSize: 17, text: "")
    
    private lazy var arrowImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "arrowIcon")?.withTintColor(.detailsYellow()))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var editButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Изменить", for: .normal)
        button.setTitleColor(.detailsYellow(), for: .normal)
        button.titleLabel?.font  = UIFont.circeRegular(with: 16)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.backgroundColor = .clear
        
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .detailsGrey()
        label1.backgroundColor = .clear
        setupConstraints()
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
    }
    
    @objc private func editButtonTapped() {
        print("edit button tapped")
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = 10
        clipsToBounds = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Constraints
extension CityView {
    private func setupConstraints() {
        addSubview(label1)
        
        NSLayoutConstraint.activate([
            label1.centerYAnchor.constraint(equalTo: centerYAnchor),
            label1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19),
            label1.widthAnchor.constraint(equalToConstant: "Город".sizeOfString(usingFont: .circeRegular(with: 17)).width)
        ])
        
        addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            arrowImageView.heightAnchor.constraint(equalToConstant: 8),
            arrowImageView.widthAnchor.constraint(equalToConstant: 4)
        ])
        

        
        addSubview(editButton)
        let editButtonSize = "Изменить".sizeOfString(usingFont: UIFont.circeRegular(with: 16))

        
        NSLayoutConstraint.activate([
            editButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -5),
            editButton.heightAnchor.constraint(equalToConstant: editButtonSize.height),
            editButton.widthAnchor.constraint(equalToConstant: editButtonSize.width)
            
        ])
        
        addSubview(cityLabel)
        
        NSLayoutConstraint.activate([
            cityLabel.leadingAnchor.constraint(equalTo: label1.trailingAnchor, constant: 15),
            cityLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            cityLabel.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -5)
        ])

        
        
    }
}
