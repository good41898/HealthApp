//
//  Exercise.swift
//  HealthApp

import UIKit
import os.log


class Exercise: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var photo: UIImage?
    var equipment: Set<String>
    var bodyPart: Set<String>
    var weights: [Int]
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("exercises")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let equipment = "equipment"
        static let bodyPart = "bodyPart"
        static let weights = "weights"
    }
    
    //MARK: Initialization
    
    init?(name: String, photo: UIImage?, equipment: Set<String>, bodyPart: Set<String>, weights: [Int]) {
        
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialization should fail if there is no name or if the rating is negative.
        if name.isEmpty {
            return nil
        }
        
        if equipment.isEmpty || bodyPart.isEmpty {
            return nil
        }
        
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.equipment = equipment
        self.bodyPart = bodyPart
        self.weights = weights
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(equipment, forKey: PropertyKey.equipment)
        aCoder.encode(bodyPart, forKey: PropertyKey.bodyPart)
        aCoder.encode(weights, forKey: PropertyKey.weights)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Exercise object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Exercise, just use conditional cast.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
                
        guard let equipment = aDecoder.decodeObject(forKey: PropertyKey.equipment) as? Set<String> else {
            os_log("Unable to decode the name for a Exercise object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let bodyPart = aDecoder.decodeObject(forKey: PropertyKey.bodyPart) as? Set<String> else {
            os_log("Unable to decode the name for a Exercise object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let weights = aDecoder.decodeObject(forKey: PropertyKey.weights) as? [Int] else {
            os_log("Unable to decode the weights for a Exercise object", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Must call designated initializer.
        self.init(name: name, photo: photo, equipment: equipment, bodyPart: bodyPart, weights: weights)
        
    }
}
