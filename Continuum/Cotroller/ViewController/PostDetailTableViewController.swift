//
//  PostDetailTableViewController.swift
//  Continuum
//
//  Created by Jason Mandozzi on 7/9/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class PostDetailTableViewController: UITableViewController {
    
    var detailLandingPad: Post? {
        didSet {
            DispatchQueue.main.async {
                self.updateViews()
            }
        }
    }
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let post = detailLandingPad else { return }
        PostController.shared.fetchComments(post: post) { (_) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: Any) {
    }
    
    @IBAction func commentButtonTapped(_ sender: Any) {
        presentCommentAlert()
    }
    
    @IBAction func shareButtonTapped(_ sender: Any) {
        guard let photo = detailLandingPad?.photo,
            let caption = detailLandingPad?.caption else {return}
        let activityViewController = UIActivityViewController(activityItems: [photo, caption], applicationActivities: nil)
        present(activityViewController, animated: true, completion: nil)
    }
    
    func updateViews() {
        photoImageView.image = detailLandingPad?.photo
        tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let comments = detailLandingPad?.comments else {return 0}
        return comments.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        
        let comment = detailLandingPad?.comments[indexPath.row]
        cell.textLabel?.text = comment?.text
        cell.detailTextLabel?.text = comment?.timestamp.formatDate()
        
        
        // Configure the cell...
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension PostDetailTableViewController: UITextFieldDelegate {
    func presentCommentAlert() {
        let alertController = UIAlertController(title: "Make a comment", message: "What do you want to say?", preferredStyle: .alert)
        
        alertController.addTextField { (textField) -> Void in
            textField.placeholder = "Comment has a limit of 45 characters."
            textField.autocorrectionType = .yes
            textField.autocapitalizationType = .sentences
            textField.delegate = self
        }
        let addComment = UIAlertAction(title: "Send", style: .default) { (_) in
            guard let commentText = alertController.textFields?.first?.text,
            let post = self.detailLandingPad else {return}
            if commentText != "" {
                PostController.shared.addComment(text: commentText, post: post, completion: { (success) in
                })
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                    
                }
            }
        }
        let cancelAction = UIAlertAction(title:"Cancel", style: .destructive)
        
        alertController.addAction(addComment)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }
}
