//
//  ListViewController.swift
//  FirebaseHelloWorld
//
//  Created by Aaron ALAYO on 06/03/2020.
//  Copyright © 2020 aAron. All rights reserved.
//  This correspond to week 9 and week 10 assigments
//
import UIKit
import FirebaseAuth

var firebaseManager:FirebaseManager?

class ListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var custom = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self // we handle events for the tableview
        tableView.dataSource = self // we also provide data for the tableview
        CloudStorage.startListener(tableView: tableView)
        firebaseManager = FirebaseManager(parentVC: self) // enable firebaseManager to update GUI
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    
    
    @IBAction func startEditing(_ sender: Any) {
        
        tableView.isEditing = !tableView.isEditing
        deleteButton.isHidden = !tableView.isEditing
    }
    
    @IBAction func deleteRows(_ sender: UIButton) {
        
        if let selectedRows = tableView.indexPathsForSelectedRows {
            
            for indexPath in selectedRows {
                
                CloudStorage.deleteNote(at: indexPath.row)
                
            }
            tableView.reloadData()  
        }
    }
    @IBAction func addPressed(_ sender: UIButton) { // to make a new Note
        CloudStorage.createNote(head: "New Head Line", body: "New Body")
        
        print("created note")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CloudStorage.getSize()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rawCell = tableView.dequeueReusableCell(withIdentifier: "cell1")
        if custom {
            if let cell = tableView.dequeueReusableCell(withIdentifier: "cell2") as? TableViewCellLabelImage {
                if let note = CloudStorage.getNoteAt(index: indexPath.row) {
                    cell.label1.text = note.head
                    cell.bodyView.text = note.body
                    cell.imgView.image = nil
                    
                    if note.hasImage() {
                        let indicator = UIActivityIndicatorView(frame: cell.imageContainerView.frame)
                        cell.imageContainerView.addSubview(indicator)
                        indicator.startAnimating()
                        CloudStorage.downloadImage(name: note.image, vc: cell)
                        
                    }
                   return cell
                }
            }
        } else {
            rawCell?.textLabel?.text = CloudStorage.getNoteAt(index: indexPath.row)?.head
        }
        return rawCell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? ViewController {
            destination.rowNumber = tableView.indexPathForSelectedRow!.row
        }
    }
    @IBAction func custom(_ sender: UIButton) {
        custom = !custom
        tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("selected row number \(indexPath.row)")
        if !tableView.isEditing {
            performSegue(withIdentifier: "segue1", sender: self)
        }
    }
    
    @IBAction func signOut(_ sender: UIButton) {
          // warning: Do not hide content based on this call. Do that in the addIDTokenDidChangeListener
          firebaseManager?.signOut()
         

      }
    

}

