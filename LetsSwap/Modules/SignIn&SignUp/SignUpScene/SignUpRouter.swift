//
//  SignUpRouter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.01.2021.
//  Copyright (c) 2021. All rights reserved.
//

import UIKit

protocol SignUpRoutingLogic {
    func routeToCityListController(selectedCity: String)
    func routeToSMSScene(data: SignUpViewModel)
}

class SignUpRouter: NSObject, SignUpRoutingLogic {
  weak var viewController: SignUpViewController?
  
    // MARK: Routing
    func routeToCityListController(selectedCity: String){
        let vc = CitiesListViewController(selectedCity: selectedCity)
        vc.delegate = viewController
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    func routeToSMSScene(data: SignUpViewModel) {
        let vc = SMSConfirmViewController(authType: .signUp(data: data))
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
