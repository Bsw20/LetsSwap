//
//  ConversationCell.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.02.2021.
//

import Foundation
import UIKit

protocol ConversationCellViewModel {
    var profileImage: String? { get }
    var name: String { get }
    var lastname: String { get }
    var missedMessagesCount: Int { get }
    var lastMessage: String { get }
    var data: Int { get }
}
class ConversationCell: UITableViewCell {
    //MARK: - Variables
    private let imageHeight = 64
    public static let reuseId = "ConversationCell"
    //MARK: - Controls
    private var profileImageView: WebImageView = {
        let imageView = WebImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        imageView.image = #imageLiteral(resourceName: "personImage")
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 32
        return imageView
    }()
    
    private var usernameLabel: UILabel = {
        let label = UILabel.getNormalLabel(fontSize: 20, text: "")
        label.textAlignment = .left
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private var lastMessageLabel: UILabel = {
        let label = UILabel.getNormalLabel(fontSize: 16, text: "")
        label.textColor = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1)
        label.textAlignment = .left
        return label
    }()
    
    
    
    private var messageDateLabel: UILabel = {
        let label = UILabel.getNormalLabel(fontSize: 16, text: "")
        label.textColor = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1)
        label.textAlignment = .right
        return label
    }()
    
    private var missedMessagesLabel: UILabel = {
        let label = UILabel.getNormalLabel(fontSize: 15, text: "")
        label.clipsToBounds = true
        label.layer.cornerRadius = 10.5
        label.backgroundColor = .mainDetailsYellow()
        label.textAlignment = .center
        label.font = UIFont.circeRegular(with: 15)
        label.textColor = .white
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .mainBackground()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.resetUrl()
    }
    
    public func configure(model: ConversationCellViewModel) {
        usernameLabel.text = "\(model.name) \(model.lastname)"
        profileImageView.set(imageURL: model.profileImage)
        lastMessageLabel.text = model.lastMessage
        #warning("Make convert to days/minutes/sec..")
        messageDateLabel.text = "\(model.data)м"
        if model.missedMessagesCount == 0 {
            missedMessagesLabel.isHidden = true
        } else {
            missedMessagesLabel.text = "\(model.missedMessagesCount)"
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Constraints
extension ConversationCell {
    private func setupConstraints() {
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(lastMessageLabel)
        addSubview(messageDateLabel)
        addSubview(missedMessagesLabel)
        
        profileImageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(0.045 * screenSize.width)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(imageHeight)
        }
        
        messageDateLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(screenSize.width * 0.04)
            make.top.equalToSuperview().offset(20)
        }
        
        usernameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(profileImageView.snp.right).offset(0.045 * screenSize.width)
            make.right.lessThanOrEqualTo(messageDateLabel.snp.left).inset(21)
        }
        
        missedMessagesLabel.snp.makeConstraints { (make) in
            make.height.width.equalTo(21)
            make.bottom.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(12)
        }
        
        lastMessageLabel.snp.makeConstraints { (make) in
            make.top.equalTo(usernameLabel.snp.bottom)
            make.left.equalTo(profileImageView.snp.right).offset(0.045 * screenSize.width)
        }
        
        NSLayoutConstraint.activate([
            lastMessageLabel.trailingAnchor.constraint(equalTo: missedMessagesLabel.leadingAnchor, constant: -screenSize.width * 0.058)
        ])
        
    }
}
//MARK: - SwiftUI
import SwiftUI
struct ConversationCellPresenter: PreviewProvider {
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
