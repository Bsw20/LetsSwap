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
        let vc = EditProfileViewController()
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }

    weak var viewController: MyProfileViewController?
  
  // MARK: Routing
  
}
