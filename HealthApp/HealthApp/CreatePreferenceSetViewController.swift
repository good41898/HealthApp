//
//  CreatePreferenceSetViewController.swift
//  FoodTracker
//
//  Created by Noah Davis on 12/6/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//

import UIKit
import os.log

class CreatePreferenceSetViewController: UIViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var barbellSwitch: UISwitch!
    @IBOutlet weak var squatRackSwitch: UISwitch!
    @IBOutlet weak var treadmillSwitch: UISwitch!
    
    @IBOutlet weak var armsSwitch: UISwitch!
    @IBOutlet weak var legsSwitch: UISwitch!
    @IBOutlet weak var backSwitch: UISwitch!
    
    @IBOutlet weak var modeSlider: UISlider!
    
    var preference: PreferenceSet?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
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
        preference = PreferenceSet(name: name, user: "Gabby Good", equipment: equipment, bodyPart: bodyPart, mode: 0)
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
