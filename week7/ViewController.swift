//
//  ViewController.swift
//  MyNoteBook
//
//  Created by Mac_8 on 14/02/2020.
//  Copyright © 2020 aAron. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
   
    
    
    var theText = ""
    var textArray = [String]() //initialize an empty array
    var currentRow = -1 // -1 means no editing
    let fileName = "String.txt"
   
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textView: UITextField!
    override func viewDidLoad() {//will only get called first time app is launched
        super.viewDidLoad()
        textArray.append("Hello")
        textArray.append("From here on")
        tableView.dataSource = self
        tableView.delegate = self
        
     
        
        
    }

    @IBAction func save(_ sender: UIButton) {
        theText = textView.text!
        if currentRow > -1 {
            textArray[currentRow] = theText
            currentRow = -1
        }else{
            textArray.append(theText)
            
            }
            tableView.reloadData()
            textView.text = ""
            saveStringToFile(str: theText, fileName: fileName)
            print(readStringFromFile(fileName: fileName))
            
}
    
    
    var outPutText =  " Hello type here"
    
    override func viewWillAppear(_ animated: Bool ){
        
        textView.text = outPutText
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return textArray.count
       }
       
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1")
        cell?.textLabel?.text = textArray[indexPath.row]
        return cell!
        
       }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            currentRow = indexPath.row
            textView.text = textArray[currentRow]
          
       
       
            
        }
    
    func saveStringToFile(str:String, fileName:String ){
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
        do{
            try str.write(to: filePath, atomically: true, encoding: .utf8)
            print("ok went well \( str)")
        }catch{
            print("error writing a string \(str)")
        }
    }
    
    func readStringFromFile(fileName:String) -> String {
        let filePath = getDocumentsDirectory().appendingPathComponent(fileName)
        do {
            let string = try String(contentsOf: filePath, encoding: .utf8)
            return string
        } catch  {
            print("error while reading file" + fileName)
        }
        return "empty"
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
