//
//  FullOrderViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FullOrderDisplayLogic: class {
    func displayData(viewModel: FullOrder.Model.ViewModel.ViewModelData)
}

class FullOrderViewController: UIViewController, FullOrderDisplayLogic {

    var interactor: FullOrderBusinessLogic?
    var router: (NSObjectProtocol & FullOrderRoutingLogic)?
    
    private var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .clear
        scrollView.isUserInteractionEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    private lazy var titleTextView: UITextView = {
        let tf = UITextView.getNormalTextView()
        tf.text = "Добавь название"
        return tf
    }()
    
    private lazy var descriptionView: UITextView = {
        let tf = UITextView.getNormalTextView()
        tf.text = "Добавь описание"
        return tf
    }()
    
    private lazy var counterOfferTextView: UITextView = {
        let tf = UITextView.getNormalTextView()
        tf.text = "Напиши, что хочешь взамен"
        return tf
    }()
    
    private lazy var freeOfferLabel: UILabel = {
        let label = UILabel.getNormalLabel(fontSize: 17, text: "Готов реализовать предложение безвозмездно")
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var freeSwitch: UISwitch = {
       let sw = UISwitch()
        sw.translatesAutoresizingMaskIntoConstraints = false
        return sw
    }()
    
    private lazy var contentView: UIView = {
       let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var yellowButton: UIButton = {
        let button = UIButton.getSwapButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var chooseTagsView: UIView = {
        let view = ChooseTagsView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

  // MARK: Object lifecycle
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
  
    // MARK: Setup
  
    private func setup() {
        let viewController        = self
        let interactor            = FullOrderInteractor()
        let presenter             = FullOrderPresenter()
        let router                = FullOrderRouter()
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
        
        navigationController?.navigationBar.topItem?.title = "Новое предложение"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circeRegular(with: 22), NSAttributedString.Key.foregroundColor: UIColor.mainTextColor()]
    }
  
    func displayData(viewModel: FullOrder.Model.ViewModel.ViewModelData) {

    }
}

extension FullOrderViewController {
    
    private func setupConstraints() {
        view.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: FullOrderConstants.leadingTrailingViewOffset),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -FullOrderConstants.leadingTrailingViewOffset)
        ])
        
        scrollView.addSubview(contentView)
//        contentView.backgroundColor = .lightGray
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 2 * FullOrderConstants.leadingTrailingViewOffset),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
        ])
        contentView.addSubview(titleTextView)
        contentView.addSubview(descriptionView)
        contentView.addSubview(counterOfferTextView)
        contentView.addSubview(freeOfferLabel)
        contentView.addSubview(freeSwitch)
        contentView.addSubview(yellowButton)
        contentView.addSubview(chooseTagsView)
        
        
        
        NSLayoutConstraint.activate([
            titleTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            titleTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            titleTextView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: FullOrderConstants.space),
            titleTextView.heightAnchor.constraint(equalToConstant: FullOrderConstants.titleViewHeight)
        ])
        
        NSLayoutConstraint.activate([
            descriptionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            descriptionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descriptionView.topAnchor.constraint(equalTo: titleTextView.bottomAnchor, constant: FullOrderConstants.space),
            descriptionView.heightAnchor.constraint(equalToConstant: FullOrderConstants.descriptinViewHeight)
        ])
        
        NSLayoutConstraint.activate([
            counterOfferTextView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            counterOfferTextView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            counterOfferTextView.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: FullOrderConstants.space),
            counterOfferTextView.heightAnchor.constraint(equalToConstant: FullOrderConstants.descriptinViewHeight)
        ])
        
        
        NSLayoutConstraint.activate([
            freeSwitch.topAnchor.constraint(equalTo: counterOfferTextView.bottomAnchor, constant: FullOrderConstants.space),
            freeSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -2)
        ])
        
        NSLayoutConstraint.activate([
            freeOfferLabel.topAnchor.constraint(equalTo: counterOfferTextView.bottomAnchor, constant: FullOrderConstants.space),
            freeOfferLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            freeOfferLabel.trailingAnchor.constraint(equalTo: freeSwitch.leadingAnchor, constant: -20)

        ])
        
        NSLayoutConstraint.activate([
            chooseTagsView.topAnchor.constraint(equalTo: freeOfferLabel.bottomAnchor, constant: FullOrderConstants.space),
            chooseTagsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            chooseTagsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            chooseTagsView.heightAnchor.constraint(equalToConstant: FullOrderConstants.chooseTagsButtonHeight),
        ])
        NSLayoutConstraint.activate([
            yellowButton.topAnchor.constraint(equalTo: chooseTagsView.bottomAnchor, constant: FullOrderConstants.space),
            yellowButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            yellowButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
                                        yellowButton.heightAnchor.constraint(equalToConstant: FullOrderConstants.yellowButtonHeight),
            yellowButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
//
//        NSLayoutConstraint.activate([
//            freeOfferLabel.leadingAnchor.constraint(equalTo: titleTextView.trailingAnchor),
//            freeOfferLabel.topAnchor.constraint(equalTo: titleTextView.topAnchor)
//        ])
        
    }
}

// MARK: - SwiftUI
import SwiftUI

struct FullOrderVCProvider: PreviewProvider {
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

