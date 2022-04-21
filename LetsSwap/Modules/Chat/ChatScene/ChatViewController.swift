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
import Kingfisher
import AVKit
import AVFoundation
import MobileCoreServices

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
    private let modifier = AnyModifier { request in
        var r = request
        r.setValue(APIManager.getToken(), forHTTPHeaderField: "Authorization")
        return r
    }
    
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
        setupNavigationController()
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
    
    private func setupNavigationController() {
        navigationItem.title = chat.friendUsername
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.circeRegular(with: 22), NSAttributedString.Key.foregroundColor: UIColor.mainTextColor()]
        navigationController?.navigationBar.tintColor = .mainTextColor()
        navigationController?.navigationBar.isTranslucent = true
        let img = WebImageView(frame: .zero)
        
        //img.image = #imageLiteral(resourceName: "settingsIcon")
        img.backgroundColor = .imageFiller()
        if let url = chat.friendAvatarStringURL {
            img.set(imageURL: ServerAddressConstants.JAVA_SERVER_ADDRESS + url)
        } else {
            img.image = nil
        }
        
//        if let imageUrl = chat.friendAvatarStringURL {
//            img.set(imageURL: imageUrl)
//        } else {
//            img.image = UIColor.imageFiller().image(CGSize(width: 32, height: 32))
//        }
//        img.layer.masksToBounds = true
        img.layer.cornerRadius = 16
        img.clipsToBounds = true
        let rightButton = UIBarButtonItem(customView: img)
        rightButton.customView?.clipsToBounds = true
