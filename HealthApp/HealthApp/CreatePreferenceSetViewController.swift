//
//  CreatePreferenceSetViewController.swift
//  HealthApp

import UIKit
import os.log

class CreatePreferenceSetViewController: UIViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var barbellSwitch: UISwitch!
    @IBOutlet weak var squatRackSwitch: UISwitch!
    @IBOutlet weak var treadmillSwitch: UISwitch!
    @IBOutlet weak var rowerSwitch: UISwitch!
    @IBOutlet weak var kettlebellSwitch: UISwitch!
    @IBOutlet weak var dumbbellSwitch: UISwitch!
    @IBOutlet weak var pullUpBarSwitch: UISwitch!
    @IBOutlet weak var airBikeSwitch: UISwitch!
    @IBOutlet weak var medicineBallSwitch: UISwitch!
    @IBOutlet weak var plyoBoxSwitch: UISwitch!
    @IBOutlet weak var bodyweightSwitch: UISwitch!
    
    @IBOutlet weak var armsSwitch: UISwitch!
    @IBOutlet weak var legsSwitch: UISwitch!
    @IBOutlet weak var backSwitch: UISwitch!
    @IBOutlet weak var chestSwitch: UISwitch!
    
    @IBOutlet weak var numExercisesTextField: UITextField!
    var preference: PreferenceSet?
    
    @IBOutlet weak var modePickerTextField: UITextField!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // Sets number of columns in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
   }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        var equipment = Set<String>()
        var bodyPart = Set<String>()
        
        equipment.insert("none")
        
        if barbellSwitch.isOn {
            equipment.insert("barbell")
        }
        
        if squatRackSwitch.isOn {
            equipment.insert("squat rack")
        }
        
        if treadmillSwitch.isOn {
            equipment.insert("treadmill")
        }
        
        if rowerSwitch.isOn {
            equipment.insert("rower")
        }
        
        if kettlebellSwitch.isOn {
            equipment.insert("kettlebell")
        }
        
        if dumbbellSwitch.isOn {
            equipment.insert("dumbbell")
        }
        
        if pullUpBarSwitch.isOn {
            equipment.insert("pull up bar")
        }
        
        if airBikeSwitch.isOn {
            equipment.insert("air bike")
        }
        
        if medicineBallSwitch.isOn {
            equipment.insert("medicine ball")
        }
        
        if plyoBoxSwitch.isOn {
            equipment.insert("plyo box")
        }
        
        if bodyweightSwitch.isOn {
            equipment.insert("bodyweight")
        }
        
        if armsSwitch.isOn {
            bodyPart.insert("arms")
        }
        
        if legsSwitch.isOn {
            bodyPart.insert("legs")
        }
        
        if backSwitch.isOn {
            bodyPart.insert("back")
        }
        
        if chestSwitch.isOn {
            bodyPart.insert("chest")
        }
        
        let numExercises = Int(numExercisesTextField.text ?? "")
        // Set the exercise to be passed to ExerciseTableViewController after the unwind segue.
        preference = PreferenceSet(name: name, user: "Gabby Good", equipment: equipment, bodyPart: bodyPart, numExercises: numExercises!)
    }

    @IBAction func cancel(_ sender: UIBarButtonItem) {
        let isPresentingInCreatePreferenceSetMode = presentingViewController is UINavigationController
        
        if isPresentingInCreatePreferenceSetMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ExerciseViewController is not inside a navigation controller.")
        }
    }
}
