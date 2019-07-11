//
//  PostController.swift
//  Continuum
//
//  Created by Jason Mandozzi on 7/9/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class PostController{
    
    //Declaring the database
    let publicDB = CKContainer.default().publicCloudDatabase
    
    //Singleton
    static let shared = PostController()
    
    //Source of Truth
    var posts:[Post] = []
    
    //Crud
    func addComment(text: String, post: Post, completion: @escaping (Comment?) -> Void) {
        let comment = Comment(text: text, post: post)
        post.comments.append(comment)
        let record = CKRecord(comment: comment)
        publicDB.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            guard let record = record else {completion(nil) ; return}
            let comment = Comment(record: record, post: post)
//            self.incrementCommentCount(post: post, completion: nil)
            completion(comment)
        }

    }
    
    func createPostWith(image: UIImage, caption: String, completion: @escaping (Post?) -> Void) {
        let post = Post(photo: image, caption: caption)
        posts.append(post)
        let record = CKRecord(post: post)
        publicDB.save(record) { (record, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            guard let record = record,
                let post = Post(record: record) else {completion(nil) ; return}
            completion(post)
        }
    }
    //Read (Fetch)
    func fetchPosts(completion: @escaping ([Post]?) -> Void) {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: PostConstants.TypeKey, predicate: predicate)
        publicDB.perform(query, inZoneWith: nil) { (record, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            guard let record = record else {completion(nil) ; return}
            let posts = record.compactMap{ Post(record:$0) }
            self.posts = posts
            completion(posts)
        }
    }
    
    func fetchComments(post: Post, completion: @escaping ([Comment]?) -> Void) {
        let postRefence = post.recordID
        let predicate = NSPredicate(format: "%K == %@", CommentConstants.postReferenceKey, postRefence)
        let commentIDs = post.comments.compactMap({$0.recordID})
        let predicate2 = NSPredicate(format: "NOT(recordID IN %@)", commentIDs)
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, predicate2])
        let query = CKQuery(recordType: "Comment", predicate: compoundPredicate)
        publicDB.perform(query, inZoneWith: nil) { (record, error) in
            if let error = error {
                print("Error in \(#function): \(error.localizedDescription) /n---/n \(error)")
                completion(nil)
                return
            }
            guard let record = record else {completion(nil) ; return }
            let comments = record.compactMap{Comment(record: $0, post: post)}
            post.comments.append(contentsOf: comments)
            completion(comments)
        }
    }
    
    //Increment count function
    func incrementCommentCount(post: Post, completion: ((Bool) -> Void)?) {
        post.commentCount += 1
        let modifyOperation = CKModifyRecordsOperation(recordsToSave: [CKRecord(post: post)], recordIDsToDelete: nil)
        modifyOperation.savePolicy = .changedKeys
        modifyOperation.modifyRecordsCompletionBlock = { (records, _, error) in
            if let error = error{
                print("\(error.localizedDescription) \(error) in function: \(#function)")
                completion?(false)
                return
            }else {
                completion?(true)
            }
        }
    CKContainer.default().publicCloudDatabase.add(modifyOperation)
    }
}

