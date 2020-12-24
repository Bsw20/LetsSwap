//
//  CommentPresenter.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 24.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CommentPresentationLogic {
  func presentData(response: Comment.Model.Response.ResponseType)
}

class CommentPresenter: CommentPresentationLogic {
  weak var viewController: CommentDisplayLogic?
  
  func presentData(response: Comment.Model.Response.ResponseType) {
  
  }
  
}
