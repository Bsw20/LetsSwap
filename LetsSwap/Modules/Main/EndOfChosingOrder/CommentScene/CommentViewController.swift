//
//  CommentViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 24.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit


class CommentViewController: UIViewController {
    private var commentsModel: CommentsViewModel
    private var swapsManager: SwapsFetcher = SwapsManager.shared
    
    private lazy var commentLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.circeRegular(with: 20)
        label.textColor = #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
        label.text = "Добавьте комментарий к обмену"
        return label
    }()
    private lazy var swapButton: UIButton = {
        let button = UIButton.getSwapButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var stringPlaceholder = "Расскажите о своих пожеланиях"
    private lazy var textView: UITextView = {
        let tf = UITextView.getNormalTextView()
        tf.text = stringPlaceholder
        tf.backgroundColor = .white
        return tf
    }()
    var router: (NSObjectProtocol & CommentRoutingLogic)?


    // MARK: Object lifecycle
  
    init(commentsModel: CommentsViewModel) {
        #warning("в navigation имя")
        self.commentsModel = commentsModel
        super.init(nibName: nil, bundle: nil)
        setup()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
  
    // MARK: Setup
  
    private func setup() {
        let viewController        = self
        let router                = CommentRouter()
        viewController.router     = router
        router.viewController     = viewController
    }
  
  // MARK: Routing
  

  
  // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground()
        setupConstraints()
        swapButton.addTarget(self, action: #selector(swapButtonTapped), for: .touchUpInside)
        textView.delegate = self
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapOutsideTextView))
        self.view.addGestureRecognizer(recognizer)
    }
  
    @objc private func swapButtonTapped() {
        #warning("validators или на сервере?")
        textView.resignFirstResponder()
        swapsManager.makeSwap(model: MakeSwapModel(orderId: commentsModel.orderId, comment: textView.text)) { [weak self](result) in
            switch result {
            
            case .success():
                self?.router?.routeToRequestSentViewController()
            case .failure(let error):
                print(#function)
                print(error)
                CommentViewController.showAlert(title: "Ошибка!", message: "На данный момент нельзя совершить обмен.")
            }
        }
    }
    
    @objc private func tapOutsideTextView() {
        textView.resignFirstResponder()
    }
  
}

// MARK: - TextViewDelegate
extension CommentViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == CommentConstants.textViewTextColor {
            textView.text = nil
                textView.textColor = UIColor.black
        }
        }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = stringPlaceholder
            textView.textColor = CommentConstants.textViewTextColor
        }
    }
}

// MARK: - Constraints
extension CommentViewController {
    private func setupConstraints() {
        view.addSubview(commentLabel)
        view.addSubview(swapButton)
        view.addSubview(textView)
        
        NSLayoutConstraint.activate([
            commentLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            commentLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: CommentConstants.leadingOffset)
        ])
        
        NSLayoutConstraint.activate([
            swapButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: CommentConstants.leadingOffset),
            swapButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -CommentConstants.trailingInset),
            swapButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -CommentConstants.swapButtonBottomInset),
            swapButton.heightAnchor.constraint(equalToConstant: CommentConstants.swapButtonHeight)
        ])
        
        NSLayoutConstraint.activate([
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: CommentConstants.leadingOffset),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -CommentConstants.trailingInset),
            textView.topAnchor.constraint(equalTo: commentLabel.bottomAnchor, constant: 10),
            textView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
}

// MARK: - SwiftUI
import SwiftUI

struct CommentsVCProvider: PreviewProvider {
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

