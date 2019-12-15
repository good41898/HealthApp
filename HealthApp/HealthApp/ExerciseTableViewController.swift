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
        loadSampleExercises()
        /*
        if let savedExercises = loadExercises() {
            exercises += savedExercises
        }
        else {
            // Load the sample data.
            loadSampleExercises()
        }
 */
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
        
        let photo1 = UIImage(named: "air_squat")
        
        guard let exercise1 = Exercise(name: "Air Squat", photo: photo1, equipment: Set<String>(["bodyweight"]), bodyPart: Set<String>(["legs"])) else {
            fatalError("Unable to instantiate exercise1")
        }
        
        exercises += [exercise1]
        
        let photo2 = UIImage(named: "burpee")
        
        guard let exercise2 = Exercise(name: "Burpee", photo: photo2, equipment: Set<String>(["bodyweight"]), bodyPart: Set<String>(["legs", "arms"])) else {
            fatalError("Unable to instantiate exercise1")
        }
        
        exercises += [exercise2]
        
        let photo3 = UIImage(named: "barbell_thruster")
        
        guard let exercise3 = Exercise(name: "Barbell Thruster", photo: photo3, equipment: Set<String>(["barbell"]), bodyPart: Set<String>(["legs", "arms"])) else {
            fatalError("Unable to instantiate exercise1")
        }
        
        exercises += [exercise3]
        
        let photo4 = UIImage(named: "pull_up")
        
        guard let exercise4 = Exercise(name: "Pull Up", photo: photo4, equipment: Set<String>(["pull up bar"]), bodyPart: Set<String>(["arms"])) else {
            fatalError("Unable to instantiate exercise1")
        }
        
        exercises += [exercise4]
        
        let photo5 = UIImage(named: "stat_db_lunge")
        
        guard let exercise5 = Exercise(name: "Stationary DB Lunge", photo: photo5, equipment: Set<String>(["dumbbell"]), bodyPart: Set<String>(["legs", "arms"])) else {
            fatalError("Unable to instantiate exercise1")
        }
        
        exercises += [exercise5]
        
        let photo6 = UIImage(named: "alt_db_snatch")
        
        guard let exercise6 = Exercise(name: "Alt Dumbbell Snatch", photo: photo6, equipment: Set<String>(["dumbbell"]), bodyPart: Set<String>(["legs", "arms"])) else {
            fatalError("Unable to instantiate exercise1")
        }
        
        exercises += [exercise6]
        
        let photo7 = UIImage(named: "row_sprint")
        
        guard let exercise7 = Exercise(name: "Cal Row Sprint", photo: photo7, equipment: Set<String>(["rower"]), bodyPart: Set<String>(["legs", "arms", "back"])) else {
            fatalError("Unable to instantiate exercise1")
        }
        
        exercises += [exercise7]
        
        let photo8 = UIImage(named: "wb_shot")
        
        guard let exercise8 = Exercise(name: "Wall Ball Shots", photo: photo8, equipment: Set<String>(["medicine ball"]), bodyPart: Set<String>(["legs", "arms"])) else {
            fatalError("Unable to instantiate exercise1")
        }
        
        exercises += [exercise8]
        
        let photo9 = UIImage(named: "medball_clean")
        
        guard let exercise9 = Exercise(name: "Med Ball Clean", photo: photo9, equipment: Set<String>(["medicine ball"]), bodyPart: Set<String>(["legs", "arms"])) else {
            fatalError("Unable to instantiate exercise1")
        }
        
        exercises += [exercise9]
        
        let photo10 = UIImage(named: "barbell_deadlift")
        
        guard let exercise10 = Exercise(name: "Barbell Deadlift", photo: photo10, equipment: Set<String>(["barbell"]), bodyPart: Set<String>(["legs", "arms", "back"])) else {
            fatalError("Unable to instantiate exercise1")
        }
        
        exercises += [exercise10]
        
        let photo11 = UIImage(named: "hang_power_clean")
        
        guard let exercise11 = Exercise(name: "Hang Power Clean", photo: photo11, equipment: Set<String>(["barbell"]), bodyPart: Set<String>(["legs", "arms", "back"])) else {
            fatalError("Unable to instantiate exercise1")
        }
        
        exercises += [exercise11]
        
        let photo12 = UIImage(named: "power_clean")
        
        guard let exercise12 = Exercise(name: "Power Clean", photo: photo12, equipment: Set<String>(["barbell"]), bodyPart: Set<String>(["legs", "arms", "back"])) else {
            fatalError("Unable to instantiate exercise1")
        }
        
        exercises += [exercise12]
        
        let photo13 = UIImage(named: "db_deadlift")
        
        guard let exercise13 = Exercise(name: "Dumbbell Deadlift", photo: photo13, equipment: Set<String>(["dumbbell"]), bodyPart: Set<String>(["legs", "arms", "back"])) else {
            fatalError("Unable to instantiate exercise1")
        }
        
        exercises += [exercise13]
    
        saveExercises()
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
