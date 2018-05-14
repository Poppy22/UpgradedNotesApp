//
//  ImageCollectionViewCell.swift
//  NotesApp
//
//  Created by Carmen Popa on 24/03/2018.
//  Copyright © 2018 Carmen Popa. All rights reserved.
//

import UIKit

protocol ImageCellDelegate {
    func deletePhoto(indexPath: IndexPath)
}

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
 
    var delegate: ImageCellDelegate?
    var indexPath: IndexPath!
    
    internal func loadCell(photo:UIImage, mode: Mode, indexPath: IndexPath) {
        switch mode {
            case .Normal:
                self.deleteButton.isHidden = true
            case .Edit:
                self.deleteButton.isHidden = false
        }
        self.photoImageView.image = photo
        self.indexPath = indexPath
    }

    @IBAction func onDeleteTappedPhoto(_ sender: Any) {
        delegate?.deletePhoto(indexPath: self.indexPath)
    }
}
