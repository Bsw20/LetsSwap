//
//  RequestSentViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 24.12.2020.
//

import Foundation
import UIKit

//protocol RequestSentDelegate: AnyObject {
//    func sentButtonTapped()
//}

class RequestSentViewController: UIViewController {
    
//    weak var delegate: RequestSentDelegate?
    
    private lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
        label.font = UIFont.circeRegular(with: 22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Твой запрос отправлен"
        return label
    }()
    private lazy var tickImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "tick")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var descriptionLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.circeRegular(with: 18)
        label.textColor = .mainTextColor()
        label.text = "Скоро человек на другом конце провода увидит в оповещениях, что ты предлагаешь обмен и свяжется с тобой теми способами связи, которые ты указал в личном кабинете, если он тоже заинтерисуется в обмене."
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var handImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.image = UIImage(named: "hand")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private lazy var goBackButton: UIButton = {
        let button = UIButton.getLittleRoundButton(text: "Вернуться в ленту" )
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground()
        setupConstraints()
        goBackButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    @objc private func buttonTapped() {
        navigationController?.popToRootViewController(animated: true)
    }
}

extension RequestSentViewController {
    private func setupConstraints() {
        view.addSubview(titleLabel)
        view.addSubview(tickImageView)
        view.addSubview(descriptionLabel)
        view.addSubview(handImageView)
        view.addSubview(goBackButton)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
        
        NSLayoutConstraint.activate([
            tickImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            tickImageView.leadingAnchor.constraint(equalTo: titleLabel.trailingAnchor, constant: 20),
            tickImageView.heightAnchor.constraint(equalToConstant: 20),
            tickImageView.widthAnchor.constraint(equalToConstant: 20)
        ])
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            goBackButton.heightAnchor.constraint(equalToConstant: 48),
            goBackButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            goBackButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            goBackButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20)
        ])
        
        NSLayoutConstraint.activate([
            handImageView.widthAnchor.constraint(equalToConstant: 100),
            handImageView.heightAnchor.constraint(equalToConstant: 120),
            handImageView.topAnchor.constraint(equalTo: goBackButton.bottomAnchor, constant: 40),
            handImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        ])
    }
}

// MARK: - SwiftUI
import SwiftUI

struct RequestSentVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let feedVC = MainTabBarController()

        func makeUIViewController(context: Context) -> some MainTabBarController {
            return feedVC
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

        }
    }
}

