//
//  EditProfileRouter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 01.02.2021.
//

import UIKit

protocol EditProfileRoutingLogic {
    func routeToCityListController(selectedCity: String)
}

class EditProfileRouter: NSObject, EditProfileRoutingLogic {
    weak var viewController: EditProfileViewController?

    // MARK: Routing
    func routeToCityListController(selectedCity: String){
        let vc = CitiesListViewController(selectedCity: selectedCity)
        vc.delegate = viewController
        viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}
