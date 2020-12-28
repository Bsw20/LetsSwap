//
//  AlienProfileConstants.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.12.2020.
//

import Foundation
import UIKit

struct AlienProfileConstants {
    public static var chatButtonHeight: CGFloat = 47
    public static var topViewInset: UIEdgeInsets = UIEdgeInsets(top: 10, left: 15, bottom: 777, right: 15)
    public static var chatButtonLeadingOffset: CGFloat = 35
    public static var viewLeadingOffset: CGFloat = 15
    public static var viewTrailingOffset: CGFloat = 15
}

// MARK: - SwiftUI
import SwiftUI

struct AlienProfileConstantsProvider: PreviewProvider {
    static var previews: some View {
        ContainerView().edgesIgnoringSafeArea(.all)
    }

    struct ContainerView: UIViewControllerRepresentable {
        let alienProfileVC = MainTabBarController()

        func makeUIViewController(context: Context) -> some MainTabBarController {
            return alienProfileVC
        }

        func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {

        }
    }
}

