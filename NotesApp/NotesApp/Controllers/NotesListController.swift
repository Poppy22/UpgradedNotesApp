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
let Title = "My notes"

enum Mode {
    case Normal
    case Edit
}
var screenMode: Mode = .Normal

class NotesListController: UIViewController, UITableViewDelegate, UITableViewDataSource, NoteCellDelegate {
    
    @IBOutlet weak var deleteModeBarButton: UIBarButtonItem!
    @IBOutlet weak var loginBarButton: UIBarButtonItem!
    @IBOutlet weak var noNotesView: UIView!
    @IBOutlet weak var newNoteButton: UIButton!
    @IBOutlet weak var notesTableView: UITableView!
    
    var notesArray = [Note]()
    var selectedNotesIndex = [Int]()
    
    override func viewWillAppear(_ animated: Bool) {
        loadInitialSettings()
        if let index = self.notesTableView.indexPathForSelectedRow {
            self.notesTableView.deselectRow(at: index, animated: true)
        }
    }
    
    override func viewDidLoad() {
        populateTableWithMockData()
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    internal func loadInitialSettings() {
    
        noNotesView.isHidden = !(notesArray.count == 0)
        notesTableView.isHidden = (notesArray.count == 0)
        
        switch screenMode {
            case .Normal:
                deleteModeBarButton.image = nil
                self.title = ""
                loginBarButton.image = #imageLiteral(resourceName: "ic_nav_profile")
            case .Edit:
                deleteModeBarButton.image = #imageLiteral(resourceName: "ic_nav_close")
                loginBarButton.image = #imageLiteral(resourceName: "ic_trash")
        }
        self.title = Title
        self.notesArray = self.notesArray.sorted(by: {$0.lastUpdate > $1.lastUpdate})
        notesTableView.reloadData()
    }
    
    internal func populateTableWithMockData() {
        let note1 = Note()
        note1.set(title: "Doar titluuuu", detail: "", images: [], id: "10", lastUpdate: 111)
        let note2 = Note()
        note2.set(title: "", detail: "Doar descriereeeee", images: [], id: "100", lastUpdate: 111)
        notesArray.append(note1)
        notesArray.append(note2)
        
        for i in 1...20 {
            let newNote = Note()
            newNote.set(title: "Title " + String(i) + " only one line in length", detail: "A very very very very very long Description " + String(i), images: [], id: "10" + String(i), lastUpdate: 100)
            notesArray.append(newNote)
        }
    }
    
    internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notesArray.count
    }
    
    internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteIdentifier, for: indexPath as IndexPath) as! NoteTableViewCell
        let note = notesArray[indexPath.row]
        cell.delegate = self
        cell.loadCell(note: note, mode: screenMode, isSelected: selectedNotesIndex.contains(indexPath.row))
        return cell
    }
    
    internal func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        switch screenMode {
            case .Normal:
                let currentNote = notesArray[indexPath.row]
                self.performSegue(withIdentifier: SegueToNote, sender: currentNote)
            case .Edit:
                self.title = String(selectedNotesIndex.count)
                if selectedNotesIndex.contains(indexPath.row) {
                    let index = selectedNotesIndex.index(of: indexPath.row)
                    selectedNotesIndex.remove(at: index!)
                } else {
                    selectedNotesIndex.insert(indexPath.row, at: 0)
                }
        }
            notesTableView.reloadData()
    }
   
    //long press on a cell to enter delete mode
    internal func onCellLongTap(longPressgestureRecognizer: UILongPressGestureRecognizer, cell: UITableViewCell) {
        if longPressgestureRecognizer.state == UIGestureRecognizerState.began {
            
            if let indexPath = notesTableView.indexPath(for: cell) {
                loginBarButton.image = #imageLiteral(resourceName: "ic_trash")
                deleteModeBarButton.image = #imageLiteral(resourceName: "ic_close_popup")
                screenMode = .Edit
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
            self.notesArray.remove(at: noteIndex)
        }
        screenMode = .Normal
        loadInitialSettings()
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
    
    @IBAction internal func addNewNote(_ sender: Any) {
        if screenMode == .Normal {
            let note = Note()
            self.performSegue(withIdentifier: SegueToNote, sender: note)
        }
    }
    
    @IBAction internal func exitDeleteMode(_ sender: Any) {
        screenMode = .Normal
        selectedNotesIndex.removeAll()
        loadInitialSettings()
    }
    
    @IBAction internal func didTapOnRightBarButton(_ sender: Any) {
        switch screenMode {
            case .Normal:
                self.performSegue(withIdentifier: SegueToLogin, sender: loginBarButton)
            case .Edit:
                let alertController = UIAlertController(title: nil, message: "Are you sure you want to permanently delete these notes?", preferredStyle: .alert)
                let defaultActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                let defaultActionDelete = UIAlertAction(title: "Delete", style: .default, handler: deleteSelectedNotes)
                alertController.addAction(defaultActionCancel)
                alertController.addAction(defaultActionDelete)
                present(alertController, animated: true, completion: nil)
        }
    }
}
