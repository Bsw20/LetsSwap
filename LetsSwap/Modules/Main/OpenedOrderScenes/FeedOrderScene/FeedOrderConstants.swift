//
//  FeedOrderConstants.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 22.12.2020.
//

import Foundation
import UIKit

struct FeedOrderConstants {
    public static var userImageHeight: CGFloat = 40
    public static var titleViewTopOffset: CGFloat = 20
    public static var titleLabelInsets = UIEdgeInsets(top: 20, left: 20, bottom: 777, right: -20)
    public static var descriptionLabelInsets = UIEdgeInsets(top: 20, left: 20, bottom: 777, right: -20)
    public static var swapLabelInsets = UIEdgeInsets(top: 20, left: 20, bottom: 777, right: -20)
    public static var counterOfferLabelInsets = UIEdgeInsets(top: 20, left: 20, bottom: 777, right: -20)
    public static var freeSwapLabelInsets = UIEdgeInsets(top: 20, left: 20, bottom: 777, right: -20)
    public static var swapButtonInsets = UIEdgeInsets(top: 40, left: 20, bottom: 777, right: -20)
    public static var swapButtonHeight: CGFloat = 48
    public static var mainTextColor = #colorLiteral(red: 0.3019607843, green: 0.3019607843, blue: 0.3019607843, alpha: 1)
    
    static let tagsCollectionViewHeight: CGFloat = 43
    static let tagsCollectionViewInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    
    static let photosCollectionViewInset = UIEdgeInsets(top: 20, left: 20, bottom: 777, right: -20)
    static let photosCollectionViewHeight: CGFloat = 281
    
    static let stackViewButtonHeight: CGFloat = 40
    static let stackViewSpacing: CGFloat = 8
    
    struct TopView {
        public static var imageLabelDistance: CGFloat  = 11
        public static var nameLabelTopOffset: CGFloat = 0
        public static var cityLabelBottomInset: CGFloat = 2
    }
    
}

// MARK: - SwiftUI
import SwiftUI

struct FeedOrderConstantsProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let feedOrderVC = MainTabBarController()

        func makeUIViewController(context: Context) -> some MainTabBarController {
            return feedOrderVC
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

        }
    }
}

