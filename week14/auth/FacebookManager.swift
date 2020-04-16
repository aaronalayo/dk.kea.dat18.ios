//
//  FacebookManager.swift
//  FirebaseLogin
//
//  Created by Aaron ALAYO on 03/04/2020.
//  Copyright © 2020 Aaron ALAYO. All rights reserved.
//

import Foundation
import FacebookCore
import FacebookLogin


class FacebookManager {
    
    
    let parentVC: UIViewController
    init(parentVC: UIViewController) {
        self.parentVC = parentVC
 
    }
    
    
    func loginToFacebook() {
        print("facebook login")
        let manager = LoginManager()
        weak var weakSelf = self
        manager.logIn(permissions: [.publicProfile], viewController: parentVC) { (result) in
            
            print("logged in to facebook \(result)")
            switch result {
            case .cancelled :
                print("login was cancelled")
                break
            case .failed(let error) :
                print("login failed \(error.localizedDescription)")
                break
            case let .success(granted: _, declined: _, token: token):
                print("Facebook login success \(token.userID)")
                if let vc = weakSelf?.parentVC as? StartViewController {
                    vc.firebaseManager?.singInUsingFacebook(tokenString: token.tokenString)
                    vc.showNotes()
                }
                
            }
        }
    }
    
    func makeGraphRequest(){
        if let tokenStr = AccessToken.current?.tokenString {
                    let graphRequest = GraphRequest(graphPath: "/me", parameters: ["fields":"id,name,email, picture"], tokenString: tokenStr, version: Settings.defaultGraphAPIVersion, httpMethod: .get)
                    
                    let connection = GraphRequestConnection()
                    connection.add(graphRequest) { (connection, result, error) in
                        if error == nil, let res = result {
                            print("got data from FB")
                            let dict = res as! [String:Any] //cast to dictionary
                            let name = dict["name"] as! String
        //                    let email = dict["email"] as! String
                            print("the name is:\(name)")
                            //print("the email is:\(email)")
                            print(dict)
                        }else {
                            print("Error getting data from FB\(error.debugDescription)")
                        }
                    }
                    connection.start()
                }
    }
    
    
}
