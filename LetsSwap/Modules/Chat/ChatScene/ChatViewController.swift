//
//  ChatViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.02.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView

protocol ChatDisplayLogic: class {
  func displayData(viewModel: Chat.Model.ViewModel.ViewModelData)
}

class ChatViewController: MessagesViewController, ChatDisplayLogic {
    //MARK: - Typealiases
    typealias Message = Chat.Message
    //MARK: - Controls
    //MARK: - Variables
    private var messages: [Message] = [
        Message(content: "First message")
    ]
    var interactor: ChatBusinessLogic?
    var router: (NSObjectProtocol & ChatRoutingLogic)?

    // MARK: Object lifecycle
  
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
  
  // MARK: Setup
  
    private func setup() {
        let viewController        = self
        let interactor            = ChatInteractor()
        let presenter             = ChatPresenter()
        let router                = ChatRouter()
        viewController.interactor = interactor
        viewController.router     = router
        interactor.presenter      = presenter
        presenter.viewController  = viewController
        router.viewController     = viewController
    }
  
    // MARK: Routing
  

  
    // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.layer.zPosition = -1
        setupUI()
    
    }
    //MARK: - Funcs
    private func setupUI() {
        view.backgroundColor = .mainBackground()
        configureMessageInputBar()
        
        if let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout {
            layout.textMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.textMessageSizeCalculator.incomingAvatarSize = .zero
            layout.photoMessageSizeCalculator.outgoingAvatarSize = .zero
            layout.photoMessageSizeCalculator.incomingAvatarSize = .zero
        }
        
        messagesCollectionView.backgroundColor = .mainBackground()
        messageInputBar.delegate = self
//        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
//        messagesCollectionView.messagesDisplayDelegate = self
        
    }
  
    func displayData(viewModel: Chat.Model.ViewModel.ViewModelData) {

    }
//    private func insertNewMessage(message: MMessage) {
//        guard !messages.contains(message) else { return }
//        messages.append(message)
////        messages.sort()
//
//        let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
//        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
//
//        messagesCollectionView.reloadData()
//
//        if shouldScrollToBottom {
//            DispatchQueue.main.async {
//                self.messagesCollectionView.scrollToBottom(animated: true)
//            }
//
//        }
//    }
    
    @objc private func attachmentsButtonPressed() {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            picker.sourceType = .camera
//        } else {
//            picker.sourceType = .photoLibrary
//        }
//
//        present(picker, animated: true, completion: nil)
        print(#function)
    }
    
    
    
    func configureMessageInputBar() {
        messageInputBar.isTranslucent = false
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.backgroundView.backgroundColor = .mainBackground()
        messageInputBar.inputTextView.backgroundColor = .mainBackground()
        messageInputBar.inputTextView.placeholderTextColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 14, left: 30, bottom: 14, right: 36)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 14, left: 36, bottom: 14, right: 36)
        messageInputBar.inputTextView.layer.borderColor = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1)
        messageInputBar.inputTextView.layer.borderWidth = 0.2
        messageInputBar.inputTextView.layer.cornerRadius = 18.0
        messageInputBar.inputTextView.layer.masksToBounds = true
        messageInputBar.inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 14, left: 0, bottom: 14, right: 0)
        
        
        
//        messageInputBar.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        messageInputBar.layer.shadowRadius = 5
//        messageInputBar.layer.shadowOpacity = 0.3
//        messageInputBar.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        configureSendButton()
        configureAttachmentsButton()
    }
    
    func configureSendButton() {
        messageInputBar.sendButton.setImage(UIImage(named: "SendButton"), for: .normal)
        messageInputBar.sendButton.setTitle("", for: .normal)
        messageInputBar.setRightStackViewWidthConstant(to: 50, animated: false)
        messageInputBar.sendButton.contentEdgeInsets = UIEdgeInsets(top: 2, left: 2, bottom: 6, right: 0)
        messageInputBar.sendButton.setSize(CGSize(width: 50, height: 50), animated: false)
    }
    
    func configureAttachmentsButton() {
        let cameraItem = InputBarButtonItem(type: .system)
        let cameraImage = UIImage(named: "ChatAttachmentsIcon")
        cameraItem.setImage(cameraImage, for: .normal)
        
        cameraItem.addTarget(self,
                             action: #selector(attachmentsButtonPressed),
                             for: .touchUpInside)
        
        cameraItem.setSize(CGSize(width: 60, height: 30), animated: false)
        
        messageInputBar.leftStackView.alignment = .center
        messageInputBar.setLeftStackViewWidthConstant(to: 50, animated: false)
        
        messageInputBar.setStackViewItems([cameraItem], forStack: .left, animated: false)
        
    }
    
    

}


//MARK: - MessagesDataSource
extension ChatViewController {
//    func currentSender() -> SenderType {
//        return Sender(senderId: user.id, displayName: user.username)
//    }
    
//    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
//        return messages[indexPath.item]
//    }
    
//    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
//        return 1
//    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.item % 4 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate),
                                      attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10),
                                                   NSAttributedString.Key.foregroundColor: UIColor.darkGray
                                      ])
        }
        return nil

    }
    
    
}

//MARK: - MessagesLayoutDelegate
extension ChatViewController: MessagesLayoutDelegate {
    func footerViewSize(for section: Int, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if (indexPath.item) % 4 == 0 {
            return 30
        } else {
            return 0
        }
    }
}

//MARK: - MessagesDisplayDelegate
//extension ChatViewController: MessagesDisplayDelegate {
//    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//        return isFromCurrentSender(message: message) ? .white : #colorLiteral(red: 0.7882352941, green: 0.631372549, blue: 0.9411764706, alpha: 1)
//    }
//
//    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//        return isFromCurrentSender(message: message) ? #colorLiteral(red: 0.2392156863, green: 0.2392156863, blue: 0.2392156863, alpha: 1) : .white
//    }
//
//    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
//        avatarView.isHidden = true
//    }
//
//    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
//        return .bubble
//    }
//
//    //TODO: implement func avatarSize(for message:...) -> CGSize
//}

//MARK: - InputBarAccessoryViewDelegate
extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
//        let message = MMessage(user: user, content: text)
//        FirestoreService.shared.sendMessage(chat: chat, message: message) { (result) in
//            switch result {
//
//            case .success():
//                self.messagesCollectionView.scrollToBottom()
//            case .failure(let error):
//                self.showAlert(with: "Ошибка", and: error.localizedDescription)
//            }
//        }
        print(#function)
        inputBar.inputTextView.text = ""
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        picker.dismiss(animated: true, completion: nil)
//
//        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
//
//        sendImage(image: image)
    }
}

import SwiftUI

struct ChatVCProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let chatVC = ChatViewController()

        func makeUIViewController(context: Context) -> some ChatViewController {
            return chatVC
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

        }
    }
}
