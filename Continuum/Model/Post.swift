//
//  Post.swift
//  Continuum
//
//  Created by Jason Mandozzi on 7/9/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import UIKit

class Post: SearchableRecord {
    var photoData: Data?
    let timeStamp: Date
    let caption: String
    var comments: [Comment]
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
    func matches(searchTerm: String) -> Bool {
        if caption == searchTerm {
            return true
        } else {
            for comment in comments {
                if comment.matches(searchTerm: searchTerm){
                    return true
                }
            }
        }
        return false
    }
}
class Comment: SearchableRecord {
    let text: String
    let timestamp: Date
    weak var post: Post?
    
    init(text: String, timestamp: Date = Date(), post: Post?) {
        self.text = text
        self.timestamp = timestamp
        self.post = post
    }
    func matches(searchTerm: String) -> Bool {
        return text == searchTerm ? true : false
    }
}


