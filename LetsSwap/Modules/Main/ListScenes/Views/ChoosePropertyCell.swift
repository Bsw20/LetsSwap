//
//  ChoosePropertyCell.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 22.01.2021.
//

import Foundation
import UIKit

class ChoosePropertyCell: UICollectionViewCell {
    public static var reuseId = "ChoosePropertyCell"
    
    private var propertyLabel: UILabel = {
       let label = UILabel()
        label.text = "Город"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.circeRegular(with: 22)
        label.textColor = #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
        return label
    }()
    
    private lazy var tickImageView: UIImageView = {

        let view = UIImageView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var divider: UIView = {
        let view = UIView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainBackground()
        setupConstraints()
    }
    
    func set(property: String, selected: Bool) {
        propertyLabel.text = property
        if selected {
            setSelected()
        } else {
            setDeselected()
        }

    }
    
    func setSelected() {
        tickImageView.image = #imageLiteral(resourceName: "tick")
    }
    func setDeselected() {
        tickImageView.image = #imageLiteral(resourceName: "unselectedTick")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Constraints
extension ChoosePropertyCell {
    private func setupConstraints() {
        addSubview(propertyLabel)
        addSubview(tickImageView)
        addSubview(divider)
        
        NSLayoutConstraint.activate([
            tickImageView.widthAnchor.constraint(equalToConstant: 18),
            tickImageView.heightAnchor.constraint(equalToConstant: 13),
            tickImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            tickImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -17)
        ])
        
        NSLayoutConstraint.activate([
            propertyLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            propertyLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            propertyLabel.trailingAnchor.constraint(equalTo: tickImageView.leadingAnchor, constant: -25)
        ])
        
        NSLayoutConstraint.activate([
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.leadingAnchor.constraint(equalTo: propertyLabel.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: tickImageView.trailingAnchor)
        ])
    }
}
