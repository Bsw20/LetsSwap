//
//  CommentInteractor.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 24.12.2020.
//  Copyright (c) 2020 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol CommentBusinessLogic {
  func makeRequest(request: Comment.Model.Request.RequestType)
}

class CommentInteractor: CommentBusinessLogic {

  var presenter: CommentPresentationLogic?
  
  func makeRequest(request: Comment.Model.Request.RequestType) {
  }
  
}
