//
//  CommentViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 24.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CommentDisplayLogic: class {
    func displayData(viewModel: Comment.Model.ViewModel.ViewModelData)
}

class CommentViewController: UIViewController, CommentDisplayLogic {

//    private var placeholder: String = ""
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
        let tf = UITextView(frame: .zero)
        tf.font = UIFont.circeRegular(with: 17)
        tf.textColor = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1)
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.layer.cornerRadius = 10
        tf.layer.borderColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
        tf.layer.borderWidth = 1
        tf.text = stringPlaceholder
        
        tf.clipsToBounds = true
        return tf
    }()
    var interactor: CommentBusinessLogic?
    var router: (NSObjectProtocol & CommentRoutingLogic)?


    // MARK: Object lifecycle
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
  
    // MARK: Setup
  
    private func setup() {
        let viewController        = self
        let interactor            = CommentInteractor()
        let presenter             = CommentPresenter()
        let router                = CommentRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
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
  
    func displayData(viewModel: Comment.Model.ViewModel.ViewModelData) {

    }
    @objc private func swapButtonTapped() {
        #warning("validators")
        textView.resignFirstResponder()
        print("swapButtonTapped")
        print(textView.text)
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
        print("did begin")
        }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = stringPlaceholder
            textView.textColor = CommentConstants.textViewTextColor
            print("is empty")
        }
    }
    #warning("TODO")
//    func textViewDidChange(_ textView: UITextView) {
//        if textView.text.isEmpty || textView.text == stringPlaceholder {
//            swapButton.isEnabled = false
//        } else {
//            swapButton.isEnabled = true
//        }
//    }
    
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

