//
//  Comment.swift
//  Continuum
//
//  Created by Jason Mandozzi on 7/11/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import CloudKit

//Creating a Comment class
class Comment: SearchableRecord {
    let text: String
    let timestamp: Date
    let recordID: CKRecord.ID
    weak var post: Post?
    
    //Dedicated initializer for the Comment class
    init(text: String, timestamp: Date = Date(), recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), post: Post?) {
        self.text = text
        self.timestamp = timestamp
        self.recordID = recordID
        self.post = post
    }
    //search function for Comment
    func matches(searchTerm: String) -> Bool {
        return text == searchTerm ? true : false
    }
    //Post reference for Comment
    var postReference: CKRecord.Reference? {
        guard let post = post else {
            return nil
        }
        return CKRecord.Reference(recordID: post.recordID, action: .deleteSelf)
    }
    
    convenience init?(record: CKRecord, post: Post) {
        guard let text = record[CommentConstants.textKey] as? String,
            let timestamp = record[CommentConstants.timestampeKey] as? Date else {return nil}
        self.init(text: text, timestamp: timestamp, recordID: record.recordID, post: post)
    }
}
//Comment Constants
struct CommentConstants {
    static let TypeKey = "Comment"
    static let textKey = "text"
    static let timestampeKey = "timestamp"
    static let postKey = "post"
    static let postReferenceKey = "postReference"
}
