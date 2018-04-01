//
//  TableNotesViewController.swift
//  NotesApp
//
//  Created by Carmen Popa on 24/03/2018.
//  Copyright © 2018 Carmen Popa. All rights reserved.
//

import UIKit

let NoteIdentifier = "noteCell"

class TableNotesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var deleteModeBarButton: UIBarButtonItem!
    @IBOutlet weak var loginBarButton: UIBarButtonItem!
    @IBOutlet weak var noNotesView: UIView!
    @IBOutlet weak var newNoteButton: UIButton!
    @IBOutlet weak var notesTableView: UITableView!
    
    var tableData = [NoteClass]()
    
    override func viewWillAppear(_ animated: Bool) {
        loadInitialSettings()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadInitialSettings() {
        populateTableWithMockData()
        //check if there are any notes
        noNotesView.isHidden = !(tableData.count == 0)
        notesTableView.isHidden = (tableData.count == 0)
        deleteModeBarButton.image = nil
    }
    
    func populateTableWithMockData() {
        for i in 1...20 {
            let newNote = NoteClass()
            newNote.set(title: "Title " + String(i), detail: "Description " + String(i), images: [], id: "10" + String(i), lastUpdate: 100)
            tableData.append(newNote)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteIdentifier, for: indexPath as IndexPath) as! NoteTableViewCell
        let note = tableData[indexPath.row]
        cell.loadCell(note: note, isSelected: false)
        return cell
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
