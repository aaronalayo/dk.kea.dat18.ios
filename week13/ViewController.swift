//
//  ViewController.swift
//  MediaCaptureDemo
//
//  Created by Aaron ALAYO on 27/03/2020.
//  Copyright © 2020 Aaron ALAYO. All rights reserved.
//
import Foundation
import UIKit

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var deleteView: UIImageView!
    @IBOutlet weak var saveView: UIImageView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker = UIImagePickerController()
    var originalImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        imagePicker.delegate = self //assign the object from this class to handle image picking return
        
        
    }
    
    @IBAction func photosBtnPressed(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary //type of task
        imagePicker.allowsEditing = true //should the user be able to edit, like zoom before getting image
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraVideoBtnPressed(_ sender: UIButton) {
        imagePicker.mediaTypes = ["public.movie"]// will launch video in camera app
        imagePicker.videoQuality = .typeMedium //set quality level
        launchCamera()
    }
    fileprivate func launchCamera() {
        imagePicker.sourceType = .camera
        imagePicker.showsCameraControls = true
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func cameraPhotoBtnPressed(_ sender: UIButton) {
        launchCamera()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let url = info[.mediaURL] as? URL {
            if UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(url.path) {
                UISaveVideoAtPathToSavedPhotosAlbum(url.path, nil, nil, nil)
            }
        }else {
            let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
            imageView.image = image
            originalImage = image
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
    fileprivate func writeOnImage(image: UIImage) -> UIImage {
        let text = textField.text!
        let attributedText = NSAttributedString(string: text, attributes:
            [.font:UIFont(name: "Marker Felt", size: 100)!,
             .foregroundColor: UIColor.white])
        let size = image.size
        let renderedImage = UIGraphicsImageRenderer(size:size)
        let imageWithText = renderedImage.image {
            _ in
            image.draw(at:.zero)
            attributedText.draw(at: CGPoint(x:160, y:size.height-300))
            
        }
        return imageWithText
        
    }
    
    @IBAction func doGo(_ sender: Any) {
        if let image = self.imageView.image {
            imageView.image = writeOnImage(image: image)
        }
    }
    
    @IBAction func doRevert(_ sender: Any) {
        textField.text = nil
        imageView.image = originalImage
    }
    
    func config() {
        textField.text = nil
        imageView.image = nil
        
    }
    //register touch
    var startPoint = CGFloat(0) //will be set when the touch begins
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let p = touches.first?.location(in: view) {
            startPoint = p.x
        }
        print("touch began")
        view.endEditing(true)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let p = touches.first?.location(in: view) {
            let diff = p.x - startPoint
//            print(diff)
            //get the difference of your finger movement
            imageView.transform = CGAffineTransform(translationX: diff, y: 0)
            // check how far the image has been moved
            //print("moved to: \(p)")
            // if beyond a limit (right), then remove the image
            guard let image = self.imageView.image else { return }
            if p.x >= 300 {
                imageView.image = nil
                showSaveDelete(save: false)
                print("image deleted")
            } else if diff > 0 && p.x < 300 {
                saveView.alpha = 0
                showSaveDelete(save: diff < 0, alpha: Float(abs(20.0/diff)))
                print("show deleted image")
            }
            // if beyond a limit (left), then save the image
            if p.x <= 20 {
                let newImage = self.resizeImage(image: image, targetSize: CGSize(width: 500.0, height: 500.0))
                UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
                showSaveDelete(save: true)
                
                imageView.image = nil
                print("image saved")
            } else if diff < 0 && p.x > 20 {
                deleteView.alpha = 0
                showSaveDelete(save: diff < 0, alpha: 1.0/Float(abs(20.0/diff)))
                print("show saved image")

            }
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // when the user lets go of the screen
        self.imageView.transform = CGAffineTransform(translationX: 0, y: 0)
        saveView.alpha = 0
        deleteView.alpha = 0
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        print("image resized")
        
        return newImage!
    }
    
    func showSaveDelete(save: Bool) {
        var viewToAnimate = deleteView
        if save {
            viewToAnimate = saveView
        }
        
        UIView.animate(withDuration: 0.4, delay: 0.2, options: UIView.AnimationOptions.curveLinear  , animations: {
            if let view = viewToAnimate {
                view.alpha = 0
            }
        }) { (finished) in
           
        }
    }
    
    func showSaveDelete(save: Bool, alpha: Float) {
        var viewToAnimate = deleteView
        if save {
            viewToAnimate = saveView
        }
        viewToAnimate?.alpha = CGFloat(alpha)
        
    }
}

