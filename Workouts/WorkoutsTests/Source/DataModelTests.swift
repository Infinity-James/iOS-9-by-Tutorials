//
//  DataModelTests.swift
//  Workouts
//
//  Created by James Valaitis on 20/02/2016.
//  Copyright © 2016 Razeware. All rights reserved.
//

@testable import Workouts
import XCTest

class DataModelTests: XCTestCase {
    
    let dataModel = DataModel()
    
    func testSampleDataAdded() {
        XCTAssert(dataModel.allExercises.count > 0)
        XCTAssert(dataModel.allWorkouts.count > 0)
    }
    
    func testAllWorkoutsEqualWorkoutsArray() {
        XCTAssertEqual(dataModel.workouts, dataModel.allWorkouts)
    }
    
    func testAllExercisesEqualsExerciseArray() {
        XCTAssertEqual(dataModel.exercises, dataModel.allExercises)
    }
    
    func testContainsUserCreatedWorkout() {
        XCTAssertFalse(dataModel.containsUserCreatedWorkout)
        
        let workoutA = Workout()
        dataModel.addWorkout(workoutA)
        
        XCTAssertFalse(dataModel.containsUserCreatedWorkout)
        
        let workoutB = Workout()
        workoutB.userCreated = true
        dataModel.addWorkout(workoutB)
        
        XCTAssert(dataModel.containsUserCreatedWorkout)
        
        dataModel.removeWorkoutAtIndex(dataModel.allWorkouts.count - 1)
        
        XCTAssertFalse(dataModel.containsUserCreatedWorkout)
    }
    
    func testContainsUserCreatedExercise() {
        XCTAssertFalse(dataModel.containsUserCreatedExercise)
        
        let exerciseA = Exercise()
        dataModel.addExercise(exerciseA)
        
        XCTAssertFalse(dataModel.containsUserCreatedExercise)
        
        let exerciseB = Exercise()
        exerciseB.userCreated = true
        dataModel.addExercise(exerciseB)
        
        XCTAssert(dataModel.containsUserCreatedExercise)
        
        dataModel.removeExerciseAtIndex(dataModel.allExercises.count - 1)
        
        XCTAssertFalse(dataModel.containsUserCreatedExercise)
    }
}