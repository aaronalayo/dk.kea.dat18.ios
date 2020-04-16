//
//  LoginViewController.swift
//  FirebaseLogin
//
//  Created by Aaron ALAYO on 03/04/2020.
//  Copyright © 2020 Aaron ALAYO. All rights reserved.
//

import UIKit
import FirebaseAuth


class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    var firebaseManager:FirebaseManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        firebaseManager = FirebaseManager(parentVC: self) // enable firebaseManager to update GUI
    }
    
    
    
    
    @IBAction func loginInPressed(_ sender: UIButton) {
        if verify().isOK {
            firebaseManager?.signIn(email: verify().email, password: verify().password){ (error) in
                if error == nil{
                    self.performSegue(withIdentifier: "afterLoginSegue", sender: self)
                }
                else{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
            }
            
        }
    }
    
    func verify() -> (email:String, password:String, isOK:Bool) {
        if let email = emailField.text, let password = passwordField.text {
            if email.count > 5 && password.count > 5 {
                return (email, password, true)// tuple containing three values
            }

        }
        return ("", "", false)
    }
        
        
    
}
