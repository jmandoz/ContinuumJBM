//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by Jason Mandozzi on 7/9/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController {
    
    var selectedImage: UIImage?
    @IBOutlet weak var selectImageButton: UIButton!
    
    @IBOutlet weak var photoImageView: UIImageView!

    @IBOutlet weak var captionTextField: UITextField!
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        selectImageButton.setTitle("Select Image", for: .normal)
        photoImageView.image = nil
        captionTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
        
    }
    
    @IBAction func imageButtonTapped(_ sender: Any) {
        selectImageButton.setTitle("", for: .normal)
        photoImageView.image = UIImage(named: "spaceEmptyState")
    }
    
    
    @IBAction func addPostButton(_ sender: Any) {
        guard let caption = captionTextField.text else {return}
        if photoImageView.image != nil {
            guard let photo = photoImageView.image else {return}
        PostController.shared.createPostWith(image: photo, caption: caption) { (post) in
            }
            self.tabBarController?.selectedIndex = 0
        }
    }
    
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
 

}