//        rightButton.customView?.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        rightButton.customView?.translatesAutoresizingMaskIntoConstraints = false
        rightButton.customView?.heightAnchor.constraint(equalToConstant: 32).isActive = true
        rightButton.customView?.widthAnchor.constraint(equalToConstant: 32).isActive = true
        navigationItem.setRightBarButton(rightButton, animated: true)
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
                    //                    let message = Message(messageId: model.messageId,
                    //                                          senderId: model.senderId,
                    //                                          displayName: model.displayName,
                    //                                          content: model.content,
                    //                                          sendDate: model.sendDate,
                    //                                          chatId: model.chatId)
                    let message = Message(messageId: model.messageId,
                                          senderId: model.senderId,
                                          displayName: model.displayName,
                                          messageText: model.messageText,
                                          sendDate: model.sendDate,
                                          chatId: model.chatId,
                                          file: model.file)
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
        messagesCollectionView.messageCellDelegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onMainThread {
            self.messagesCollectionView.scrollToBottom(animated: false)
        }
    }
    
    
    @objc private func attachmentsButtonPressed() {
        print(#function)
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
        vc.allowsEditing = false
        vc.delegate = self
        self.present(vc, animated: true)
//        if let fileURL = Bundle.main.url(forResource: "IMG_5092", withExtension: "MP4"), let data = try? Data.init(contentsOf: fileURL) {
//
//            FilesService.shared.uploadFile(fileData: data) { file in
//                let message = Message(user: self.user, chat: self.chat, file: file)
//                self.insertNewMessage(message: message)
//                self.listener.sendMessage(model: .init(displayName: self.user.username,
//                                                       senderId: message.sender.senderId,
//                                                       sendDate: message.sentDate,
//                                                       messageId: message.messageId,
//                                                       chatId: self.chat.chatId,
//                                                       forward: 0,
//                                                       replyTo: 0,
//                                                       messageText: message.messageText,
//                                                       file: message.file)) {[weak self] result in
//                    switch result {
//                    case .success():
//                        onMainThread {
//                            self?.messagesCollectionView.scrollToBottom()
//                        }
//                    case .failure(let error):
//                        UIApplication.showAlert(title: "Ошибка!", message: error.localizedDescription)
//                    }
//                }
//            }
//        }
    }
    
    
    
    func configureMessageInputBar() {
        messageInputBar.isTranslucent = false
        messageInputBar.separatorLine.isHidden = true
        messageInputBar.backgroundView.backgroundColor = .mainBackground()
        messageInputBar.inputTextView.backgroundColor = .mainBackground()
        messageInputBar.inputTextView.placeholderTextColor = #colorLiteral(red: 0.7411764706, green: 0.7411764706, blue: 0.7411764706, alpha: 1)
        messageInputBar.inputTextView.textColor = .mainTextColor()
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
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        switch message.kind {
        case .photo(let mediaItem):
            imageView.kf.setImage(with: mediaItem.url, placeholder: nil, options: [.requestModifier(modifier)]) {_ in
            }
        case .video(let mediaItem):
            imageView.image = #imageLiteral(resourceName: "pickerPlus")
        default:
            break
        }
    }
    
    
    //TODO: implement func avatarSize(for message:...) -> CGSize
}
//MARK: - InputBarAccessoryViewDelegate
extension ChatViewController: InputBarAccessoryViewDelegate {
    // Send file
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        print("Sending message")
        let message = Message(user: user, chat: chat, messageText: text)
        print(message)
        #warning("В будущем сервер должен отсылать это сообщение двум клиентам")
        self.insertNewMessage(message: message)
        listener.sendMessage(model: .init(displayName: user.username,
                                          senderId: message.sender.senderId,
                                          sendDate: message.sentDate,
                                          messageId: message.messageId,
                                          chatId: chat.chatId,
                                          forward: 0,
                                          replyTo: 0,
                                          messageText: message.messageText,
                                          file: message.file)) {[weak self] result in
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
    
    private func playVideo(path: URL?) {
        //         guard let path = Bundle.main.url(forResource: "IMG_5092", withExtension: "MP4") else {
        //             debugPrint("video.m4v not found")
        //             return
        //         }
        guard let path = path else { return }
        let player = AVPlayer(url: path)
        let playerController = AVPlayerViewController()
        playerController.player = player
        present(playerController, animated: true) {
            player.play()
        }
    }
    
    //    SEND IMAGE
    //        func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
    //            playVideo()
    //        let message = Message(user: user, chat: chat, messageText: text)
    //            let image: UIImage = #imageLiteral(resourceName: "unselectedTick")
    //            FilesService.shared.uploadFile(fileData: image.pngData()!) { file in
    //                let message = Message(user: self.user, chat: self.chat, file: file)
    //                self.listener.sendMessage(model: .init(displayName: self.user.username,
    //                                                  senderId: message.sender.senderId,
    //                                                  sendDate: message.sentDate,
    //                                                  messageId: message.messageId,
    //                                                  chatId: self.chat.chatId,
    //                                                  forward: 0,
    //                                                  replyTo: 0,
    //                                                  messageText: message.messageText,
    //                                                  file: message.file)) {[weak self] result in
    //                                switch result {
    //                                    case .success():
    //                                        onMainThread {
    //                                            self?.messagesCollectionView.scrollToBottom()
    //                                        }
    //                                case .failure(let error):
    //                                    UIApplication.showAlert(title: "Ошибка!", message: error.localizedDescription)
    //                                }
    //                }
    //            }
    
    //            print("Sending message")
    //        print(message)
    #warning("В будущем сервер должен отсылать это сообщение двум клиентам")
    //        self.insertNewMessage(message: message)
    //        listener.sendMessage(model: .init(messageId: message.messageId, chatId: chat.chatId, contentType: message.contentType, content: message.content, displayName: user.username, senderId: message.sender.senderId, sendDate: message.sentDate)) {[weak self] (result) in
    //            switch result {
    //                case .success():
    //                    onMainThread {
    //                        self?.messagesCollectionView.scrollToBottom()
    //                    }
    //            case .failure(let error):
    //                UIApplication.showAlert(title: "Ошибка!", message: error.localizedDescription)
    //            }
    //        }
    //        listener.sendMessage(model: .init(displayName: user.username,
    //                                          senderId: message.sender.senderId,
    //                                          sendDate: message.sentDate,
    //                                          messageId: message.messageId,
    //                                          chatId: chat.chatId,
    //                                          forward: 0,
    //                                          replyTo: 0,
    //                                          messageText: message.messageText,
    //                                          file: message.file)) {[weak self] result in
    //                        switch result {
    //                            case .success():
    //                                onMainThread {
    //                                    self?.messagesCollectionView.scrollToBottom()
    //                                }
    //                        case .failure(let error):
    //                            UIApplication.showAlert(title: "Ошибка!", message: error.localizedDescription)
    //                        }
    //        }
    //            print(#function)
    //            inputBar.inputTextView.text = ""
    //        }
}

extension ChatViewController: MessageCellDelegate {
    func didTapImage(in cell: MessageCollectionViewCell) {
        print("image tapped")
        guard let indexPath = messagesCollectionView.indexPath(for: cell) else {
            return
        }
        let message = messages[indexPath.row]
        print(message.kind)
        guard case .video(let mediaItem) = message.kind else { return }
        FilesService.shared.downloadFile(url: mediaItem.url) { data in
            guard let data = data else { return }
            do {
                let directory = NSTemporaryDirectory()
                let fileName = "\(NSUUID().uuidString).MP4"
                let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName ])
                try data.write(to: fullURL! as URL)
                onMainThread {
                    self.playVideo(path: fullURL)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }
        //        message.file.
        //        FilesService.shared.getFileById(id: value) { [weak self](data) in
        //            guard let self = self else { return }
        //            do {
        //                let directory = NSTemporaryDirectory()
        //                let fileName = "\(NSUUID().uuidString).MOV"
        //                let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName ])
        //                try data.write(to: fullURL! as URL)
        //                self.imageFromVideo(url: fullURL!, at: 0) { (image) in
        //                    completion(image)
        //                }
        //            } catch let error {
        //                print("SDFHSKDHFIUSDH")
        //                print(error.localizedDescription)
        //            }
        //
        //
        //        }
    }
}

extension ChatViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func sendMediaMessage(data: Data?, fileName: String = "IMG.png") {
        guard let data = data else { return }
        FilesService.shared.uploadFile(fileData: data, fileName: fileName) { result in
            switch result {
                
            case .success(let file):
                let message = Message(user: self.user, chat: self.chat, file: file)
                self.insertNewMessage(message: message)
                self.listener.sendMessage(model: .init(displayName: self.user.username,
                                                       senderId: message.sender.senderId,
                                                       sendDate: message.sentDate,
                                                       messageId: message.messageId,
                                                       chatId: self.chat.chatId,
                                                       forward: 0,
                                                       replyTo: 0,
                                                       messageText: message.messageText,
                                                       file: message.file)) {[weak self] result in
                    switch result {
                    case .success():
                        onMainThread {
                            self?.messagesCollectionView.scrollToBottom()
                        }
                    case .failure(let error):
                        UIApplication.showAlert(title: "Ошибка!", message: error.localizedDescription)
                    }
                }
            case .failure(let error):
                UIApplication.showAlert(title: "Ошибка!", message: error.localizedDescription)
            }
 
        }
    }
    
