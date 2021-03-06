//
//  ChooseTagsView.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 30.12.2020.
//

import Foundation
import UIKit


class ChooseTagsView: UIView {
    //MARK: - Variables
    private let fontSize: CGFloat = 17
    private var selectedTags: [FeedTag] = [] {
        didSet {
            let stringTags = selectedTags.map {$0.rawValue}.joined(separator: ",").trimmingCharacters(in: .whitespaces)
            tagsLabel.text = stringTags
            if selectedTags == [] {
                tagsLabel.text = ""
            }
            if ((tagsLabel.text?.isEmpty) != nil) {
                label1.text = "Выбери тэги"
            } else {
                label1.text = "Выбранные тэги:"
            }
        }
    }
    //MARK: - Contols
    private lazy var label1: UILabel = {
        let label = UILabel.getNormalLabel(fontSize: fontSize, text: "Выбери тэги")
        label.textAlignment = .left
        label.backgroundColor = .clear
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var tagsLabel: UILabel = {
        let label = UILabel.getNormalLabel(fontSize: fontSize, text: "", textColor: .yellowTextColor())
        //"Ремонт, IT, реклама, ремонт"
        label.textAlignment = .left
        label.backgroundColor = .clear
        return label
    }()
    private lazy var arrowView: UIImageView = {
       let view = UIImageView(image: UIImage(named: "arrowIcon"))
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    internal lazy var coverButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        return button
    }()
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 10
        clipsToBounds = true
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 0.8156862745, green: 0.8156862745, blue: 0.8, alpha: 1)
        self.translatesAutoresizingMaskIntoConstraints = false
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - func
    internal func set(selectedTags: [FeedTag]) {

        self.selectedTags = selectedTags
 
    }
    
    func getTags() -> [FeedTag] {
        return selectedTags
    }
    
    open var isEmpty: Bool {
        return selectedTags.count == 0
    }
}

//Constraints
extension ChooseTagsView {
    private func setupConstraints() {
        addSubview(coverButton)
        coverButton.fillSuperview()
        
        coverButton.addSubview(label1)
        coverButton.addSubview(arrowView)
        coverButton.addSubview(tagsLabel)
        
        NSLayoutConstraint.activate([
            arrowView.centerYAnchor.constraint(equalTo: centerYAnchor),
            arrowView.widthAnchor.constraint(equalToConstant: 7),
            arrowView.heightAnchor.constraint(equalToConstant: 14),
            arrowView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14)
        ])
        #warning("разобраться с шириной label1 и если text в label изменится, изменить ширину")
        let labelWidth = "Выбери тэги".sizeOfString(usingFont: label1.font).width
        NSLayoutConstraint.activate([
            label1.centerYAnchor.constraint(equalTo: centerYAnchor),
            label1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24),
            label1.widthAnchor.constraint(equalToConstant: labelWidth)
        ])
        
        NSLayoutConstraint.activate([
            tagsLabel.leadingAnchor.constraint(equalTo: label1.trailingAnchor, constant: 20),
            tagsLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            tagsLabel.trailingAnchor.constraint(equalTo: arrowView.leadingAnchor, constant: -20)
        ])
    }
}


// MARK: - SwiftUI
import SwiftUI

struct ChooseTagsViewProvider: PreviewProvider {
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
