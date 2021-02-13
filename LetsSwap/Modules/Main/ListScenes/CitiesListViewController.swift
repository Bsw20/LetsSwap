//
//  CitiesListViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 22.01.2021.
//

import Foundation
import UIKit

protocol CitiesListDelegate: NSObjectProtocol {
    func citySelected(city: String)
}

class CitiesListViewController: UIViewController {
    //MARK: - Variables
    private var allCities = City.getCitiesModel()
    private var selectedCity: String
    private var filtredCities = City.getCitiesModel()
    
    weak var delegate: CitiesListDelegate?
    //MARK: - Controls
    private var collectionView: UICollectionView!
    
    init(selectedCity: String) {
        self.selectedCity = selectedCity
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .mainBackground()
        
        setupCollectionView()
        setupConstraints()
        setupNavigationController()
        setupSearchBar()
        reloadData(with: nil)
    }
    
    private func reloadData(with searchText: String?) {
        filtredCities = allCities.filter { (city) -> Bool in
            city.contains(filter: searchText)
        }
        collectionView.reloadData()
    }
    
    private func setupSearchBar() {
        navigationController?.navigationBar.shadowImage = UIImage()
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = .mainTextColor()
    }
    private func setupNavigationController() {
        
        self.tabBarController?.tabBar.isHidden = true
        extendedLayoutIncludesOpaqueBars = true
        
        navigationItem.title = "Выбери город"
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circeRegular(with: 22), NSAttributedString.Key.foregroundColor: UIColor.mainTextColor()]
        
        navigationItem.setLeftBarButton(UIBarButtonItem(image: #imageLiteral(resourceName: "goBackIcon"), style: .plain, target: self, action: #selector(leftBarButtonTapped)), animated: true)
        navigationItem.hidesBackButton = true
    }
    
    @objc private func leftBarButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    private func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .mainBackground()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.allowsSelection = true
        collectionView.allowsMultipleSelection = false
        
        collectionView.register(ChoosePropertyCell.self, forCellWithReuseIdentifier: ChoosePropertyCell.reuseId)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        extendedLayoutIncludesOpaqueBars = false
    }
}

//MARK: - CollectionDelegate&DataSource
extension CitiesListViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filtredCities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChoosePropertyCell.reuseId, for: indexPath) as! ChoosePropertyCell
        let selected = selectedCity == filtredCities[indexPath.item].city
        cell.set(property: filtredCities[indexPath.item].city,selected: selected )
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCity = filtredCities[indexPath.item].city
        (collectionView.cellForItem(at: indexPath) as! ChoosePropertyCell).setSelected()
        
        delegate?.citySelected(city: selectedCity)
        navigationController?.popViewController(animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        (collectionView.cellForItem(at: indexPath) as! ChoosePropertyCell).setDeselected()
    }
}

//MARK: - FlowLayoutDelegate
extension CitiesListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 54)
    }
}

//MARK: - SearchBarDelegate
extension CitiesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadData(with: searchText)
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        reloadData(with: nil)
    }
}

//MARK: - Constraints
extension CitiesListViewController {
    private func setupConstraints() {
        view.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


