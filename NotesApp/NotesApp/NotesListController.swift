//
//  TableNotesViewController.swift
//  NotesApp
//
//  Created by Carmen Popa on 24/03/2018.
//  Copyright © 2018 Carmen Popa. All rights reserved.
//

import UIKit

let NoteIdentifier = "noteCell"
let SegueToNote = "segueToNote"
let SegueToLogin = "segueToLogin"

class NotesListController: UIViewController, UITableViewDelegate, UITableViewDataSource, NoteCellDelegate {
    
    @IBOutlet weak var deleteModeBarButton: UIBarButtonItem!
    @IBOutlet weak var loginBarButton: UIBarButtonItem!
    @IBOutlet weak var noNotesView: UIView!
    @IBOutlet weak var newNoteButton: UIButton!
    @IBOutlet weak var notesTableView: UITableView!
    
    var tableData = [Note]()
    var deleteModeOn = false
    var selectedNotesIndex = [Int]()
    
    override func viewWillAppear(_ animated: Bool) {
        loadInitialSettings()
    }
    
    override func viewDidLoad() {
        populateTableWithMockData()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    internal func loadInitialSettings() {
    
        noNotesView.isHidden = !(tableData.count == 0)
        notesTableView.isHidden = (tableData.count == 0)
        
        if deleteModeOn {
            deleteModeBarButton.image = #imageLiteral(resourceName: "ic_nav_close")
        } else {
            deleteModeBarButton.image = nil
        }
        self.title = ""
        loginBarButton.image = #imageLiteral(resourceName: "ic_nav_profile")
    }
    
    internal func populateTableWithMockData() {
        for i in 1...20 {
            let newNote = Note()
            newNote.set(title: "Title " + String(i) + " only one line in length", detail: "A very very very very very long Description " + String(i), images: [], id: "10" + String(i), lastUpdate: 100)
            tableData.append(newNote)
        }
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteIdentifier, for: indexPath as IndexPath) as! NoteTableViewCell
        let note = tableData[indexPath.row]
        cell.delegate = self
        cell.loadCell(note: note, isDeleteModeOn: deleteModeOn, isSelected: selectedNotesIndex.contains(indexPath.row))
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !deleteModeOn {
            let currentNote = tableData[indexPath.row]
            self.performSegue(withIdentifier: SegueToNote, sender: currentNote)
        } else {
            if selectedNotesIndex.contains(indexPath.row) {
                let index = selectedNotesIndex.index(of: indexPath.row)
                selectedNotesIndex.remove(at: index!)
            } else {
                selectedNotesIndex.insert(indexPath.row, at: 0)
            }
            notesTableView.reloadData()
            self.title = String(selectedNotesIndex.count)
        }
    }
    
    //long press on a cell to enter delete mode
    internal func onCellLongTap(longPressgestureRecognizer: UILongPressGestureRecognizer, cell: UITableViewCell) {
        if longPressgestureRecognizer.state == UIGestureRecognizerState.began {
            
            if let indexPath = notesTableView.indexPath(for: cell) {
                loginBarButton.image = #imageLiteral(resourceName: "ic_trash")
                deleteModeBarButton.image = #imageLiteral(resourceName: "ic_close_popup")
                deleteModeOn = true
                selectedNotesIndex.append(indexPath.row)
                notesTableView.reloadData()
                self.title = String(selectedNotesIndex.count)
            }
        }
    }

    internal func deleteSelectedNotes(alert: UIAlertAction) {
        selectedNotesIndex.sort()
        selectedNotesIndex.reverse()
        
        for noteIndex in selectedNotesIndex {
            let index = self.selectedNotesIndex.index(of: noteIndex)
            selectedNotesIndex.remove(at: index!)
            self.tableData.remove(at: noteIndex)
        }
        deleteModeOn = false
        loadInitialSettings()
        notesTableView.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == SegueToNote) {
            if sender is Note {
                if let detailsController = segue.destination as? NoteViewController {
                    detailsController.currentNote = (sender as? Note)!
                }
            }
        }
    }
    
    @IBAction internal func exitDeleteMode(_ sender: Any) {
        deleteModeOn = false
        selectedNotesIndex.removeAll()
        loadInitialSettings()
        notesTableView.reloadData()
    }
    
    @IBAction internal func didTapOnRightBarButton(_ sender: Any) {
        if !deleteModeOn {
            self.performSegue(withIdentifier: SegueToLogin, sender: loginBarButton)
        } else {
            let alertController = UIAlertController(title: nil, message: "Are you sure you want to permanently delete these notes?", preferredStyle: .alert)
            let defaultActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            let defaultActionDelete = UIAlertAction(title: "Delete", style: .default, handler: deleteSelectedNotes)
            alertController.addAction(defaultActionCancel)
            alertController.addAction(defaultActionDelete)
            present(alertController, animated: true, completion: nil)
        }
    }
}
