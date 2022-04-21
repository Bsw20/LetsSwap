//
//  PhotoCell.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 23.12.2020.
//

import Foundation
import UIKit
import AVFoundation
import SnapKit

protocol PhotoCellDelegate: NSObjectProtocol {
    func deleteButtonTapped(cell: MediaCollectionCell)
}

class MediaCollectionCell: UICollectionViewCell {
    //MARK: - Variables
    enum MediaType {
        case video
        case photo
    }
    enum LoadingState {
        case notLoading
        case loading
        case loaded(UIImage)
    }
    
    let activityIndicator = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
    var loadingState: LoadingState = .notLoading {
        didSet {
            onMainThread {[weak self] in
                guard let self = self else { return }
                switch self.loadingState {
                case .notLoading:
                    self.imageView.image = nil
                    self.activityIndicator.stopAnimating()
                case .loading:
                    self.imageView.image = nil
                    self.activityIndicator.startAnimating()
                case let .loaded(img):
                    self.imageView.backgroundColor = .clear
                    self.imageView.image = img
                    self.activityIndicator.stopAnimating()
                }
            }
        }
    }
    
    
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
        return imageView
    }()
    
    private lazy var deleteButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "deleteButtonIcon"), for: .normal)
        button.isHidden = true
        return button
    }()
    
    private var videoTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        //        label.textColor = .red
        label.text = "00:20"
        label.font = UIFont.systemFont(ofSize: 7)
        return label
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
        videoTimeLabel.isHidden = true
        imageView.backgroundColor = .lightGray
    }
    
    public func configure(imageUrl: String?, mediaType: MediaType ) {
#warning("Placeholder")
        guard let imageUrl = imageUrl else {
            imageView.image = nil
            return
        }
        
        switch mediaType {
        case .video:
            loadingState = .loading
            getVideoPreview(value: imageUrl) { [weak self] (image) in
                guard let self = self else { return }
                self.loadingState = .loaded(image ?? UIImage())
            }
        case .photo:
            videoTimeLabel.isHidden = true
            imageView.set(imageURL: imageUrl)
        }
    }
    
    private func getVideoPreview(value: String, completion: @escaping(UIImage?) -> Void) {
        FilesService.shared.downloadFile(url: URL(string: ServerAddressConstants.JAVA_SERVER_ADDRESS + value)){ [weak self](data) in
            guard let self = self, let data = data else {
                self?.imageView.image = nil
                self?.videoTimeLabel.isHidden = true
                return
                
            }
            do {
                let directory = NSTemporaryDirectory()
                let fileName = "\(NSUUID().uuidString).MOV"
                let fullURL = NSURL.fileURL(withPathComponents: [directory, fileName ])
                try data.write(to: fullURL! as URL)
                self.imageFromVideo(url: fullURL!, at: 0) { (image) in
                    completion(image)
                }
            } catch let error {
                print("SDFHSKDHFIUSDH")
                print(error.localizedDescription)
            }
            
            
        }
    }
    
    private func imageFromVideo(url: URL, at time: TimeInterval, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .default).async {
            let asset = AVURLAsset(url: url)
            
            let assetIG = AVAssetImageGenerator(asset: asset)
            assetIG.appliesPreferredTrackTransform = true
            assetIG.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels
            
            
            let duration = asset.duration
            let durationTime = Int(CMTimeGetSeconds(duration))
            let minutes = durationTime / 60
            let seconds = durationTime % 60
            let videoDuration = "\(String(format: "%02d", minutes)):\(String(format: "%02d", seconds))"
            onMainThread {[weak self] in
                self?.videoTimeLabel.text = videoDuration
            }
            
            let cmTime = CMTime(seconds: time, preferredTimescale: 60)
            let thumbnailImageRef: CGImage
            do {
                thumbnailImageRef = try assetIG.copyCGImage(at: cmTime, actualTime: nil)
            } catch let error {
                print("Error: \(error)")
                return completion(nil)
            }
            
            DispatchQueue.main.async {
                completion(UIImage(cgImage: thumbnailImageRef))
            }
        }
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
extension MediaCollectionCell {
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
