//
//  NoteViewController.swift
//  NotesApp
//
//  Created by Carmen Popa on 24/03/2018.
//  Copyright © 2018 Carmen Popa. All rights reserved.
//

import UIKit

let cellIdentifier = "imageCell"
var imageMode: Mode = .Normal

class NoteViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, ImageCellDelegate {
    
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var noteTitleTextField: UITextField!
    @IBOutlet weak var noteTextView: UITextView!
    @IBOutlet weak var lastEditLabel: UILabel!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var rightBarButton: UIBarButtonItem!
    
    var currentNote = Note()
    var collectionData = [Image]()
    var deleteModeOn = false
    var isKeyboardUp = false
    var keyboardHeight: CGFloat = 0.0
    
    override func viewWillAppear(_ animated: Bool) {
        loadCell()
        imagesCollectionView.reloadData()
        rightBarButton.image = #imageLiteral(resourceName: "ic_nav_attach")
    }
    override func viewDidLoad() {
        // Do any additional setup after loading the view.
        super.viewDidLoad()
        getLastModifiedDate()
        initializeNotifications()
    }
    
    internal func loadCell() {
        noteTitleTextField.text = currentNote.title
        noteTextView.text = currentNote.detail
        placeholderLabel.isHidden = !(noteTextView.text.count == 0)
        
        if collectionData.count == 0 {
            collectionViewHeight.constant = 0.0
        } else {
            collectionViewHeight.constant = 150
        }
    }
    
    @IBAction func goToMainScreen(_ sender: Any) {
        if(addedNewNote()) {
            currentNote.set(title: noteTitleTextField.text!, detail: noteTextView.text, images:NSSet(array :collectionData), id: UUID().uuidString, lastUpdate: Int64(Date().timeIntervalSince1970))
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func addedNewNote() -> Bool {
        if(noteTextView.text.count != 0 || noteTitleTextField.text?.count != 0 || collectionData.count != 0) {
            return true
        }
        return false
    }
    
    func initializeNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(NoteViewController.handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.delegate = self as? UIGestureRecognizerDelegate
        imagesCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    internal func textViewDidBeginEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = true
    }
    
    internal func textViewDidEndEditing(_ textView: UITextView) {
        placeholderLabel.isHidden = !(noteTextView.text.count == 0)
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
        }
        bottomConstraint.constant += keyboardHeight
        placeholderLabel.isHidden = !(noteTextView.text.count == 0)
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        bottomConstraint.constant -= keyboardHeight
        placeholderLabel.isHidden = !(noteTextView.text.count == 0)
    }
    
    internal func getLastModifiedDate() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        let str = formatter.string(from: Date())
        lastEditLabel.text = str;
    }
    
    // ----- ADD DATA TO COLLECTION VIEW -----
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionData.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell:ImageCollectionViewCell = imagesCollectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath as IndexPath) as! ImageCollectionViewCell
        
        let imageName = collectionData[indexPath.row].imageName
        let image =  getImageFromDisk(named: imageName!)
        cell.loadCell(photo: image!, mode: imageMode, indexPath: indexPath)
        cell.delegate = self
        return cell
    }
    
    // ------ ADD IMAGE FROM CAMERA OR GALLERY --------
    
    @IBAction private func addImagesToNote(_ sender: Any) {
        switch imageMode {
            case .Normal:
                addImage()
            case.Edit:
                imageMode = .Normal
                rightBarButton.image = #imageLiteral(resourceName: "ic_nav_attach")
                rightBarButton.title = nil
                imagesCollectionView.reloadData()
        }
    }
    
    private func addImage() {
        let alertController = UIAlertController(title: nil, message: "Attach image", preferredStyle: .alert)
        let camera = UIAlertAction(title: "Take picture", style: .default, handler: addPhotoFromCamera)
        let gallery = UIAlertAction(title: "Choose from gallery", style: .default, handler: addPhotoFromGallery)
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(camera)
        alertController.addAction(gallery)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    func getImageFromDisk(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        } else {
            return nil
        }
    }
    
    @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let filename = "\(String(Date().timeIntervalSince1970)).png"
            if let data = UIImagePNGRepresentation(pickedImage) {
               if let directory = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) as NSURL {
                    try? data.write(to: directory.appendingPathComponent(filename)!)
                }
            }
            let imgFile = Image()
            imgFile.set(imageName: filename)
            collectionData.append(imgFile)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
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
    
    // ------------ DELETE AN IMAGE -------------------
    
    @objc func handleLongPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
            rightBarButton.image = nil
            rightBarButton.title = "Cancel"
            imageMode = .Edit
            imagesCollectionView.reloadData()
    }
    
    internal func deletePhoto(indexPath: IndexPath) {
        let index = indexPath.row
        collectionData.remove(at: index)
        imagesCollectionView.reloadData()
        if collectionData.count == 0 {
            collectionViewHeight.constant = 0
            rightBarButton.image = #imageLiteral(resourceName: "ic_nav_attach")
            rightBarButton.title = nil
        }
    }
}
