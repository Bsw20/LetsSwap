//
//  AuthService.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 29.01.2021.
//

import Foundation
import UIKit

struct AuthService {
    func signUp(signUpModel: SignUpViewModel, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        
//        auth.signIn(withEmail: email, password: password) { (result, error) in
//            guard let result = result else {
//                completion(.failure(error!))
//                return
//            }
//
//            completion(.success(result.user))
//
//
//        }
        
        #warning("All checks")

        guard let url = URL(string: "http://92.63.105.87:3000/register") else {return}

        let userData = signUpModel.representation

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else { return }
        request.httpBody = httpBody

        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in

            guard let response = response, let data = data else { return }
            print("RESPONSE")
            print(response)

            print("DATA")
            print(data)

            do {
                print("GET JSON")
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print("GET ERROR")
                print(error)
            }
        } .resume()
    }
    
    
    
    func sendSms(login: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        
        #warning("All checks")
        
        guard let url = URL(string: "http://92.63.105.87:3000/smsSend") else {return}
        
        let userData = ["login": login]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: userData, options: []) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            guard let response = response, let data = data else { return }
            print("RESPONSE")
            print(response)
            
            print("DATA")
            print(data)
            
            do {
                print("GET JSON")
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print("GET ERROR")
                print(error)
            }
        } .resume()
    }
}
