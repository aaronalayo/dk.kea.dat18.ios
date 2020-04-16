//
//  StartViewController.swift
//  FirebaseLogin
//
//  Created by Aaron ALAYO on 03/04/2020.
//  Copyright © 2020 Aaron ALAYO. All rights reserved.
//

import UIKit
import FacebookLogin //required for FB loggin
import FacebookCore

class StartViewController: UIViewController {
    var firebaseManager:FirebaseManager?
    var facebookManager:FacebookManager?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        firebaseManager = FirebaseManager(parentVC: self)
        facebookManager = FacebookManager(parentVC: self)
        
    }

    @IBAction func signUpBtnPressed(_ sender: UIButton) {
        self.performSegue(withIdentifier: "signUpSegue", sender: self)
    }
    @IBAction func facebookLoginPressed(_ sender: UIButton) {
        self.facebookManager?.loginToFacebook()
    }
    
    @IBAction func loadFBDataPressed(_ sender: UIButton) {
        self.facebookManager?.makeGraphRequest()
    }
    
    func showNotes() {
        self.performSegue(withIdentifier: "afterLoginFacebookSegue", sender: self)
    }

}
