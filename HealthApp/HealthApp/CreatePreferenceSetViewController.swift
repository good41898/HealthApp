//
//  CreatePreferenceSetViewController.swift
//  FoodTracker
//
//  Created by Noah Davis on 12/6/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import UIKit
import os.log

class CreatePreferenceSetViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var barbellSwitch: UISwitch!
    @IBOutlet weak var squatRackSwitch: UISwitch!
    @IBOutlet weak var treadmillSwitch: UISwitch!
    
    @IBOutlet weak var armsSwitch: UISwitch!
    @IBOutlet weak var legsSwitch: UISwitch!
    @IBOutlet weak var backSwitch: UISwitch!
        
    var preference: PreferenceSet?
    
    @IBOutlet weak var modePickerTextField: UITextField!
    
    let modeOptions = ["Choose workout mode", "Cardio", "Strength", "Hybrid"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickerView = UIPickerView()
        pickerView.delegate = self

        modePickerTextField.inputView = pickerView

        // Do any additional setup after loading the view.
    }
    
    // Sets number of columns in picker view
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
       return 1
   }

   // Sets the number of rows in the picker view
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
       return modeOptions.count
   }

   // This function sets the text of the picker view to the content of the "salutations" array
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
       return modeOptions[row]
   }

   // When user selects an option, this function will set the text of the text field to reflect
   // the selected option.
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       modePickerTextField.text = modeOptions[row]
   }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        var equipment = [String]()
        var bodyPart = [String]()
        
        if barbellSwitch.isOn {
            equipment += ["barbell"]
        }
        
        if squatRackSwitch.isOn {
            equipment += ["squat rack"]
        }
        
        if treadmillSwitch.isOn {
            equipment += ["treadmill"]
        }
        
        if armsSwitch.isOn {
            bodyPart += ["arms"]
        }
        
        if legsSwitch.isOn {
            bodyPart += ["legs"]
        }
        
        if backSwitch.isOn {
            bodyPart += ["back"]
        }
        // Set the exercise to be passed to ExerciseTableViewController after the unwind segue.
        preference = PreferenceSet(name: name, user: "Gabby Good", equipment: equipment, bodyPart: bodyPart, mode: "Cardio")
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
