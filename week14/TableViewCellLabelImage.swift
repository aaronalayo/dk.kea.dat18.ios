//
//  TableViewCellLabelImage.swift
//  FirebaseHelloWorld
//
//  Created by Aaron ALAYO on 17/03/2020.
//  Copyright © 2020 aAron. All rights reserved.
//

import UIKit

class TableViewCellLabelImage: UITableViewCell, CloudStorageDownloadDelegate {
    func imageDownload(image: UIImage) {
        for view in imageContainerView.subviews {
            if let indicator =  view as? UIActivityIndicatorView {
                indicator.stopAnimating()
                indicator.removeFromSuperview()
            }
            imgView.image = image
        }
    }
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var bodyView: UITextView!
    @IBOutlet weak var imageContainerView: UIView!
}
