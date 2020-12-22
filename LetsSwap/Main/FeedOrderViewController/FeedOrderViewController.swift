//
//  FeedOrderViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 21.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol FeedOrderDisplayLogic: class {
    func displayData(viewModel: FeedOrder.Model.ViewModel.ViewModelData)
}

protocol OrderRepresentableModel {

    var title: String { get }
    var description: String { get }
    var counterOffer: String { get }
    var isFree: Bool { get }
    var tags: [FeedTag] { get }
    var photoAttachments: [URL]{ get }
}
protocol UserRepresentableModel {
    var userName: String { get }
    var userLastName: String { get }
    var userCity: String { get}
    var userPhoto: URL? { get }
    
}

class FeedOrderViewController: UIViewController, FeedOrderDisplayLogic {

    var interactor: FeedOrderBusinessLogic?
    var router: (NSObjectProtocol & FeedOrderRoutingLogic)?

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
        let interactor            = FeedOrderInteractor()
        let presenter             = FeedOrderPresenter()
        let router                = FeedOrderRouter()
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
        
    }
  
    func displayData(viewModel: FeedOrder.Model.ViewModel.ViewModelData) {

    }
}
