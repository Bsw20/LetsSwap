//
//  ConversationsViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.02.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyBeaver

protocol ConversationsDisplayLogic: class {
  func displayData(viewModel: Conversations.Model.ViewModel.ViewModelData)
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
        view.backgroundColor = .mainBackground()
        setupUI()
        setupConstraints()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getAllConversations {[weak self] (result) in
            switch result {
            
            case .success(let model):
                self?.conversations = model.chats
                self?.myProfileInfo = Conversations.MyProfileInfo(myId: model.myId, myProfileImage: model.myProfileImage, myUserName: model.myUserName)
                self?.tableView.reloadData()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
  
    func displayData(viewModel: Conversations.Model.ViewModel.ViewModelData) {

    }
    
    //MARK: - Funcs
    private func setupUI() {
        setupTableView()
        setupNavigationUI()
    }
    
    private func setupNavigationUI() {
        navigationItem.title = "Мессенджер"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circeRegular(with: 22), NSAttributedString.Key.foregroundColor: UIColor.mainTextColor()]
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.tintColor = .black;
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
    private func getAllConversations(completion: @escaping (Result<ConversationViewModel, Error>) -> Void) {
        guard let url = URL(string: "http://92.63.105.87:3000/chat/getAllChats") else {
            completion(.failure(NSError()))
            return
        }
        
        let headers: HTTPHeaders = [
                    "Content-Type":"application/json",
            "Authorization" : APIManager.getToken()
                ]
        
        AF.request(url, method: .get, headers: headers)
            .validate(statusCode: 200..<300)
            .responseData(completionHandler: { (response) in
                switch response.result {

                case .success(let data):
                    do {
                        let model = try JSONDecoder().decode(ConversationViewModel.self, from: data)
                        completion(.success(model))

                    } catch(let error){
                        print(error.localizedDescription)
                        SwiftyBeaver.error(error.localizedDescription)
                        completion(.failure(FeedError.incorrectDataModel))
                    }

                case .failure(let error):
                    SwiftyBeaver.error(error.localizedDescription)
                    completion(.failure(FeedError.serverError))
                    #warning("figure out with error types")
                }
            })
    }
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
        print(String.username(name: conversation.name, lastname: conversation.lastName))
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
