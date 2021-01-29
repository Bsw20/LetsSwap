//
//  SignUpRouter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 27.01.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol SignUpRoutingLogic {
    func routeToCityListController(selectedCity: City)
}

class SignUpRouter: NSObject, SignUpRoutingLogic {

  weak var viewController: SignUpViewController?
  
  // MARK: Routing
    func routeToCityListController(selectedCity: City){
        let vc = CitiesListViewController(selectedCity: selectedCity)
        vc.delegate = viewController
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
