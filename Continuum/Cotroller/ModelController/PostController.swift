//
//  PostController.swift
//  Continuum
//
//  Created by Jason Mandozzi on 7/9/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import UIKit

class PostController{
    
    //Singleton
    static let shared = PostController()
    
    //Source of Truth
    var posts:[Post] = []
    
    //Crud
    func addComment(text: String, post: Post, completion: @escaping (Comment) -> Void) {
        let comment = Comment(text: text, post: post)
        post.comments.append(comment)
    }
    
    func createPostWith(image: UIImage, caption: String, completion: @escaping (Post?) -> Void) {
        let post = Post(photo: image, caption: caption)
        posts.append(post)
    }
    
}
