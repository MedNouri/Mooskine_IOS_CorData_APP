//
//  NotesListViewController.swift
//  Mooskine
//
//  Created by Josh Svatek on 2017-05-31.
//  Copyright © 2017 Udacity. All rights reserved.
//

import UIKit
import CoreData
class NotesListViewController: UIViewController, UITableViewDataSource {
    /// A table view that displays a list of notes for a notebook
    @IBOutlet weak var tableView: UITableView!

    /// The notebook whose notes are being displayed
    var notebook: Notebook!
    var fetechedResultController:NSFetchedResultsController<Note>!

    var dataControler:DataController!
    
    
    
    /// A date formatter for date text in note cells
    let dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateStyle = .medium
        return df
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = notebook.name
        navigationItem.rightBarButtonItem = editButtonItem
        
        
        
        

        
               setupFetchedResultsController()
        updateEditButtonState()
    }
    
    func setupFetchedResultsController(){
        
              let fetchrequest:NSFetchRequest<Note> = Note.fetchRequest()
        let predicate = NSPredicate(format: "notebook == %@", notebook)
              fetchrequest.predicate = predicate
              let sortDescriptor = NSSortDescriptor(key: "creadtionDate", ascending: true)
            fetchrequest.sortDescriptors = [sortDescriptor]
              fetechedResultController = NSFetchedResultsController(fetchRequest: fetchrequest, managedObjectContext: dataControler.viewContext, sectionNameKeyPath: nil, cacheName: "notes")
              fetechedResultController.delegate = self
              
              do {
             try  fetechedResultController.performFetch()
              }catch {
                  fatalError("sorry no performFetch")
              }
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       setupFetchedResultsController()
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: false)
            tableView.reloadRows(at: [indexPath], with: .fade)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        fetechedResultController = nil
    }

    // -------------------------------------------------------------------------
    // MARK: - Actions

    @IBAction func addTapped(sender: Any) {
        addNote()
    }

    // -------------------------------------------------------------------------
    // MARK: - Editing

    // Adds a new `Note` to the end of the `notebook`'s `notes` array
    func addNote() {
 
        
        let note = Note(context: dataControler.viewContext)
        note.creadtionDate = Date()
        note.attrtext = NSAttributedString(string: "Empty")
        note.notebook = notebook
        
        try? dataControler.viewContext.save()
      
    }

    // Deletes the `Note` at the specified index path
    func deleteNote(at indexPath: IndexPath) {
           
        let notetoRemove = fetechedResultController.object(at: indexPath)
               dataControler.viewContext.delete(notetoRemove)
                       try? dataControler.viewContext.save()
        
              
        
    
    }

    func updateEditButtonState() {
        if let sections = fetechedResultController.sections {
            
       
            navigationItem.rightBarButtonItem?.isEnabled = sections.count > 0
             }
    }

    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        tableView.setEditing(editing, animated: animated)
    }

    // -------------------------------------------------------------------------
    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return fetechedResultController.sections?.count ?? 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetechedResultController.sections?[0].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aNote = fetechedResultController.object(at: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.defaultReuseIdentifier, for: indexPath) as! NoteCell

        // Configure cell
        cell.textPreviewLabel.attributedText = aNote.attrtext
        cell.dateLabel.text = dateFormatter.string(from: aNote.creadtionDate ?? Date())

        return cell
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete: deleteNote(at: indexPath)
        default: () // Unsupported
        }
    }

    // Helpers

 
    // -------------------------------------------------------------------------
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // If this is a NoteDetailsViewController, we'll configure its `Note`
        // and its delete action
        if let vc = segue.destination as? NoteDetailsViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                vc.note = fetechedResultController.object(at: indexPath)
                vc.dataControler = dataControler
                vc.onDelete = { [weak self] in
                    if let indexPath = self?.tableView.indexPathForSelectedRow {
                        self?.deleteNote(at: indexPath)
                        self?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }
}




extension NotesListViewController:NSFetchedResultsControllerDelegate  {
    
 
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
             switch type {
           case .delete:
               
                 tableView.deleteRows(at: [indexPath!], with: .fade)


               case .insert:
                tableView.insertRows(at: [newIndexPath!], with: .fade)
                      print("")
           case .update:
                      print("")
           default:
               print("")
           }
    }
    
}
