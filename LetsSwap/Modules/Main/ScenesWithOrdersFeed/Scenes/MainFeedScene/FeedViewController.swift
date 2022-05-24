//
//  FeedViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 16.12.2020.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit

protocol FeedDisplayLogic: class {
    func displayData(viewModel: Feed.Model.ViewModel.ViewModelData)
    func setCity(cityString: String)
}

class FeedViewController: UIViewController, FeedDisplayLogic {
    //variables
    
    private var feedCollectionView: FeedCollectionView

    private var titleView = TitleView()
    var interactor: FeedBusinessLogic?
    var router: (NSObjectProtocol & FeedRoutingLogic)?
    var selectedCity: String = ""
    var selectedAllTags = Set<FeedTag>()
    var selectedNowTags = Set<FeedTag>()
    private var selectedTags: Set<FeedTag> {
        return feedCollectionView.getSelectedTags().union(selectedAllTags)
    }
    
    var backgroundImageView: UIImageView!
    var backgroundLabel: UILabel = {
        let label = UILabel()
        label.textColor = .mainYellow()
        label.font = UIFont.circeRegular(with: 17)
        label.text = "Обменов не найдено :("
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

  // MARK: Object lifecycle
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        feedCollectionView = FeedCollectionView(type: .withHeader)
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("required init doesn't implemented")
    }
    
  
  // MARK: Setup
    private func setup() {
        let viewController        = self
        let interactor            = FeedInteractor()
        let presenter             = FeedPresenter()
        let router                = FeedRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
  
  // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backgroundImage = UIImage.init(named: "feedPlace")
        backgroundImageView = UIImageView.init(frame: self.view.frame)
        
        backgroundImageView.image = backgroundImage
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.contentMode = .scaleAspectFill
        
        view.backgroundColor = .mainBackground()
        feedCollectionView.customDelegate = self
        titleView.customDelegate = self
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboardFromTopView))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)

        
        setupSearchBar()
        setupConstraints()
        //interactor?.makeRequest(request: .getFilteredFeed(model: FiltredFeedModel(selectedTags: selectedTags,text: titleView.getTextFieldText(), city: selectedCity)))
        view.layoutIfNeeded()


    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !selectedCity.isEmpty {
            interactor?.makeRequest(request: .getFilteredFeed(model: FiltredFeedModel(selectedTags: selectedTags, text: titleView.getTextFieldText(), city: selectedCity)))
        } else {
            interactor?.makeRequest(request: .getFeed)
        }
        #warning("Заглушка для favorites. Часто не работает через updateData")
        feedCollectionView.reloadData()
        navigationController?.hidesBarsOnSwipe = true
        print("VIEW WILL DISAPPEAR")
      }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isNavigationBarHidden = false
        navigationController?.hidesBarsOnSwipe = false
      }
    
    
    func displayData(viewModel: Feed.Model.ViewModel.ViewModelData) {
        switch viewModel {
        
        case .displayFeed(feedViewModel: let feedViewModel):
            self.updateBackgroundView(viewModel: feedViewModel)
            feedCollectionView.updateData(feedViewModel: feedViewModel)
        case .displayOrder(orderViewModel: let orderViewModel):
            router?.routeToFeedOrderController(orderViewModel: orderViewModel)
        case .displayError(error: let error):
            showAlert(title: "Ошибка", message: error.localizedDescription)
        case .displayEmptyFeed:
            #warning("TODO: ждать дизайнеров    ")
            showAlert(title: "Ошибка", message: "")
        }
        view.isUserInteractionEnabled = true
    }
    
    private func setupSearchBar() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.barTintColor = .mainBackground()
        self.navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        //self.navigationItem.prompt = nil
        self.navigationItem.titleView = titleView
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    private func applyFilterToFeed() {
        let inputText = titleView.getTextFieldText()
        let tags = selectedTags
        interactor?.makeRequest(request: .getFilteredFeed(model:
                                                            FiltredFeedModel(
                                                                selectedTags: tags,
                                                                text: inputText, city: selectedCity
                                                            )))
    }
    
    
    @objc private func hideKeyboardFromTopView() {
        titleView.endEditing(true)
    }
    
    func setCity(cityString: String) {
        selectedCity = cityString
    }
    
    func updateBackgroundView(viewModel: FeedViewModel) {
        if viewModel.cells.isEmpty {
            self.backgroundImageView.isHidden = false
            self.backgroundLabel.isHidden = false
        } else {
            self.backgroundImageView.isHidden = true
            self.backgroundLabel.isHidden = true
        }
    }
}

//MARK: - FeedViewControllerDelegate
extension FeedViewController: FeedCollectionViewDelegate {
    func cellDidSelect(orderId: Int) {
        view.isUserInteractionEnabled = false
        interactor?.makeRequest(request: .getOrder(orderId: orderId))
    }
    
    func showAlert(title: String, message: String) {
        UIViewController.showAlert(title: title, message: message)
    }
    
    func selectedTagsChanged() {
        selectedAllTags.subtract(feedCollectionView.getSelectedTags().subtracting(selectedNowTags))
        selectedNowTags = selectedAllTags
        interactor?.makeRequest(request: .getFilteredFeed(model: FiltredFeedModel(selectedTags: selectedTags,
                                                                                  text: titleView.getTextFieldText(), city: selectedCity)))
    }
    func moreTagsButtonTapped() {
        router?.routeToTagsController(currentTags: selectedTags)
    }
    
    func refresh() {
        interactor?.makeRequest(request: .getFilteredFeed(model: FiltredFeedModel(selectedTags: selectedTags,
                                                                                  text: titleView.getTextFieldText(), city: selectedCity)))
    }
    
}

//MARK: - CitiesListDelegate
extension FeedViewController: CitiesListDelegate {
    func citySelected(city: String) {
        selectedCity = city
    }
}

//MARK: - AllTagsListDelegate
extension FeedViewController: AllTagsListDelegate {
    func tagsSelected(tags: Set<FeedTag>) {
        self.selectedAllTags = tags
        feedCollectionView.setSelectedTags(tags: tags)
        
        interactor?.makeRequest(request: .getFilteredFeed(model: FiltredFeedModel(selectedTags: selectedTags,
                                                                                  text: titleView.getTextFieldText(), city: selectedCity)))
    }
}

//MARK: - constraints
extension FeedViewController {
    private func setupConstraints() {
        view.addSubview(feedCollectionView)

        feedCollectionView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.view.addSubview(backgroundImageView)
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 130),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -130)
        ])
        
        self.view.addSubview(backgroundLabel)
        NSLayoutConstraint.activate([
            backgroundLabel.topAnchor.constraint(equalTo: backgroundImageView.bottomAnchor, constant: 55),
            backgroundLabel.centerXAnchor.constraint(equalTo: backgroundImageView.centerXAnchor),
            backgroundLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            backgroundLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
    }
}

extension FeedViewController: TitleViewDelegate {
    func textDidChange(newText: String) {
        applyFilterToFeed()
    }
    
    func cityButtonTapped() {
        router?.routeToCitiesController(selectedCity: selectedCity)
    }
    
    
}

// MARK: - SwiftUI
import SwiftUI

struct FeedVCProvider: PreviewProvider {
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

