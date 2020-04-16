//
//  FirebaseManager.swift
//  FirebaseLogin
//
//  Created by Aaron ALAYO on 03/04/2020.
//  Copyright © 2020 Aaron ALAYO. All rights reserved.
//

import Foundation
import FirebaseAuth


class FirebaseManager {
    
    var auth = Auth.auth()
    let parentVC:UIViewController
    
    
     init(parentVC: UIViewController) {
           self.parentVC = parentVC
           auth.addIDTokenDidChangeListener { (auth, user) in
                   if user != nil {
                    print("Status: user is logged in: \(user.debugDescription)") // show some GUI
                              }else {
                                  print("Status: user is logged out") // hide content
                   }
            }
       }
    
    func signUp(email: String, password: String, completion: ( (Error?)->())?){
        auth.createUser(withEmail: email, password: password) { (result, error) in
            if let completion = completion {
                completion(error)
            }else {
                if error == nil {
                    print("succesfully logged in to Firebase\(result.debugDescription)")
                }else {
                    print("failed to login\(error.debugDescription)")
                }
            }
        }
    }
    
  
    
    func signIn(email:String, password:String) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            if error == nil { // success
                   print("successfully logged in to Firebase \(result.debugDescription)")
                   // call parentVC to display something, such as parentVC.showPanel()
                   }else {
                   print("Failed to log in \(error.debugDescription)")
            }
        }
    }
    
    func signIn(email:String, password:String, completion: ( (Error?)->())?) {
        auth.signIn(withEmail: email, password: password) { (result, error) in
            if let completion = completion {
                completion(error)
            }else {
                if error == nil { // success
                    print("successfully logged in to Firebase \(result.debugDescription)")
                    // call parentVC to display something, such as parentVC.showPanel()
                }else {
                    print("Failed to log in \(error.debugDescription)")
                }
            }
        }
    }
    
    func signOut() {
        do {
            try auth.signOut()
        }catch let error{
            print("error signing out \(error.localizedDescription)")
        }
    }
    
    func singInUsingFacebook(tokenString: String) {
        //call firebase, using cred from facebook
        let credentials = FacebookAuthProvider.credential(withAccessToken: tokenString)
        auth.signIn(with: credentials) { (result, error) in
            if error == nil {
                print("logged to firebase, using facebook\(result.debugDescription)")
                
            }else {
                print("failed to login to firebase using facebook\(error.debugDescription)")
            }
            
        }
    }
    
 
}
