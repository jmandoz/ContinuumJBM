//
//  Post.swift
//  Continuum
//
//  Created by Jason Mandozzi on 7/9/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

//creating a Post Class
class Post: SearchableRecord {
    var photoData: Data?
    let timeStamp: Date
    let caption: String
    var commentCount: Int
    var comments: [Comment]
    let recordID: CKRecord.ID
    var photo: UIImage? {
        get {
            guard let photoData = photoData else {return nil}
            return UIImage(data: photoData)
        } set {
            photoData = newValue?.jpegData(compressionQuality: 0.5)
        }
    }
    //Dedicated initializer for Post
    init(photo: UIImage, caption: String, timeStamp: Date = Date(), comments:[Comment] = [], recordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString), commentCount: Int = 0) {
        self.caption = caption
        self.timeStamp = timeStamp
        self.comments = comments
        self.commentCount = commentCount
        self.recordID = recordID
        self.photo = photo
    }
    
    //Failable intializer for Post
    convenience init?(record: CKRecord) {
            guard let caption = record[PostConstants.captionKey] as? String,
                let timeStamp = record[PostConstants.timeStampKey] as? Date,
                let photoAsset = record[PostConstants.photoKey] as? CKAsset else {return nil}
        
        guard let photoData = try? Data(contentsOf: photoAsset.fileURL!) else {return nil}
        guard let photo = UIImage(data: photoData) else {return nil}
        self.init(photo: photo, caption: caption, timeStamp: timeStamp, comments: [], recordID: record.recordID)

    }
        
        //Searchbar matching function
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
        
        //creating an Image Asset CKAsset
        var imageAsset: CKAsset? {
            get {
                let tempDirectory = NSTemporaryDirectory()
                let tempDirecotryURL = URL(fileURLWithPath: tempDirectory)
                let fileURL = tempDirecotryURL.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
                do {
                    try photoData?.write(to: fileURL)
                }
                catch {
                    print("Error writing to temp url \(error) \(error.localizedDescription)")
                }
                return CKAsset(fileURL: fileURL)
            }
        }
    }


//Post Constants
struct PostConstants {
    static let TypeKey = "Post"
    static let captionKey = "caption"
    static let commentsKey = "comments"
    static let commentCountKey = "commentCount"
    static let photoKey = "photo"
    static let timeStampKey = "timeStamp"
    static let photoDataKey = "photoData"
}

