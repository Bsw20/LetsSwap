//
//  SignUpPresentationViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.01.2021.
//

import Foundation
import UIKit

class SignUpPresentationViewController: UIViewController {
    enum PresentationSlide {
        case firstSlide
        case secondSlide
        case thirdSlide
        
        func getPageIndex() -> Int {
            switch self {
            
            case .firstSlide:
                return 0
            case .secondSlide:
                return 1
            case .thirdSlide:
                return 2
            }
        }
    }
    //MARK: - Controls
    private lazy var helloLabel: UILabel = UILabel.getNormalLabel(fontSize: 61, text: "Привет!", textColor: .mainDetailsYellow())
    
    private lazy var centerImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.image = UIImage(named: "presentationFirstImage")
        return imageView
    }()
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel.getNormalLabel(fontSize: 17, text: "Ты предлагаешь свои услуги и выбираешь чужие, которые на твой взгляд будут равноценны друг другу. Все основано на взаимодоверии, деньги в обмене не участвуют")
        label.numberOfLines = 0
//        label.lineBreakMode = .byCharWrapping
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton.getLittleRoundButton(text: "Зарегистрироваться")
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Войти", for: .normal)
        button.titleLabel?.font = UIFont.circeRegular(with: 17)
        button.setTitleColor(.mainTextColor(), for: .normal)
        button.titleLabel?.textAlignment = .center
        return button
    }()
    
    private lazy var pageControl: UIPageControl = UIPageControl.getStandard(currentPageIndex: 0, numberOfPages: 3)
    
    //MARK: - Variables
    private var presentationSlide: PresentationSlide
    
    init(presentationSlide: PresentationSlide) {
        self.presentationSlide = presentationSlide
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - ViewController lifecircle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground()
        customizeElements()
        setupConstraints()
        setupNavigationController()
        setupGestures()
        
    }
    
    //MARK: - Funcs
    
    private func setupGestures() {
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(holeSwiped(gesture:)))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(holeSwiped(gesture:)))
        swipeLeft.direction = .left
        self.view.addGestureRecognizer(swipeLeft)
    }
    @objc private func holeSwiped(gesture: UISwipeGestureRecognizer)
    {
        switch gesture.direction {
        case UISwipeGestureRecognizer.Direction.right:

            switch presentationSlide {
            
            case .firstSlide:
                break
            case .secondSlide:
                navigationController?.popViewController(animated: true)
            case .thirdSlide:
                navigationController?.popViewController(animated: true)
            }

        case UISwipeGestureRecognizer.Direction.left:
            switch presentationSlide {
            
            case .firstSlide:
                let vc = SignUpPresentationViewController(presentationSlide: .secondSlide)
                navigationController?.pushViewController(vc, animated: true)
            case .secondSlide:
                let vc = SignUpPresentationViewController(presentationSlide: .thirdSlide)
                navigationController?.pushViewController(vc, animated: true)
            case .thirdSlide:
                break
            }
        default:
            break
        }
    }
    
    private func setupNavigationController() {
        navigationController?.navigationBar.isHidden = true
    }
    private func customizeElements() {
        switch presentationSlide {
        
        case .firstSlide:
            setElementsValues(helloLabelHidden: false,
                              centerImageViewImage: UIImage(named: "presentationFirstImage"),
                              mainLabelText: "Сервис «Махнёмся» позволяет обмениваться знаниями и умениями с другими людьми бесплатно",
                              signUpEnabled: false,
                              signInEnabled: false)
        case .secondSlide:
            setElementsValues(helloLabelHidden: true,
                              centerImageViewImage: UIImage(named: "presentationSecondImage"),
                              mainLabelText: "Ты предлагаешь свои услуги и выбираешь чужие, которые на твой взгляд будут равноценны друг другу. Все основано на взаимодоверии, деньги в обмене не участвуют",
                              signUpEnabled: false,
                              signInEnabled: false)
        case .thirdSlide:
            setElementsValues(helloLabelHidden: true,
                              centerImageViewImage: UIImage(named: "presentationThirdImage"),
                              mainLabelText: "Зарегестрируйся, чтобы начать обмен!",
                              signUpEnabled: true,
                              signInEnabled: true)
        }
        
        pageControl.currentPage = presentationSlide.getPageIndex()
    }
    
    private func setElementsValues(helloLabelHidden: Bool,
                                   centerImageViewImage: UIImage?,
                                   mainLabelText: String,
                                   signUpEnabled: Bool,
                                   signInEnabled: Bool) {
        helloLabel.isHidden = helloLabelHidden
        centerImageView.image = centerImageViewImage
        mainLabel.text = mainLabelText
        signUpButton.isEnabled = signUpEnabled
        signInButton.isEnabled = signInEnabled
        
    }
    
    //MARK: - Objc funcs
    @objc private func signInButtonTapped() {
        print(#function)
        let signInController = SignInViewController()
        navigationController?.setupAsBaseScreen(signInController, animated: true)
    }
    
    @objc private func signUpButtonTapped() {
        print(#function)
        let signUpController = SignUpViewController()
        navigationController?.setupAsBaseScreen(signUpController, animated: true)
    }
}

//MARK: - Constraints
extension SignUpPresentationViewController {
    private func setupConstraints() {
        let screenSize = UIScreen.main.bounds
        
        view.addSubview(signUpButton)
        view.addSubview(signInButton)
        view.addSubview(pageControl)
        view.addSubview(centerImageView)
        view.addSubview(helloLabel)
        view.addSubview(mainLabel)
        
        NSLayoutConstraint.activate([
            signUpButton.heightAnchor.constraint(equalToConstant: 48),
            signUpButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.911),
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signUpButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -screenSize.height * 0.16)
        ])
        
        NSLayoutConstraint.activate([
            signInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            signInButton.topAnchor.constraint(equalTo: signUpButton.bottomAnchor, constant: screenSize.height * 0.02)
        ])
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: signUpButton.topAnchor, constant: -screenSize.height * 0.03)
        ])
        
        let imageViewSize = screenSize.width * 0.47
        
        NSLayoutConstraint.activate([
            centerImageView.heightAnchor.constraint(equalToConstant: imageViewSize),
            centerImageView.widthAnchor.constraint(equalToConstant: imageViewSize),
            centerImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            centerImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: screenSize.height*0.3)
        ])
        
        NSLayoutConstraint.activate([
            helloLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            helloLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: screenSize.height * 0.126)
        ])
        
        NSLayoutConstraint.activate([
            mainLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainLabel.topAnchor.constraint(equalTo: centerImageView.bottomAnchor, constant: screenSize.height * 0.03),
            mainLabel.bottomAnchor.constraint(equalTo: pageControl.topAnchor,
                                              constant: -screenSize.height * 0.023)
        ])
        
        if presentationSlide == PresentationSlide.thirdSlide {
            mainLabel.widthAnchor.constraint(equalTo: centerImageView.widthAnchor, multiplier: 1.2).isActive = true
        } else {
            mainLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        }
        
        
    }
}

// MARK: - SwiftUI
import SwiftUI

struct SignUpPresentationVCProveder: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let vc = SignUpPresentationViewController(presentationSlide: .firstSlide)

        func makeUIViewController(context: Context) -> some SignUpPresentationViewController {
            return vc
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

        }
    }
}
