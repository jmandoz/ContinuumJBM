//
//  CKRecordExtension.swift
//  Continuum
//
//  Created by Jason Mandozzi on 7/11/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import CloudKit

extension CKRecord {
    convenience init(post: Post){
        self.init(recordType: PostConstants.TypeKey, recordID: post.recordID)
        self.setValue(post.caption, forKey: PostConstants.captionKey)
        self.setValue(post.imageAsset, forKey: PostConstants.photoKey)
        self.setValue(post.commentCount, forKey: PostConstants.commentCountKey)
        self.setValue(post.timeStamp, forKey: PostConstants.timeStampKey)
    }
    convenience init(comment: Comment) {
        self.init(recordType: CommentConstants.TypeKey, recordID: comment.recordID)
        self.setValue(comment.text, forKey: CommentConstants.textKey)
        self.setValue(comment.timestamp, forKey: CommentConstants.timestampeKey)
        self.setValue(comment.postReference, forKey: CommentConstants.postReferenceKey)
    }
}

