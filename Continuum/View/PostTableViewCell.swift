//
//  PostTableViewCell.swift
//  Continuum
//
//  Created by Jason Mandozzi on 7/9/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var commentsLabel: UILabel!
    
    
    var post: Post? {
        didSet {
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }

    func updateViews() {
        guard let post = post else {return}
        captionLabel.text = post.caption
        commentsLabel.text = "\(post.commentCount)"
        postImageView.image = post.photo
    }
    
}
