//
//  ConversationsViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.02.2021.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyBeaver
import SwiftyJSON

protocol ConversationsDisplayLogic: class {
  func displayData(viewModel: Conversations.Model.ViewModel.ViewModelData)
    func displayAllConversations(viewModel: Conversations.AllConversations.ViewModel)
    func displayError(error: Error)
}

class ConversationsViewController: UIViewController, ConversationsDisplayLogic {
    typealias ConversationModel = Conversations.Conversation
    typealias ConversationViewModel = Conversations.AllConversations.ViewModel
    //MARK: - Controls
    private var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        
        return tableView
    }()
    
    //MARK: - Variables
    private var conversations: [ConversationModel] = [
    ]
    private var myProfileInfo: Conversations.MyProfileInfo!
    var interactor: ConversationsBusinessLogic?
    var router: (NSObjectProtocol & ConversationsRoutingLogic)?
    
    var backgroundImageView: UIImageView!
    var backgroundLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainYellow()
        label.font = UIFont.circeRegular(with: 17)
        label.text = "Начните обсуждение по подтверждённым \n махам"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
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
        let interactor            = ConversationsInteractor()
        let presenter             = ConversationsPresenter()
        let router                = ConversationsRouter()
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
        
        let backgroundImage = UIImage.init(named: "chatPlace")
        backgroundImageView = UIImageView.init(frame: self.view.frame)
        
        backgroundImageView.image = backgroundImage
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        
        view.backgroundColor = .mainBackground()
        setupUI()
        setupConstraints()
        #warning("Удалить")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        interactor?.getAllConversations(requst: .init())
    }
  
    func displayData(viewModel: Conversations.Model.ViewModel.ViewModelData) {
        
    }
    
    func displayAllConversations(viewModel: Conversations.AllConversations.ViewModel) {
        if viewModel.chats.isEmpty {
            self.tableView.isHidden = true
            self.backgroundImageView.isHidden = false
            self.backgroundLabel.isHidden = false
        } else {
            self.tableView.isHidden = false
            self.backgroundImageView.isHidden = true
            self.backgroundLabel.isHidden = true
            self.conversations = viewModel.chats
            self.myProfileInfo = Conversations.MyProfileInfo(myId: viewModel.myId, myProfileImage: viewModel.myProfileImage, myUserName: viewModel.myUserName)
            self.tableView.reloadData()
        }
    }
    
    func displayError(error: Error) {
        UIApplication.showAlert(title: "Ошибка", message: "")
    }
    //MARK: - Funcs
    private func setupUI() {
        setupTableView()
        setupNavigationUI()
    }
    
    private func setupNavigationUI() {
        navigationItem.title = "Мессенджер"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circeRegular(with: 22), NSAttributedString.Key.foregroundColor: UIColor.mainTextColor()]
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .black;
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setupTableView() {
        tableView.register(ConversationCell.self, forCellReuseIdentifier: ConversationCell.reuseId)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
}

//MARK: - TODO DELETE
extension ConversationsViewController {


}

//MARK: - UITableViewDelegate&UITableViewDataSource
extension ConversationsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.reuseId, for: indexPath) as! ConversationCell
        cell.configure(model: conversations[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(84)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let conversation = conversations[indexPath.row]
        router?.routeToChat(conversation: conversation, userInfo: myProfileInfo)
    }
    
    
}

//MARK: - Constraints
extension ConversationsViewController {
    private func setupConstraints() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(view.safeAreaLayoutGuide.snp.edges)
        }
        
        self.view.addSubview(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 130),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -130)
        ])
        
        self.view.addSubview(backgroundLabel)
        NSLayoutConstraint.activate([
            backgroundLabel.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 50),
            backgroundLabel.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
            backgroundLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            backgroundLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
}

// MARK: - SwiftUI
import SwiftUI

struct ConversationsVCProvider: PreviewProvider {
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
