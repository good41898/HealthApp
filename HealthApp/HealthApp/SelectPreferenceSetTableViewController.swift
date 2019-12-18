//
//  SelectPreferenceSetTableViewController.swift
//  HealthApp

import UIKit
import os

class SelectPreferenceSetTableViewController: UITableViewController {

    //MARK: Properties
    
    var preferences = [PreferenceSet]()
    var selectedPreferenceSet: PreferenceSet?
    
    var workoutName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        os_log("MADE IT")
        
        let alert = UIAlertController(title: "Enter a name for your workout, the select a preference set to use", message: nil, preferredStyle: .alert)

        alert.addTextField(configurationHandler: { textField in
            textField.placeholder = "Input name here..."
        })

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.workoutName = alert.textFields?.first?.text
        }))

        self.present(alert, animated: true)
        // Load any saved exercises, otherwise load sample data.
        if let savedPreferenceSets = loadPreferenceSets() {
            preferences += savedPreferenceSets
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
        let cellIdentifier = "SelectPreferenceSetCellTableViewCell"
                
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SelectPreferenceSetCellTableViewCell  else {
            fatalError("The dequeued cell is not an instance of PreferenceSetListTableViewCell.")
        }
                
        // Fetches the appropriate exercise for the data source layout.
        let preference = preferences[indexPath.row]
        
        cell.nameLabel.text = preference.name
        //cell.photoImageView.image = exercise.photo
        
        return cell
    }

    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        guard let selectedPreferenceSetCell = sender as? SelectPreferenceSetCellTableViewCell else {
            fatalError("Unexpected sender: \(String(describing: sender))")
        }
        
        guard let indexPath = tableView.indexPath(for: selectedPreferenceSetCell) else {
            fatalError("The selected cell is not being displayed by the table")
        }
        
        selectedPreferenceSet = preferences[indexPath.row]
        
    }
    
    private func loadPreferenceSets() -> [PreferenceSet]?  {
        return NSKeyedUnarchiver.unarchiveObject(withFile: PreferenceSet.ArchiveURL.path) as? [PreferenceSet]
    }

}
