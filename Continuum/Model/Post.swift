//
//  Post.swift
//  Continuum
//
//  Created by Jason Mandozzi on 7/9/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import UIKit

class Post {
    var photoData: Data?
    let timeStamp: Date
    let caption: String
    let comments: [Comment]
    var photo: UIImage? {
        get {
            guard let photoData = photoData else {return nil}
            return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    init(photo: UIImage, caption: String, timeStamp: Date = Date(), comments:[Comment] = []) {
        self.caption = caption
        self.timeStamp = timeStamp
        self.comments = comments
        self.photo = photo
    }
}
class Comment {
    let text: String
    let timestamp: Date
    weak var post: Post?
    
    init(text: String, timestamp: Date = Date(), post: Post?) {
        self.text = text
        self.timestamp = timestamp
        self.post = post
    }
}


