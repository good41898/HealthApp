//
//  WorkoutTableViewController.swift
//  HealthApp

import UIKit
import os.log

class PreferenceSetListTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var preferences = [PreferenceSet]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load any saved exercises, otherwise load sample data.
        if let savedPreferenceSets = loadPreferenceSets() {
            preferences += savedPreferenceSets
        }
        else {
            // Load the sample data.
            loadSamplePreferenceSets()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return preferences.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "PreferenceSetListTableViewCell"
                
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PreferenceSetListTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PreferenceSetListTableViewCell.")
        }
                
        // Fetches the appropriate exercise for the data source layout.
        let preference = preferences[indexPath.row]
        
        cell.nameLabel.text = preference.name
        //cell.photoImageView.image = exercise.photo
        
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            preferences.remove(at: indexPath.row)
            savePreferences()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    @IBAction func unwindToPreferenceSetList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? CreatePreferenceSetViewController, let preference = sourceViewController.preference {
            os_log("UNWINDING.", log: OSLog.default, type: .debug)
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing exercise.
                preferences[selectedIndexPath.row] = preference
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new exercise.
                let newIndexPath = IndexPath(row: preferences.count, section: 0)
                
                preferences.append(preference)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the exercises.
            savePreferences()
        }
    }
    
    //MARK: Private Methods
    
    private func loadSamplePreferenceSets() {
        
        guard let preference1 = PreferenceSet(name: "Gabby's Preferences", user: "Gabby Good", equipment: ["dumbbells", "squat rack", "treadmill"], bodyPart: ["arms", "quads"], mode: "Cardio", numExercises: 10) else {
            fatalError("Unable to instantiate preference1")
        }

        preferences += [preference1]
    }
    
    private func savePreferences() {
        os_log("SAVING.", log: OSLog.default, type: .debug)
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(preferences, toFile: PreferenceSet.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Preferences successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save preferences...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadPreferenceSets() -> [PreferenceSet]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: PreferenceSet.ArchiveURL.path) as? [PreferenceSet]
    }

}
