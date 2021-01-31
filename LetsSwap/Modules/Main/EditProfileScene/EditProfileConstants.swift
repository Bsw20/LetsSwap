//
//  EditProfileConstants.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 31.12.2020.
//

import Foundation
import UIKit

struct EditProfileConstants {
    static var leadingOffset: CGFloat = 16
    static var trailingInset: CGFloat = -16
    static var subviewsHeight: CGFloat = 40
    static var stackViewSpace: CGFloat = 8
    
    static var addPhotoViewSize = CGSize(width: 87, height: 78)
    static var addPhotoButtonHeight: CGFloat = 28
}


// MARK: - SwiftUI
import SwiftUI

struct EditProfileConstantsProvider: PreviewProvider {
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
