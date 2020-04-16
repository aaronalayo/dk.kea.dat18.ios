//
//  CameraHandler.swift
//  FirebaseHelloWorld
//
//  Created by KEA PLAY on 11/03/2020.
//  Copyright © 2020 aAron. All rights reserved.
//

import UIKit
class CameraHandler: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    static let shared = CameraHandler()
        
    fileprivate var currentVC: UIViewController!
        
    //MARK: Internal Properties
    
    var imagePickedBlock: ((UIImage, NSURL) -> Void)?
   
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
        
    }
    
    func photoLibrary()
    {
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self;
            myPickerController.sourceType = .photoLibrary
            currentVC.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    func showActionSheet(vc: UIViewController) {
        currentVC = vc
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.camera()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (alert:UIAlertAction!) -> Void in
            self.photoLibrary()
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        vc.present(actionSheet, animated: true, completion: nil)
    }
    
    
}

extension CameraHandler {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        currentVC.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imageUrl = info[UIImagePickerController.InfoKey.imageURL] as? NSURL,
            let image = info[UIImagePickerController.InfoKey.originalImage]as? UIImage {
            self.imagePickedBlock?(image, imageUrl)
        }else{
            print("Something went wrong")
        }
        currentVC.dismiss(animated: true, completion: nil)
    }
    
        
    
    
    
    
    
}
