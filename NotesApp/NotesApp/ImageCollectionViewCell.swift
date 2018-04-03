//
//  ImageCollectionViewCell.swift
//  NotesApp
//
//  Created by Carmen Popa on 24/03/2018.
//  Copyright © 2018 Carmen Popa. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
 
    internal func loadCell(photo:UIImage, deleteModeOn: Bool) {
        self.deleteButton.isHidden = !deleteModeOn
        self.photoImageView.image = photo
    }
}
