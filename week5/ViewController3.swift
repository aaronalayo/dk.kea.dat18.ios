//
//  ViewController3.swift
//  HelloWorld005
//
//  Created by Aaron ALAYO on 07/02/2020.
//  Copyright © 2020 Aaron ALAYO. All rights reserved.
//

import UIKit

class ViewController3: UIViewController {

    @IBOutlet weak var customerName: UITextField!
    
    @IBOutlet weak var customerComment: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func sendButton(_ sender: UIButton) {
        if let cName = customerName.text{
            print(cName)
        }
        if let cComment = customerComment.text{
            print(cComment)
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
