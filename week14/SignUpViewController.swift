//
//  SignUpViewController.swift
//  FirebaseLogin
//
//  Created by Aaron ALAYO on 03/04/2020.
//  Copyright © 2020 Aaron ALAYO. All rights reserved.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordConfirmField: UITextField!
    var firebaseManager:FirebaseManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        firebaseManager = FirebaseManager(parentVC: self)
    }
    
    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        if let email = emailField.text, let password = passwordField.text {
            if email.count > 5 && password.count > 5 {
                if passwordField.text != passwordConfirmField.text {
                    let alertController = UIAlertController(title: "Password Incorrect", message: "Please re-type password", preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                }
                else{
                    
                    firebaseManager?.signUp(email: email, password: password) { (error) in
                        if error == nil {
                            self.performSegue(withIdentifier: "afterSignUpSegue", sender: self)
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
        }
    }
}


