//
//  RatingView.swift
//  LetsSwap
//
//  Created by Владимир Моторкин on 03.05.2022.
//

import Foundation
import UIKit
import FloatRatingView

protocol RatingProtocol {
    func setRating(rating: Int)
}

class RatingView: UIView {
    let ratingView = FloatRatingView()
    
    let setButton: UIButton = {
        let button = LittleRoundButton.newButton(backgroundColor: .mainYellow(), text: "Оценить", image: nil, font: .circeRegular(with: 22), textColor: .white)
        return button
    }()
    
    var delegate: RatingProtocol!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .mainBackground()
        ratingView.minRating = 1
        ratingView.tintColor = .mainYellow()
        ratingView.emptyImage = UIImage(systemName: "star")?.withRenderingMode(.alwaysTemplate)
        ratingView.fullImage = UIImage(systemName: "star.fill")?.withRenderingMode(.alwaysTemplate)
        setButton.addTarget(self, action: #selector(setButtonTapped), for: .touchUpInside)
    }
    
    func setupConstraints() {
        
        addSubview(ratingView)
        ratingView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            ratingView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            ratingView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            ratingView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        addSubview(setButton)
        setButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            setButton.topAnchor.constraint(equalTo: self.ratingView.bottomAnchor, constant: 20),
            setButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            setButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            setButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
        ])
    }
    
    @objc func setButtonTapped() {
        delegate.setRating(rating: Int(ratingView.rating))
    }
}
