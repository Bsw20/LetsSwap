//
//  MyProfileHeaderView.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 05.02.2021.
//

import Foundation
import UIKit
import SnapKit

protocol MyProfileHeaderViewModel {
    var profileImage: String? { get }
    var name: String { get }
    var lastname: String { get }
    var cityName: String { get }
    var swapsCount: Int { get }
    var rating: Double { get }
}

class MyProfileHeaderView: UICollectionReusableView {
    static let reuseId = "MyProfileHeaderView"
    
    private lazy var topView: ProfileTopView = {
        let view = ProfileTopView(frame: .zero)
        return view
    }()
    
    private lazy var cityNameLabel: NameCityLabel = {
        let label = NameCityLabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(topView)

        topView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(17)
        }
        
        addSubview(cityNameLabel)
        cityNameLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        let constraint = cityNameLabel.topAnchor.constraint(equalTo: topView.bottomAnchor, constant: 20)
        constraint.isActive = true
        constraint.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            bottomAnchor.constraint(equalTo: cityNameLabel.bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(model: MyProfileViewModel.PersonInfo) {
        topView.setup(topViewModel: model)
        let fullName = "\(model.name) \(model.lastname)"
        cityNameLabel.setup(name: fullName, city: model.cityName)
    }
}
