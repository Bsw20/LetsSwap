//
//  UIButton + Extension.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 16.12.2020.
//

import Foundation
import UIKit

extension UIButton {
    convenience init(image: UIImage? = nil, backgroundColor: UIColor, cornerRadius: CGFloat,
                     isShadow: Bool = false, borderColor: UIColor, borderWidth: CGFloat = 1){
        self.init(type: .system)
        if let image = image {
            setImage(image, for: .normal)
        }
        self.backgroundColor = backgroundColor
        layer.cornerRadius = cornerRadius
        self.layer.borderColor = borderColor.cgColor
        layer.masksToBounds = true
        layer.borderWidth = borderWidth
        
        if isShadow {
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 0, height: 4)
        }
    }
    
    static func getLittleRoundButton(backgroundColor: UIColor, text: String?, image: UIImage?, font: UIFont?, textColor: UIColor, disabledBackgroundColor: UIColor = .detailsGrey(), isEnabled: Bool = true) -> UIButton {
        let button = BigYellowButton(type: .system)
        button.setupColors(enabledColor: backgroundColor, disabledColor: disabledBackgroundColor)
        button.setTitle(text, for: .normal)
        button.setImage(image, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.titleLabel?.font = font
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.isEnabled = isEnabled
        return button
    }
    
    static func getSwapButton() -> UIButton{
        let button = UIButton.getLittleRoundButton(backgroundColor: .mainYellow(), text: "Махнуться", image: nil, font: .circeBold(with: 22), textColor: .white)
        return button
    }
    
    static func getLittleRoundButton(text: String) -> UIButton{
        let button = UIButton.getLittleRoundButton(backgroundColor: .mainYellow(), text: text, image: nil, font: .circeBold(with: 22), textColor: .white)
        return button
    }
    
    public static func roundButton(backgroundColor: UIColor, image: UIImage?, cornerRadius: CGFloat) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = backgroundColor
        button.setImage(image, for: .normal)
        button.clipsToBounds = true
        button.layer.cornerRadius = cornerRadius
        return button
    }
    
    public static func getPickerButton() -> UIButton {
        
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "pickerPlus"), for: .normal)
        button.contentMode = .center
        button.clipsToBounds = true
        button.backgroundColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
        return button
    }
    
    public func addActivityIndicator(activityIndicator: UIActivityIndicatorView) {
        self.addSubview(activityIndicator)
        let trailingConstraint = NSLayoutConstraint(item: self,
                                                    attribute: .trailing,
                                                    relatedBy: .equal,
                                                    toItem: activityIndicator,
                                                    attribute: .trailing,
                                                    multiplier: 1, constant: 16)
        self.addConstraint(trailingConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: activityIndicator,
                                                   attribute: .centerY,
                                                   multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
}

private class BigYellowButton: UIButton {
    private var enabledColor: UIColor = .mainYellow()
    private var disabledColor: UIColor = .detailsGrey()
    
    override open var isEnabled: Bool {
        didSet {
            backgroundColor = isEnabled ? enabledColor : disabledColor
        }
    }
    
    public func setupColors(enabledColor: UIColor = .mainYellow(), disabledColor: UIColor = .detailsGrey()) {
        self.enabledColor = enabledColor
        self.disabledColor = disabledColor
    }
}

class LoadingButton: UIButton {
    
    var activityIndicator: UIActivityIndicatorView!
    
    let activityIndicatorColor: UIColor = .black
    
    func loadIndicator(_ shouldShow: Bool) {
        if shouldShow {
            if (activityIndicator == nil) {
                activityIndicator = createActivityIndicator()
            }
            self.isEnabled = false
            self.alpha = 0.7
            showSpinning()
        } else {
            onMainThread {
                self.activityIndicator.stopAnimating()
            }
            self.isEnabled = true
            self.alpha = 1.0
        }
    }
    
    private func createActivityIndicator() -> UIActivityIndicatorView {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = activityIndicatorColor
        return activityIndicator
    }
    
    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        positionActivityIndicatorInButton()
        onMainThread {
            self.activityIndicator.startAnimating()
        }
    }
    
    private func positionActivityIndicatorInButton() {
        let trailingConstraint = NSLayoutConstraint(item: self,
                                                    attribute: .trailing,
                                                    relatedBy: .equal,
                                                    toItem: activityIndicator,
                                                    attribute: .trailing,
                                                    multiplier: 1, constant: 16)
        self.addConstraint(trailingConstraint)
        
        let yCenterConstraint = NSLayoutConstraint(item: self,
                                                   attribute: .centerY,
                                                   relatedBy: .equal,
                                                   toItem: activityIndicator,
                                                   attribute: .centerY,
                                                   multiplier: 1, constant: 0)
        self.addConstraint(yCenterConstraint)
    }
    
}
