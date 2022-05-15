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
    
    let activityIndicator: UIActivityIndicatorView = {
        let av = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        av.translatesAutoresizingMaskIntoConstraints = false
        av.hidesWhenStopped = true
        return av
    }()
    
    var loadingState: LoadingState = .notLoading {
        didSet {
            onMainThread {[weak self] in
                guard let self = self else { return }
                switch self.loadingState {
                case .notLoading:
                    self.imageView.image = nil
                    onMainThread {
                        self.activityIndicator.stopAnimating()
                    }
                case .loading:
                    onMainThread {
                        self.imageView.image = nil
                        self.activityIndicator.isHidden = false
                        self.activityIndicator.startAnimating()
                    }
                case let .loaded(img):
                    onMainThread {
                        self.imageView.backgroundColor = .clear
                        self.imageView.image = img
                        self.activityIndicator.stopAnimating()
                    }
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
    private var cameraImageView: UIImageView = {
       let imageView = UIImageView(image: UIImage(named: "filled_camera"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
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
        label.font = UIFont.systemFont(ofSize: 15)
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
            imageView.set(imageURL: (imageUrl.starts(with: "http") ? "" : ServerAddressConstants.JAVA_SERVER_ADDRESS) + imageUrl)
        }
        
        videoTimeLabel.isHidden = mediaType == .photo
        cameraImageView.isHidden = mediaType == .photo
    }
    
    private func getVideoPreview(value: String, completion: @escaping(UIImage?) -> Void) {
        FilesService.shared.downloadFile(url: URL(string: (value.starts(with: "http") ? "" : ServerAddressConstants.JAVA_SERVER_ADDRESS) + value)){ [weak self](data) in
            guard let self = self, let data = data else {
                self?.imageView.image = nil
                self?.videoTimeLabel.isHidden = true
                completion(nil)
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
                completion(nil)
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
        
        imageView.addSubview(cameraImageView)
        imageView.addSubview(videoTimeLabel)
        imageView.addSubview(activityIndicator)
        
        cameraImageView.snp.makeConstraints { (make) in
            make.width.equalTo(9.06 * 3)
            make.height.equalTo(5.62 * 3)
            make.bottom.equalToSuperview().inset(10)
            make.left.equalToSuperview().offset(3*2)
        }
        
        videoTimeLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(7)
            make.left.equalToSuperview().offset(3)
        }
        
        activityIndicator.snp.makeConstraints { (make) in
            make.centerX.centerY.equalToSuperview()
        }
        
    }
}
