//
//  NoteViewController.swift
//  NotesApp
//
//  Created by Carmen Popa on 24/03/2018.
//  Copyright © 2018 Carmen Popa. All rights reserved.
//

import UIKit

let cellIdentifier = "imageCell"

class NoteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate,
UINavigationControllerDelegate {
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var noteTitle: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var lastEditLabel: UILabel!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    var currentNote = Note()
    var collectionData = [Image]()
    var deleteModeOn = false
    
    override func viewWillAppear(_ animated: Bool) {
        if collectionData.count == 0 {
            collectionViewHeight.constant = 0.0
        } else {
            collectionViewHeight.constant = 150
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // ----- ADD DATA TO COLLECTION VIEW -----
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ImageCollectionViewCell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! ImageCollectionViewCell
        
        let imageName = collectionData[indexPath.row].imageName
        let data =  Data(base64Encoded: imageName as String!, options: NSData.Base64DecodingOptions())
        let image = UIImage(data: data!)
        cell.loadCell(photo: image!, deleteModeOn: deleteModeOn)
        
        return cell
    }
    
    // ------ ADD IMAGE FROM CAMERA OF GALLERY --------
    
    @IBAction private func addImagesToNote(_ sender: Any) {
        addImage()
        imagesCollectionView.reloadData()
    }
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let data = UIImagePNGRepresentation(pickedImage) //converts UIImage to NSData
            let imageName = data?.base64EncodedString(options: .lineLength64Characters) //converts NSData to string
            let image = Image()
            image.set(imageName: imageName!)
            collectionData.append(image)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    internal func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        //
        dismiss(animated: true, completion: nil)
    }
    
    func addPhotoFromGallery(alert: UIAlertAction) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func addPhotoFromCamera(alert: UIAlertAction) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    internal func addImage() {
        let alertController = UIAlertController(title: nil, message: "Attach image", preferredStyle: .alert)
        let camera = UIAlertAction(title: "Take picture", style: .default, handler: addPhotoFromCamera)
        let gallery = UIAlertAction(title: "Choose from gallery", style: .default, handler: addPhotoFromGallery)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(camera)
        alertController.addAction(gallery)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
}
