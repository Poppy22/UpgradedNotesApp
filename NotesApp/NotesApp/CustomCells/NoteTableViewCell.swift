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

/* FEEDBACK:
 - Selection management is automatic, you don't need to manage it by yourself (isSelected)
 - UIImageViews has multiple states (normal / highlighted) you can configure the two different images from the storyboard and the selection / highlight will work automatically
 */

class NoteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var checkBoxWidth: NSLayoutConstraint!
    
    var delegate: NoteCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setGestureRecognizer()
    }
    
    internal func loadCell(note: Note, mode: Mode, isSelected: Bool) {
        
        self.titleLabel.isHidden = (note.title == nil)
        self.descriptionLabel.isHidden = (note.detail == nil)
        self.titleLabel.text = note.title
        self.descriptionLabel.text = note.detail
        
        switch mode {
            case .Normal:
                self.checkBoxWidth.constant = 0
            case .Edit:
                self.checkBoxWidth.constant = 55
        }
        
        if note.images?.count == 0 {
            iconImageView.image = #imageLiteral(resourceName: "ic_note_text")
        } else {
            iconImageView.image = #imageLiteral(resourceName: "ic_note_image")
        }
        checkBoxImageView.isHighlighted = isSelected
    }
    
    internal func setGestureRecognizer() {
        let longPressGesture:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress(_:)))
        longPressGesture.minimumPressDuration = 1.0
        longPressGesture.delegate = self as UIGestureRecognizerDelegate
        self.addGestureRecognizer(longPressGesture)
    }
    
    @objc internal func handleLongPress(_ longPressGestureRecognizer: UILongPressGestureRecognizer) {
        delegate?.onCellLongTap(longPressgestureRecognizer: longPressGestureRecognizer, cell: self)
    }

}
