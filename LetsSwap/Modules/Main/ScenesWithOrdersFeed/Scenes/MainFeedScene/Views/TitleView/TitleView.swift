//
//  TitleView.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 16.12.2020.
//

import Foundation
import UIKit

protocol TitleViewDelegate: AnyObject {
    func cityButtonTapped()
    func textDidChange(newText: String)
}

class TitleView: UIView {
    weak var customDelegate: TitleViewDelegate?
    
    private var myTextField = InsertableTextField()
    private var cityButton = UIButton.init(image: UIImage(named: "cityImage"), backgroundColor: .white, cornerRadius: 1, isShadow: true, borderColor: .lightGray, borderWidth: 0.5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        translatesAutoresizingMaskIntoConstraints = false
        cityButton.translatesAutoresizingMaskIntoConstraints = false
        cityButton.addTarget(self, action: #selector(cityButtonTapped), for: .touchUpInside)
        myTextField.customDelegate = self
        
        addSubview(myTextField)
        addSubview(cityButton)
        makeConstraints()
    }
    
    @objc private func cityButtonTapped() {
        customDelegate?.cityButtonTapped()
    }
    
    private func makeConstraints(){
        //myAvatarView constraints
        cityButton.anchor(top: topAnchor,
                            leading: nil,
                            bottom: nil,
                            trailing: trailingAnchor,
                            padding: UIEdgeInsets(top: 2, left: 777, bottom: 777, right: 4))
        cityButton.heightAnchor.constraint(equalTo: myTextField.heightAnchor, multiplier: 1).isActive = true
        cityButton.widthAnchor.constraint(equalTo: myTextField.heightAnchor, multiplier: 1).isActive = true
        
        // myTextField constraints
        myTextField.anchor(top: topAnchor,
                           leading: leadingAnchor,
                           bottom: bottomAnchor,
                           trailing: cityButton.leadingAnchor,
                           padding: UIEdgeInsets(top: 2, left: 2, bottom: 2, right: 12))
        
    }
    
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cityButton.layer.masksToBounds = true
        cityButton.layer.cornerRadius = cityButton.frame.width / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getTextFieldText() -> String {
        return myTextField.text ?? ""
    }
}

extension TitleView: InsertableTextFieldDelegate {
    func didChange(newText: String) {
        customDelegate?.textDidChange(newText: newText)
    }
    
}