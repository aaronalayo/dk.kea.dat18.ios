//
//  Note.swift
//  FirebaseHelloWorld
//
//  Created by Aaron ALAYO on 02/03/2020.
//  Copyright © 2020 aAron. All rights reserved.
//

import Foundation
class Note{
    
    var id: String
    var head: String
    var body: String
    var image:String
    init (id:String, head:String, body:String, image:String){
        self.id = id
        self.head = head
        self.body = body
        self.image = image
    }
    
    func hasImage() -> Bool {
        return image.count > 0 && image != "empty" // returns true, if there is some image-name string
    }
}
