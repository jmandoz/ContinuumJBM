//
//  AddPostTableViewController.swift
//  Continuum
//
//  Created by Jason Mandozzi on 7/9/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class AddPostTableViewController: UITableViewController {
    
    //    weak var delegate: AddPostTableViewControllerDelegate?
    
    var selectedImage: UIImage?
    
    
    @IBOutlet weak var captionTextField: UITextField!
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        captionTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.tabBarController?.selectedIndex = 0
    }
    
    
    
    @IBAction func addPostButton(_ sender: Any) {
        guard let caption = captionTextField.text,
            let photo = selectedImage else {return}
        PostController.shared.createPostWith(image: photo, caption: caption) { (post) in
        }
        self.selectedImage = nil
        self.tabBarController?.selectedIndex = 0
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fromContainer" {
            let destinationVC = segue.destination as? PhotoSelectorViewController
            destinationVC?.delegate = self
        }
    }
    
    
}

//Keyboard Dismiss function - tapping outside the keybooard will dismiss it
extension AddPostTableViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(AddPostTableViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension AddPostTableViewController: AddPhotoSelectorViewControllerDelegate {
    func addPhotoSelectorViewControllerSelected(image: UIImage) {
        selectedImage = image
    }
}
