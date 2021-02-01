//
//  CreateOrderCell.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 24.01.2021.
//

import Foundation
import UIKit


protocol CreateOrderCellDelegate: NSObjectProtocol {
    func createOrderButtonTapped()
}

class CreateOrderCell: UICollectionViewCell {
    public static var reuseId = "CreateOrderCell"
    
    weak var delegate: CreateOrderCellDelegate?
    
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
        label.numberOfLines = 2
        label.backgroundColor = .clear
        label.font = UIFont.circeRegular(with: 13)
        label.textColor = #colorLiteral(red: 0.7294117647, green: 0.7294117647, blue: 0.7294117647, alpha: 1)
        label.text = "Добавь свое первое предложение"
        label.textAlignment = .center
        label.clipsToBounds = true
        label.isUserInteractionEnabled = false
        return label
    }()
    
    private var addOrderButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "pickerPlus"), for: .normal)
        button.contentMode = .center
        button.clipsToBounds = true
        button.backgroundColor = .clear
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainBackground()
        
        addOrderButton.addTarget(self, action: #selector(addOrderButtonTapped), for: .touchUpInside)
        
        addSubview(containerView)
        containerView.fillSuperview()
        setupConstraints()
        
    }
    @objc private func addOrderButtonTapped() {
        delegate?.createOrderButtonTapped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.containerView.layer.cornerRadius = 21
        self.containerView.clipsToBounds = true
    }
}

//MARK: - Constraints
extension CreateOrderCell {
    private func setupConstraints() {
        containerView.addSubview(titleLabel)
        containerView.addSubview(addOrderButton)
        #warning("Top offset сделать рассчет(чтобы нормально отобр на все экранах)")
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        NSLayoutConstraint.activate([
            addOrderButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            addOrderButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            addOrderButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            addOrderButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor)

        ])
    }
}
