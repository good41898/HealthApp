//
//  WorkoutSegment.swift
//
//  Created by Jane Appleseed on 11/10/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import os.log


class WorkoutSegment: NSObject, NSCoding {
    
    //MARK: Properties
    
    var exercise: Exercise
    var sets: Int
    var reps: Int
    var weight: Float
    
    //MARK: Archiving Paths
    //static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    //static let ArchiveURL = DocumentsDirectory.appendingPathComponent("segments")
    
    //MARK: Types
    
    struct PropertyKey {
        static let exercise = "exercise"
        static let sets = "sets"
        static let reps = "reps"
        static let weight = "weight"
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(exercise, forKey: PropertyKey.exercise)
        aCoder.encode(sets, forKey: PropertyKey.sets)
        aCoder.encode(reps, forKey: PropertyKey.reps)
        aCoder.encode(weight, forKey: PropertyKey.weight)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        
        guard let exercise = aDecoder.decodeObject(forKey: PropertyKey.exercise) as? Exercise else {
            os_log("Unable to decode the exercise for a WorkoutSegment object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        os_log("MADE IT PAST EXERCISE DECODE")
                
        let sets = aDecoder.decodeInteger(forKey: PropertyKey.sets)
        /*
        else {
            os_log("Unable to decode the sets for a WorkoutSegment object.", log: OSLog.default, type: .debug)
            return nil
        }
        */
        let reps = aDecoder.decodeInteger(forKey: PropertyKey.reps)
            /*
        else {
            os_log("Unable to decode the reps for a WorkoutSegment object.", log: OSLog.default, type: .debug)
            return nil
        }
        */
        let weight = aDecoder.decodeFloat(forKey: PropertyKey.weight)
            /*
            as? Float else {
            os_log("Unable to decode the weight for a WorkoutSegment object.", log: OSLog.default, type: .debug)
            return nil
        }
        */
        os_log("ABOUT TO CALL INIT ON WORKOUTSEGMENT")
        // Must call designated initializer.
        self.init(exercise: exercise, sets: sets, reps: reps, weight: weight)
        
    }
    //MARK: Initialization
    
    init?(exercise: Exercise, sets: Int, reps: Int, weight: Float) {
        // Initialize stored properties.
        self.exercise = exercise
        self.sets = sets
        self.reps = reps
        self.weight = weight
    }
}
