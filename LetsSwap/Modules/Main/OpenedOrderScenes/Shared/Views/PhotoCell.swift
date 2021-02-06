//
//  PhotoCell.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 23.12.2020.
//

import Foundation
import UIKit
import SnapKit

protocol PhotoCellDelegate: NSObjectProtocol {
    func deleteButtonTapped(cell: PhotoCell)
}

class PhotoCell: UICollectionViewCell {
    //MARK: - Variables
    static var reuseId = "PhotoCell"
    weak var delegate: PhotoCellDelegate?
    var isInEditingMode: Bool = false {
        didSet {
            deleteButton.isHidden = !isInEditingMode
        }
    }
    //MARK: - Controls
    private lazy var imageView: WebImageView = {
       let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "tatu")
        return imageView
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "deleteButtonIcon"), for: .normal)
        button.isHidden = true
        return button
    }()
    //MARK: - Object lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainBackground()
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
        setupConstraints()

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - funcs
    override func prepareForReuse() {
        imageView.image = nil
    }
    
    public func set(imageUrl: String?) {
        #warning("Placeholder")
        imageView.set(imageURL: imageUrl)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        self.clipsToBounds = true
    }
    
    //MARK: - @objc funcs
    @objc private func deleteButtonTapped() {
        delegate?.deleteButtonTapped(cell: self)
    }
}

//MARK: - Constraints
extension PhotoCell {
    private func setupConstraints() {
        addSubview(imageView)
        imageView.fillSuperview()
        addSubview(deleteButton)
        deleteButton.snp.makeConstraints { (make) in
            make.height.width.equalTo(20)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            
        }
    }
}
