//
//  Workout.swift

import UIKit
import os.log


class Workout: NSObject, NSCoding {
    
    //MARK: Properties
    
    var name: String
    var user: String
    var segments = [WorkoutSegment]()
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("workouts")
    
    //MARK: Types
    
    struct PropertyKey {
        static let name = "name"
        static let user = "user"
        static let segments = "segments"
    }
    
    //MARK: Initialization
    
    init?(name: String, user: String, segments: [WorkoutSegment]) {
        // Initialize stored properties.
        self.name = name
        self.user = user
        self.segments = segments
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(user, forKey: PropertyKey.user)
        aCoder.encode(segments, forKey: PropertyKey.segments)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        // The name is required. If we cannot decode a name string, the initializer should fail.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Workout object.", log: OSLog.default, type: .debug)
            return nil
        }
                
        guard let user = aDecoder.decodeObject(forKey: PropertyKey.user) as? String else {
            os_log("Unable to decode the user for a Workout object.", log: OSLog.default, type: .debug)
            return nil
        }
                
        guard let segments = aDecoder.decodeObject(forKey: PropertyKey.segments) as? [WorkoutSegment] else {
            os_log("Unable to decode the segments for a Workout object.", log: OSLog.default, type: .debug)
            return nil
        }

        // Must call designated initializer.
        self.init(name: name, user: user, segments: segments)
        
    }
}