    private func sendVideoMessage(url: URL?) {
        guard let url = url else { return }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL {
//            print(videoURL.path)
//            print(videoURL.pathExtension)
//            print(videoURL.deletingPathExtension().lastPathComponent)
//            print(videoURL.lastPathComponent)
//            dismiss(animated: true, completion: nil)
//
            let data = try? Data(contentsOf: videoURL)
            sendMediaMessage(data: data, fileName: videoURL.lastPathComponent)
            dismiss(animated: true, completion: nil)
        }
        
        if let image = info[.originalImage] as? UIImage {
            sendMediaMessage(data: image.pngData())
            dismiss(animated: true, completion: nil)
            return
        }
        
//        guard let image = info[.originalImage] as? UIImage else {
//            dismiss(animated: true, completion: nil)
//            print("No image found")
//            return
//        }
//        sendMediaMessage(data: image.pngData())
        //        DispatchQueue.global(qos: .userInitiated).async {
        //            UserAPIService.shared.sendImageWithSign(model: .init(fileData: data,
        //                                                                 latitude: latitude,
        //                                                                 longitude: longitude,
        //                                                                 direction: self.locationManager.heading?.magneticHeading ?? 0)) { result in
        //                switch result {
        //
        //                case .success():
        //                    break
        //                case .failure(_):
        //                    onMainThread {
        //                        UIApplication.showAlert(title: "Ошибка!", message: "Не получилось загрузить фотографию, попробуйте позже")
        //                    }
        //
        //                }
        //
        //            }
        //        }
        
    }
}
