//
//  PreferenceSet.swift

import UIKit
import os.log


class PreferenceSet: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var user: String
    var equipment: Set<String>
    var bodyPart: Set<String>
    var mode: String
    var numExercises: Int
        
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("preferences")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let user = "user"
        static let equipment = "equipment"
        static let bodyPart = "bodyPart"
        static let mode = "mode"
        static let numExercises = "numExercises"
    }
    
    //MARK: Initialization
    
    init?(name: String, user: String, equipment: Set<String>, bodyPart: Set<String>, mode: String, numExercises: Int) {
        // Initialize stored properties.
        self.name = name
        self.user = user
        self.equipment = equipment
        self.bodyPart = bodyPart
        self.mode = mode
        self.numExercises = numExercises
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(user, forKey: PropertyKey.user)
        aCoder.encode(equipment, forKey: PropertyKey.equipment)
        aCoder.encode(bodyPart, forKey: PropertyKey.bodyPart)
        aCoder.encode(mode, forKey: PropertyKey.mode)
        aCoder.encode(numExercises, forKey: PropertyKey.numExercises)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Workout object.", log: OSLog.default, type: .debug)
            return nil
        }
                
        guard let user = aDecoder.decodeObject(forKey: PropertyKey.user) as? String else {
            os_log("Unable to decode the user for a PreferenceSet object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let bodyPart = aDecoder.decodeObject(forKey: PropertyKey.bodyPart) as? Set<String> else {
            os_log("Unable to decode the bodyPart for a PreferenceSet object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let equipment = aDecoder.decodeObject(forKey: PropertyKey.equipment) as? Set<String> else {
            os_log("Unable to decode the equipment for a PreferenceSet object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        guard let mode = aDecoder.decodeObject(forKey: PropertyKey.mode) as? String else {
            os_log("Unable to decode the mode for a PreferenceSet object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        let numExercises = aDecoder.decodeInteger(forKey: PropertyKey.numExercises)
        
        // Must call designated initializer.
        self.init(name: name, user: user, equipment: equipment, bodyPart: bodyPart, mode: mode, numExercises: numExercises)
        
    }
}
