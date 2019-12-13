//
//  WorkoutTableViewController.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 11/15/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import os.log

class WorkoutListTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var workouts = [Workout]()

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
                do { try FileManager.default.removeItem(at: FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!.appendingPathComponent("workouts")) } catch { os_log("couldn't delete")}
        */
        // Load any saved exercises, otherwise load sample data.
        if let savedWorkouts = loadWorkouts() {
            workouts += savedWorkouts
        }
        else {
            // Load the sample data.
            os_log("LOADING SAMPLE WORKOUTS")
            loadSampleWorkouts()
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
        return workouts.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "WorkoutListTableViewCell"
        
        print("BEFORE DEQUE")
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WorkoutListTableViewCell  else {
            fatalError("The dequeued cell is not an instance of WorkoutListTableViewCell.")
        }
        
        print("AFTER DEQUE")
        
        // Fetches the appropriate exercise for the data source layout.
        let workout = workouts[indexPath.row]
        
        cell.nameLabel.text = workout.name
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
            workouts.remove(at: indexPath.row)
            saveWorkouts()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        switch(segue.identifier ?? "") {

        case "showDetail":
            guard let workoutDetailViewController = segue.destination as? WorkoutTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedWorkoutCell = sender as? WorkoutListTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedWorkoutCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedWorkout = workouts[indexPath.row]
            workoutDetailViewController.workout = selectedWorkout
        
        case "addWorkout":
            os_log("creating new workout")
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
    
    //MARK: Private Methods
    
    private func loadSampleWorkouts() {
        
        let exercises = NSKeyedUnarchiver.unarchiveObject(withFile: Exercise.ArchiveURL.path) as? [Exercise]
        
        guard let segment1 = WorkoutSegment(exercise: exercises![0], sets: 3, reps: 10, weight: 50) else {
            fatalError("Unable to create Segment")
        }
        
        guard let segment2 = WorkoutSegment(exercise: exercises![1], sets: 3, reps: 10, weight: 50) else {
            fatalError("Unable to create Segment")
        }
        
        guard let segment3 = WorkoutSegment(exercise: exercises![3], sets:3, reps: 10, weight: 50) else {
            fatalError("Unable to create Segment")
        }

        guard let workout1 = Workout(name: "Gabby's Great Workout", user: "Gabby Good", segments: [segment1, segment2, segment3]) else {
            fatalError("Unable to instantiate exercise1")
        }

        workouts += [workout1]
    }
    
    @IBAction func unwindToSelectPreferenceSet(sender: UIStoryboardSegue) {
        os_log("IN UNWIND")
        let exercises = NSKeyedUnarchiver.unarchiveObject(withFile: Exercise.ArchiveURL.path) as? [Exercise]
        
        if let sourceViewController = sender.source as? SelectPreferenceSetTableViewController, let preferenceSet = sourceViewController.selectedPreferenceSet, let workoutName = sourceViewController.workoutName {
            
            let newWorkout = generateNewWorkout(name: workoutName, preferenceSet: preferenceSet)
            
            guard let segment1 = WorkoutSegment(exercise: exercises![0], sets: 3, reps: 10, weight: 50) else {
                fatalError("Unable to create Segment")
            }
            
            print("SEGMENT NAME: " + segment1.exercise.name)
            
            os_log("CREATED SEGMENT")
            /*
            guard let newWorkout = Workout(name: workoutName, user: "Bob", segments: [segment1]) else {
                fatalError("Unable to instantiate exercise1")
            }
            */
            os_log("CREATED WORKOUT")
            let newIndexPath = IndexPath(row: workouts.count, section: 0)
            
            workouts.append(newWorkout!)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
            os_log("BEFORE SAVEWORKOUTS")
            // Save the exercises.
            saveWorkouts()
        }
    }
    
    private func generateNewWorkout(name: String, preferenceSet: PreferenceSet) -> Workout? {
        let exercises = NSKeyedUnarchiver.unarchiveObject(withFile: Exercise.ArchiveURL.path) as? [Exercise]
        guard let segment1 = WorkoutSegment(exercise: exercises![0], sets: 3, reps: 10, weight: 50) else {
            os_log("unable to create workout segment")
            return nil
        }
        guard let workout = Workout(name: name, user: "Bob", segments: [segment1]) else {
            os_log("unable to create workout")
            return nil
        }
        return workout
    }
    
    private func saveWorkouts() {
        os_log("IN SAVEWORKOUTS")
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(workouts, toFile: Workout.ArchiveURL.path)
        os_log("AFTER ARCHIVEROOTOBJECT")
        if isSuccessfulSave {
            os_log("Workouts successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save exercises...", log: OSLog.default, type: .error)
        }
    }
    
    private func loadWorkouts() -> [Workout]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: Workout.ArchiveURL.path) as? [Workout]
    }

}