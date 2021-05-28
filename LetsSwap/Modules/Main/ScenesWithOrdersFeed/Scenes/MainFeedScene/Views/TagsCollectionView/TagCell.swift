//
//  TagCell.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 17.12.2020.
//

import Foundation
import UIKit

class TagCell: UICollectionViewCell {
    static let reuseId = "TagCell"
    private var tagLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.backgroundColor = .clear
        label.textColor = .mainTextColor()

        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .mainBackground()
        addSubview(tagLabel)
        NSLayoutConstraint.activate([
            tagLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            tagLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            tagLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    func set(tagString: String) {
        tagLabel.text = tagString
    }
    
    func selectedCellSet(tagString: String) {
        set(tagString: tagString)
        backgroundColor = .mainYellow()
        tagLabel.textColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 21
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.mainYellow().cgColor
        self.clipsToBounds = true
    }
    
    override func prepareForReuse() {
        backgroundColor = .mainBackground()
        tagLabel.textColor = .black
    }
    
    
}
