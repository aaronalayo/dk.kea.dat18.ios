//
//  ViewController.swift
//  FirebaseHelloWorld
//
//  Created by Mac_8 on 28/02/2020.
//  Copyright © 2020 aAron. All rights reserved.
//This correspond to week 9 and week 10 assigments

import UIKit

class ViewController: UIViewController, UITextViewDelegate, CloudStorageDownloadDelegate {
    
    
    func imageDownload(image: UIImage) {
        img.image = image
    }
    
    
  
    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var headLine: UITextView!
    @IBOutlet weak var body: UITextView!
    var rowNumber = 0
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firebaseManager = FirebaseManager(parentVC: self) // enable firebaseManager to update GUI
        //Use rowNumber to get the right Note object
        
        if let note = CloudStorage.getNoteAt(index: rowNumber) {
            headLine.text = note.head
            headLine.delegate = self
            body.text = note.body
            body.delegate = self
            if note.image != "empty"{
                CloudStorage.downloadImage(name: note.image, vc: self)
                
            }else {
                print("note is empty")
            }
                
        }
    
    }
    
    @IBAction func camPressed(_ sender: Any) {
        CameraHandler.shared.showActionSheet(vc: self)
        weak var weakSelf = self //instance of the viewController
        CameraHandler.shared.imagePickedBlock = { (image, imageUrl) in
            if let strongSelf = weakSelf { // avoid retention cycle to avoid memory leak
                strongSelf.img.image = image
                
                if let note = CloudStorage.getNoteAt(index: strongSelf.rowNumber) {
                    if let name = imageUrl.lastPathComponent {
                        CloudStorage.updateNote(index: strongSelf.rowNumber, head: note.head, body: note.body, imageUrl: name)
                    }
                }
            }
            CloudStorage.uploadImage(imageUrl: imageUrl)
        }
    }
    
    //MARK:-- UITextView Delegate Methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        print(" begin editing \(textView.text ?? "")")
    }
    
    func textViewDidChange(_ textView: UITextView) {
        print(" did edit \(textView.text ?? "")")
    }
   
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == headLine {
            print(" did edited headLine \(textView.text ?? "")")
            
        }else {
            print(" did edited body \(textView.text ?? "")")
        }
        updateStorage()
    }
    
    func updateStorage() {
        if let note = CloudStorage.getNoteAt(index: rowNumber) {
            CloudStorage.updateNote(index: rowNumber, head: headLine.text, body: body.text, imageUrl: note.image )
        }
        
    }
    

  
    
}
