//
//  MyProfileRouter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol MyProfileRoutingLogic {
    func routeToEditScreen()
}

class MyProfileRouter: NSObject, MyProfileRoutingLogic {
    func routeToEditScreen() {
        let vc = EditProfileViewController(viewModel: EditProfileViewModel(name: "Ярослав", lastname: "Карпунькин", city: "Санкт-Петербург", phoneNumber: "89858182278", imageStringUrl: "https://hsto.org/getpro/habr/post_images/6d4/e15/1a5/6d4e151a581298d9976496d8fbb7f74e.jpg"))
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }

    weak var viewController: MyProfileViewController?
  
  // MARK: Routing
  
}
