//
//  WorkoutTableViewController.swift
//  HealthApp

import UIKit
import os.log

class WorkoutListTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var workouts = [Workout]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load any saved exercises, otherwise load sample data.
        if let savedWorkouts = loadWorkouts() {
            workouts += savedWorkouts
        }
        else {
            // Load the sample data.
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
                
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WorkoutListTableViewCell  else {
            fatalError("The dequeued cell is not an instance of WorkoutListTableViewCell.")
        }
                
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
        
        guard let segment3 = WorkoutSegment(exercise: exercises![2], sets:3, reps: 10, weight: 50) else {
            fatalError("Unable to create Segment")
        }

        guard let workout1 = Workout(name: "Gabby's Great Workout", user: "Gabby Good", segments: [segment1, segment2, segment3]) else {
            fatalError("Unable to instantiate exercise1")
        }

        workouts += [workout1]
    }
    
    @IBAction func unwindToSelectPreferenceSet(sender: UIStoryboardSegue) {
        let exercises = NSKeyedUnarchiver.unarchiveObject(withFile: Exercise.ArchiveURL.path) as? [Exercise]
        
        if let sourceViewController = sender.source as? SelectPreferenceSetTableViewController, let preferenceSet = sourceViewController.selectedPreferenceSet, let workoutName = sourceViewController.workoutName {
            
            let newWorkout = generateNewWorkout(name: workoutName, preferenceSet: preferenceSet)
            
            guard let segment1 = WorkoutSegment(exercise: exercises![0], sets: 3, reps: 10, weight: 50) else {
                fatalError("Unable to create Segment")
            }
            
            let newIndexPath = IndexPath(row: workouts.count, section: 0)
            
            workouts.append(newWorkout!)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
            // Save the exercises.
            saveWorkouts()
        }
    }
    
    private func generateNewWorkout(name: String, preferenceSet: PreferenceSet) -> Workout? {
        let exercises = NSKeyedUnarchiver.unarchiveObject(withFile: Exercise.ArchiveURL.path) as? [Exercise]
        
        var validExercises = [Exercise]()
                
        for exercise in exercises! {
            var validBodyPart = true
            var validEquipment = true
            
            if !exercise.equipment.isSubset(of: preferenceSet.equipment) && !exercise.equipment.isEmpty {
                validEquipment = false
            }
            if !exercise.bodyPart.isSubset(of: preferenceSet.bodyPart) {
                validBodyPart = false
            }
            if validBodyPart && validEquipment {
                validExercises += [exercise]
            }
        }
        
        let numSegments = preferenceSet.numExercises
        var segments = [WorkoutSegment]()
        var mutableValidExercises = validExercises
        for _ in 1...numSegments {
            if mutableValidExercises.isEmpty {
                mutableValidExercises = validExercises
            }
            
            let num = Int.random(in: 0..<mutableValidExercises.count)
            
            let exercise = mutableValidExercises[num]
            mutableValidExercises.remove(at: num)
            
            let sets = Int.random(in: 1..<10)
            var reps = 0
            var weight = 0
            if sets <= 3 {
                reps = Int.random(in: 1..<20)
                weight = exercise.weights[0]
            } else if sets <= 6 {
                reps = Int.random(in: 1..<10)
                weight = exercise.weights[1]
            } else {
                reps = Int.random(in: 1..<5)
                weight = exercise.weights[2]
            }
            guard let segment = WorkoutSegment(exercise: exercise, sets: sets, reps: reps, weight: weight) else {
                os_log("unable to create workout segment")
                return nil
            }
            
            segments += [segment]
        }
        
        guard let workout = Workout(name: name, user: "Bob", segments: segments) else {
            os_log("unable to create workout")
            return nil
        }
        return workout
    }
    
    private func saveWorkouts() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(workouts, toFile: Workout.ArchiveURL.path)
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
