//
//  ExerciseViewController.swift
//  HealthApp

import UIKit
import os.log

class ExerciseViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var equipmentText: UITextField!
    @IBOutlet weak var bodyText: UITextField!
    @IBOutlet weak var lightWeightTextField: UITextField!
    @IBOutlet weak var medWeightTextField: UITextField!
    @IBOutlet weak var heavyWeightTextField: UITextField!
    
    /*
         This value is either passed by `ExerciseTableViewController` in `prepare(for:sender:)`
         or constructed as part of adding a new exercise.
     */
    var exercise: Exercise?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        nameTextField.delegate = self
        
        // Set up views if editing an existing Exercise.
        if let exercise = exercise {
            navigationItem.title = exercise.name
            nameTextField.text = exercise.name
            photoImageView.image = exercise.photo
            equipmentText.text = exercise.equipment.joined(separator: ",")
            bodyText.text = exercise.bodyPart.joined(separator: ",")
            lightWeightTextField.text = String(exercise.weights[0])
            medWeightTextField.text = String(exercise.weights[1])
            heavyWeightTextField.text = String(exercise.weights[2])
        }
        
        // Enable the Save button only if the text field has a valid Exercise name.
        updateSaveButtonState()
        
            /*
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))

        //Uncomment the line below if you want the tap not not interfere and cancel other interactions.
        //tap.cancelsTouchesInView = false

        view.addGestureRecognizer(tap)
 */
    }
    
    //MARK: UITextFieldDelegate
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable the Save button while editing.
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        photoImageView.image = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Depending on style of presentation (modal or push presentation), this view controller needs to be dismissed in two different ways.
        let isPresentingInAddExerciseMode = presentingViewController is UINavigationController
        
        if isPresentingInAddExerciseMode {
            dismiss(animated: true, completion: nil)
        }
        else if let owningNavigationController = navigationController{
            owningNavigationController.popViewController(animated: true)
        }
        else {
            fatalError("The ExerciseViewController is not inside a navigation controller.")
        }
    }
    
    // This method lets you configure a view controller before it's presented.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let equipment = equipmentText.text ?? ""
        let bodyPart = bodyText.text ?? ""
        let lightWeight = Int(lightWeightTextField.text ?? "")
        let medWeight = Int(medWeightTextField.text ?? "")
        let heavyWeight = Int(heavyWeightTextField.text ?? "")
        
        let equipmentSet = Set(equipment.split{$0 == ","}.map(String.init))
        
        let bodyPartSet = Set(bodyPart.split{$0 == ","}.map(String.init))
        
        let weights = [lightWeight, medWeight, heavyWeight]
    
        // Set the exercise to be passed to ExerciseTableViewController after the unwind segue.
        exercise = Exercise(name: name, photo: photo, equipment: equipmentSet, bodyPart: bodyPartSet, weights: weights as! [Int])
    }
    
    //MARK: Actions
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        
        // Hide the keyboard.
        nameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    //MARK: Private Methods
    
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty.
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
}

