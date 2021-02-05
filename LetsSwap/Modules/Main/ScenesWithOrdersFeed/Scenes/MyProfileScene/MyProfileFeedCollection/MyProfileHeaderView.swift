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
    var raiting: Double { get }
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
            make.top.equalTo(topView.snp.bottom).offset(20)
            make.bottom.equalTo(snp.bottom)
        }
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
