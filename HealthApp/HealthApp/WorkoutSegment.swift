//
//  WorkoutSegment.swift
//
//  Created by Jane Appleseed on 11/10/16.
//  Copyright © 2016 Apple Inc. All rights reserved.
//

import UIKit
import os.log


class WorkoutSegment {
    
    //MARK: Properties
    
    var exercise: Exercise
    var sets: Int
    var reps: Int
    var weight: Float
    
    //MARK: Initialization
    
    init?(exercise: Exercise, sets: Int, reps: Int, weight: Float) {
        // Initialize stored properties.
        self.exercise = exercise
        self.sets = sets
        self.reps = reps
        self.weight = weight
    }
}
