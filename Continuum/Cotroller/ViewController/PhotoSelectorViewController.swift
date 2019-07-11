//
//  PhotoSelectorViewController.swift
//  Continuum
//
//  Created by Jason Mandozzi on 7/10/19.
//  Copyright © 2019 Jason Mandozzi. All rights reserved.
//

import UIKit

class PhotoSelectorViewController: UIViewController {
    
    weak var delegate: AddPhotoSelectorViewControllerDelegate?
    
    static let shared = PhotoSelectorViewController()
    
    @IBOutlet weak var selectPhotoButton: UIButton!
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func imageButtonTapped(_ sender: Any) {
        presentImagePickerActionSheet()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        selectPhotoButton.setTitle("Select Image", for: .normal)
        photoImageView.image = nil
    }

}

extension PhotoSelectorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    //creating the function to present the image picker to the user
    func presentImagePickerActionSheet(){
        //creating an instance of UIImagePickerController initialized
        let imagePickerController = UIImagePickerController()
        //setting the ImagePickerController delegate
        imagePickerController.delegate = self
        //creating the action sheet that let's the user select either select a photo or use the camera
        let actionSheet = UIAlertController(title: "Select a photo or take a picture", message: nil, preferredStyle: .actionSheet)
        //MARK: - Select a photo from the Library
        //Here we check if the photoLibrary is available as a source type
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            //if it is available, we add an action to the action sheet titled "Photo" and if it is selected, than the code below will run
            actionSheet.addAction(UIAlertAction(title: "Photo", style: .default, handler: { (_) in
                //we set our instance of imagePickerController and set it equal the source type we want: in this case photoLibrary
                imagePickerController.sourceType = .photoLibrary
                //we present imagePicker Controller
                self.present(imagePickerController, animated: true, completion:  nil)
            }))
        }
        //MARK: - Select your camera
        //Here we check if the camera source type is available
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //same as above, we are adding an action called "Camera"
            actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (_) in
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }))
        }
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(actionSheet, animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let photo = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectPhotoButton.setTitle("", for: .normal)
            photoImageView.image = photo
            delegate?.addPhotoSelectorViewControllerSelected(image: photo)
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//Setting the Protocol function for adding the selected image
protocol AddPhotoSelectorViewControllerDelegate: class {
    func addPhotoSelectorViewControllerSelected(image: UIImage)
}


