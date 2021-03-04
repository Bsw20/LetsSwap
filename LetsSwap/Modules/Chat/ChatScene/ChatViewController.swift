//
//  ChatViewController.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 20.02.2021.
//  Copyright (c) 2020. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import SwiftyBeaver

protocol ChatDisplayLogic: NSObjectProtocol {
    func displayAllMessages(model: Chat.AllMessages.ViewModel)
    func displayError(error: Error)
}

class ChatViewController: MessagesViewController, ChatDisplayLogic {
    //MARK: - Typealiases
    typealias Message = Chat.CMessage
    typealias CUser = Chat.CUser
    typealias CChat = Chat.CChat
    //MARK: - Controls
    //MARK: - Variables
    private var messages: [Message] = [
//        Message(content: "First message")
    ] {
        didSet {
            messagesCollectionView.reloadData()
        }
    }
    private var listener: Socket = Socket.shared
    
    private var user: CUser
    private var chat: CChat
    var interactor: ChatBusinessLogic?
    var router: (NSObjectProtocol & ChatRoutingLogic)?

    // MARK: Object lifecycle
  
    init(conversation: Conversations.Conversation, userInfo: Conversations.MyProfileInfo) {
        chat = CChat(friendAvatarStringURL: conversation.friendAvatarStringURL,
                     friendId: conversation.friendId,
                     friendUsername: String.username(name: conversation.name, lastname: conversation.lastName),
                     chatId: conversation.chatId)
        user = CUser(username: userInfo.myUserName,
                     avatarStringURL: userInfo.myProfileImage,
                     id: String(userInfo.myId))
        

        super.init(nibName: nil, bundle: nil)
        SwiftyBeaver.info(user.username)
        SwiftyBeaver.info(user.id)
        setup()
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("ERROR")
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
  
    //MARK: - DisplayLogic
    
    func displayAllMessages(model: Chat.AllMessages.ViewModel) {
        SwiftyBeaver.verbose("All messages")
        self.messages = model.messages
        messagesCollectionView.reloadData()
    }
    func displayError(error: Error) {
        UIApplication.showAlert(title: "Ошибка", message: error.localizedDescription)
    }

  
    // MARK: View lifecycle
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.tabBar.layer.zPosition = -1
        setupUI()
        interactor?.getAllMessages(request: .init(chatId: chat.chatId))
        setupBusinessLogic()
        
    }
    
    deinit {
        listener.stopListenForMessages()
    }
    
    //MARK: - Funcs
    private func setupBusinessLogic() {
        listener.listenForMessages { (result) in
            switch result {
            
            case .success(let model):
                if self.chat.chatId == model.chatId {
                    print("GET MESSAGE")
                    let message = Message(messageId: model.messageId,
                                          senderId: model.senderId,
                                          displayName: model.displayName,
                                          content: model.content,
                                          sendDate: model.sendDate,
                                          chatId: model.chatId)
                    debugPrint(message)
                    self.insertNewMessage(message: message)
                }

            case .failure(let error):
                UIApplication.showAlert(title: "Ошибка!", message: error.localizedDescription)
            }
        }
    }
    private func insertNewMessage(message: Message) {
        print(message.sentDate)
        guard !messages.contains(message) else { return }
        messages.append(message)
        messages.sort()
        
        let isLatestMessage = messages.firstIndex(of: message) == (messages.count - 1)
        let shouldScrollToBottom = messagesCollectionView.isAtBottom && isLatestMessage
        
        messagesCollectionView.reloadData()
        
        if shouldScrollToBottom {
            DispatchQueue.main.async {
                self.messagesCollectionView.scrollToBottom(animated: true)
            }

        }
    }
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
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onMainThread {
            self.messagesCollectionView.scrollToBottom(animated: false)
        }

        
    }
  
    
    @objc private func attachmentsButtonPressed() {
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
extension ChatViewController: MessagesDataSource  {
    func currentSender() -> SenderType {
        return Sender(senderId: user.id, displayName: user.username)
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.item]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return 1
    }
    
    func numberOfItems(inSection section: Int, in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        if indexPath.item % 4 == 0 {
//            let formatter = DateFormatter()
//            let date = message.sentDate
//            formatter.timeZone = TimeZone(identifier: "Europe/Moscow")
//            switch true {
//            case Calendar.current.isDateInToday(date) || Calendar.current.isDateInYesterday(date):
//                formatter.doesRelativeDateFormatting = true
//                formatter.dateStyle = .short
//                formatter.timeStyle = .short
//            case Calendar.current.isDate(date, equalTo: Date(), toGranularity: .weekOfYear):
//                formatter.dateFormat = "EEEE h:mm a"
//            case Calendar.current.isDate(date, equalTo: Date(), toGranularity: .year):
//                formatter.dateFormat = "E, d MMM, h:mm a"
//            default:
//                formatter.dateFormat = "MMM d, yyyy, h:mm a"
//            }
            
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
extension ChatViewController: MessagesDisplayDelegate {
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? #colorLiteral(red: 1, green: 0.9333333333, blue: 0.6274509804, alpha: 1) : #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
    }
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return .mainTextColor()
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        return .bubble
    }
    
    //TODO: implement func avatarSize(for message:...) -> CGSize
}
//MARK: - InputBarAccessoryViewDelegate
extension ChatViewController: InputBarAccessoryViewDelegate {
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        let message = Message(user: user, chat: chat, content: text)
        print("Sending message")
        print(message)
        #warning("В будущем сервер должен отсылать это сообщение двум клиентам")
//        self.insertNewMessage(message: message)
        listener.sendMessage(model: .init(messageId: message.messageId, chatId: chat.chatId, contentType: message.contentType, content: message.content, displayName: user.username, senderId: message.sender.senderId, sendDate: message.sentDate)) {[weak self] (result) in
            switch result {
                case .success():
                    onMainThread {
                        self?.messagesCollectionView.scrollToBottom()
                    }
            case .failure(let error):
                UIApplication.showAlert(title: "Ошибка!", message: error.localizedDescription)
            }
        }
        print(#function)
        inputBar.inputTextView.text = ""
    }
}


