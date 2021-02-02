//
//  PlusButtonCell.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 03.02.2021.
//

import Foundation
import UIKit
import SnapKit

protocol PlusButtonCellDelegate: NSObjectProtocol {
    func addButtonTapped()
}

class PlusButtonCell: UICollectionViewCell {
    //MARK: - Variables
    public static var reuseId = "PlusButtonCell"
    weak var customDelegate: PlusButtonCellDelegate?
    
    //MARK: - Controls
    private lazy var plusButton = UIButton.getPickerButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .detailsGrey()
        
        plusButton.addTarget(self, action: #selector(plusButtonTapped), for: .touchUpInside)
        setupConstraints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func plusButtonTapped() {
        customDelegate?.addButtonTapped()
    }
}

//MARK: - Constraints
extension PlusButtonCell {
    private func setupConstraints() {
        addSubview(plusButton)
        plusButton.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
}
