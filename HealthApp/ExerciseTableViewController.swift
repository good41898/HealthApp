//
//  MealTableViewController.swift
//  FoodTracker
//
//  Created by Jane Appleseed on 11/15/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit

class ExerciseTableViewController: UITableViewController {
    
    //MARK: Properties
    
    var exercises = [Exercise]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Load the sample data.
        loadSampleExercises()
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
        
        // Fetches the appropriate meal for the data source layout.
        let exercise = exercises[indexPath.row]
        
        cell.nameLabel.text = exercise.name
        cell.photoImageView.image = exercise.photo
        cell.ratingControl.rating = 1
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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

    /*
    //MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Actions
    
    @IBAction func unwindToExerciseList(sender: UIStoryboardSegue) {
        if let sourceViewController = sender.source as? ExerciseViewController, let exercise = sourceViewController.exercise {
            
            // Add a new meal.
            let newIndexPath = IndexPath(row: exercises.count, section: 0)
            
            exercises.append(exercise)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    //MARK: Private Methods
    
    private func loadSampleExercises() {
        
        let photo1 = UIImage(named: "meal1")
        let photo2 = UIImage(named: "meal2")
        let photo3 = UIImage(named: "meal3")

        guard let exercise1 = Exercise(name: "Push Up", photo: photo1) else {
            fatalError("Unable to instantiate meal1")
        }

        guard let exercise2 = Exercise(name: "Pull Up", photo: photo2) else {
            fatalError("Unable to instantiate meal2")
        }

        guard let exercise3 = Exercise(name: "Box jump", photo: photo3) else {
            fatalError("Unable to instantiate meal2")
        }

        exercises += [exercise1, exercise2, exercise3]
    }

}
