//
//  ChangePropertyView.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 31.12.2020.
//

import Foundation
import UIKit

protocol ChangePropertyViewDelegate: NSObjectProtocol {
    func editButtonTapped(view: ChangePropertyView, currentProperty: String)
}

class ChangePropertyView: UIView {
    enum PropertyType {
        case city(data: String)
        case phoneNumber(data: String)
        
        func getPlaceholder() -> String {
            switch self {
            
            case .city:
                return "Город"
            case .phoneNumber:
                return "Телефон"
            }
        }
    }
    //MARK: - Controls
    private lazy var propertyLabel: UILabel = UILabel.getNormalLabel(fontSize: 17, text: "")
    
    
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
    
    
    //MARK: - Variables
    weak var delegate: ChangePropertyViewDelegate?
    private var currentProperty: String = ""
    private var propertyType: PropertyType
    
    init(propertyType: PropertyType) {
        self.propertyType = propertyType
        super.init(frame: .zero)
        
        switch propertyType {
        
        case .city(data: let data):
            self.setProperty(property: data)
        case .phoneNumber(data: let data):
            self.setProperty(property: data)
        }
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .detailsGrey()
        propertyLabel.backgroundColor = .clear
        setupConstraints()
        editButton.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        
        
    }
    
    //MARK: - funcs
    public func isEmpty() -> Bool {
        return currentProperty.isEmpty
    }
    public func setProperty(property: String) {
        currentProperty = property
        if property == "" {
            propertyLabel.text = propertyType.getPlaceholder()
            propertyLabel.textColor = .greyTextColor()
        } else {
            propertyLabel.text = property
            propertyLabel.textColor = .mainTextColor()
        }
    }
    
    public func getCurrentProperty() -> String {
        return currentProperty
    }
    //MARK: - Objc funcs
    @objc private func editButtonTapped() {
        print("edit button tapped")
//        delegate?.editButtonTapped(currentCity: currentCity)
        delegate?.editButtonTapped(view: self, currentProperty: currentProperty)
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
extension ChangePropertyView {
    private func setupConstraints() {
        addSubview(propertyLabel)
        addSubview(arrowImageView)
        addSubview(editButton)
        
        NSLayoutConstraint.activate([
            arrowImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            arrowImageView.heightAnchor.constraint(equalToConstant: 8),
            arrowImageView.widthAnchor.constraint(equalToConstant: 4)
        ])
        

        let editButtonSize = "Изменить".sizeOfString(usingFont: UIFont.circeRegular(with: 16))
        
        NSLayoutConstraint.activate([
            editButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            editButton.trailingAnchor.constraint(equalTo: arrowImageView.leadingAnchor, constant: -5),
            editButton.heightAnchor.constraint(equalToConstant: editButtonSize.height),
            editButton.widthAnchor.constraint(equalToConstant: editButtonSize.width)
            
        ])
        
        NSLayoutConstraint.activate([
            propertyLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            propertyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 19),
            propertyLabel.trailingAnchor.constraint(equalTo: editButton.leadingAnchor, constant: -10)
        ])
    }
}
