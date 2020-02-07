//
//  ViewController.swift
//  HelloWorld005
//
//  Created by Aaron ALAYO on 07/02/2020.
//  Copyright © 2020 Aaron ALAYO. All rights reserved.
//

import UIKit

class ViewController: UIViewController {


    @IBOutlet weak var label: UITextField!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

 
    @IBAction func btnPressed(_ sender: UIButton) {
        if let name = textField.text{
        label.text = "Hello \(name)"
    }
    
    
}
}

