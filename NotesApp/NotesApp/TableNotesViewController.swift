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

/* FEEDBACK:
 - Naming: NotesListController
 - Naming: tableData => notes / noteItems / notesArray / tableNotes
 - Use an enum to define controller states instead of bool "deleteModeOn"
 - No need for comments if code is explicit enough
 - Remove unused methods (didReceiveMemoryWarning)
 - Deselect cells after tapping them
 - There are two different separator styles between cells
 
 enum ListMode {
    case Normal
    case Edit
 }
 
 */

class TableNotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NoteCellDelegate {
    
    @IBOutlet weak var deleteModeBarButton: UIBarButtonItem!
    @IBOutlet weak var loginBarButton: UIBarButtonItem!
    @IBOutlet weak var noNotesView: UIView!
    @IBOutlet weak var newNoteButton: UIButton!
    @IBOutlet weak var notesTableView: UITableView!
    
    var tableData = [NoteClass]()
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadInitialSettings() {
        
        //check if there are any notes
        noNotesView.isHidden = !(tableData.count == 0)
        notesTableView.isHidden = (tableData.count == 0)
        
        //the delete mode is not set yet
        /* FEEDBACK:
         - Use literals, instead of UIImage constructor. Also, you don't need the .png extension
         */
        if deleteModeOn {
            deleteModeBarButton.image = UIImage(named: "ic_nav_close.png")
        } else {
            deleteModeBarButton.image = nil
        }
        self.title = ""
        loginBarButton.image = UIImage(named: "ic_nav_profile.png")
    }
    
    func populateTableWithMockData() {
        for i in 1...20 {
            let newNote = NoteClass()
            newNote.set(title: "Title " + String(i) + " only one line in length", detail: "A very very very very very long Description " + String(i), images: [], id: "10" + String(i), lastUpdate: 100)
            tableData.append(newNote)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteIdentifier, for: indexPath as IndexPath) as! NoteTableViewCell
        let note = tableData[indexPath.row]
        cell.delegate = self
        cell.loadCell(note: note, isDeleteModeOn: deleteModeOn, isSelected: selectedNotesIndex.contains(indexPath.row))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !deleteModeOn {
            let note = tableData[indexPath.row]
            self.performSegue(withIdentifier: SegueToNote, sender: note)
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
    func onCellLongTap(longPressgestureRecognizer: UILongPressGestureRecognizer, cell: UITableViewCell) {
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

    func deleteSelectedNotes(alert: UIAlertAction) {
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

    @IBAction func exitDeleteMode(_ sender: Any) {
        deleteModeOn = false
        selectedNotesIndex.removeAll()
        loadInitialSettings()
        notesTableView.reloadData()
    }
    
    @IBAction func didTapOnRightBarButton(_ sender: Any) {
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
