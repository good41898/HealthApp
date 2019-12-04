//
//  ExerciseTableViewController.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 11/15/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import os.log

class ExerciseTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var exercises = [Exercise]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by the table view controller.
        //navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved exercises, otherwise load sample data.
        if let savedExercises = loadExercises() {
            exercises += savedExercises
        }
        else {
            // Load the sample data.
            loadSampleExercises()
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
        return exercises.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "ExerciseTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ExerciseTableViewCell  else {
            fatalError("The dequeued cell is not an instance of ExerciseTableViewCell.")
        }
        
        // Fetches the appropriate exercise for the data source layout.
        let exercise = exercises[indexPath.row]
        
        cell.nameLabel.text = exercise.name
        cell.photoImageView.image = exercise.photo
        
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
            exercises.remove(at: indexPath.row)
            saveExercises()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    //MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {
            
        case "AddItem":
            os_log("Adding a new exercise.", log: OSLog.default, type: .debug)
            
        case "ShowDetail":
            guard let exerciseDetailViewController = segue.destination as? ExerciseViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedExerciseCell = sender as? ExerciseTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedExerciseCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedExercise = exercises[indexPath.row]
            exerciseDetailViewController.exercise = selectedExercise
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }

    
    //MARK: Actions
    
    @IBAction func unwindToExerciseList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ExerciseViewController, let exercise = sourceViewController.exercise {
            
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // Update an existing exercise.
                exercises[selectedIndexPath.row] = exercise
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            }
            else {
                // Add a new exercise.
                let newIndexPath = IndexPath(row: exercises.count, section: 0)
                
                exercises.append(exercise)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
            
            // Save the exercises.
            saveExercises()
        }
    }
    
    //MARK: Private Methods
    
    private func loadSampleExercises() {
        
        let photo1 = UIImage(named: "exercise1")
        let photo2 = UIImage(named: "exercise2")
        let photo3 = UIImage(named: "exercise3")

        guard let exercise1 = Exercise(name: "Bench Press", photo: photo1, equipment: "Bench, Barbell, Plates", bodyPart: "Chest, Forearms, Shoulders") else {
            fatalError("Unable to instantiate exercise1")
        }

        guard let exercise2 = Exercise(name: "Back Squat", photo: photo2, equipment: "Barbell, Plates, Squat Rack", bodyPart: "Body Part: Quads") else {
            fatalError("Unable to instantiate exercise2")
        }

        guard let exercise3 = Exercise(name: "Plank", photo: photo3, equipment: "None", bodyPart: "Body Park: Core") else {
            fatalError("Unable to instantiate exercise2")
        }

        exercises += [exercise1, exercise2, exercise3]
    }
    
    private func saveExercises() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(exercises, toFile: Exercise.ArchiveURL.path)
        if isSuccessfulSave {
            os_log("Exercises successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save exercises...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadExercises() -> [Exercise]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Exercise.ArchiveURL.path) as? [Exercise]
    }

}
