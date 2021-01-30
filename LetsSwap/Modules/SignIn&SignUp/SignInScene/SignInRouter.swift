//
//  SignInRouter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SignInRoutingLogic {
    func routeToSMSScene(data: SignInViewModel)
}

class SignInRouter: NSObject, SignInRoutingLogic {


  weak var viewController: SignInViewController?
  
  // MARK: Routing
    func routeToSMSScene(data: SignInViewModel) {
        let vc = SMSConfirmViewController(authType: .signIn(data: data))
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
  
}
