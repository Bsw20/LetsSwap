//
//  PhotoCell.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 23.12.2020.
//

import Foundation
import UIKit

class PhotoCell: UICollectionViewCell {
    static var reuseId = "PhotoCell"
    
    private lazy var imageView: WebImageView = {
       let imageView = WebImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "tatu")
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainBackground()
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
