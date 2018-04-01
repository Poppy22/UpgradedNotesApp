//
//  NoteTableViewCell.swift
//  NotesApp
//
//  Created by Carmen Popa on 24/03/2018.
//  Copyright © 2018 Carmen Popa. All rights reserved.
//

import UIKit

protocol NoteCellDelegate {
    func onCellLongTap(longPressgestureRecognizer: UILongPressGestureRecognizer, cell: UITableViewCell)
}

class NoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var shouldDeleteButton: UIButton!
    @IBOutlet weak var checkButtonWidth: NSLayoutConstraint!
    
    var delegate: NoteCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setGestureRecognizer()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func loadCell(note: NoteClass, isDeleteModeOn: Bool, isSelected: Bool) {
        self.titleLabel.text = note.title
        self.descriptionLabel.text = note.detail
        
        if !isDeleteModeOn {
            self.checkButtonWidth.constant = 0
        } else {
            self.checkButtonWidth.constant = 55
        }
        if !isSelected {
            shouldDeleteButton.setImage(UIImage(named: "checkbox_off.png"), for: .normal)
            //shouldDeleteButton.image = UIImage(named: "checkbox_off.png")
        } else {
            shouldDeleteButton.setImage(UIImage(named: "checkbox_on.png"), for: .normal)
        }
    }
    
    func setGestureRecognizer() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.delegate = self as UIGestureRecognizerDelegate
        self.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        delegate?.onCellLongTap(longPressgestureRecognizer: longPressGestureRecognizer, cell: self)
    }

}
