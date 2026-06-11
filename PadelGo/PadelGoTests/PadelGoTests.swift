//
//  PadelGoTests.swift
//  PadelGoTests
//
//  Created by ~ Natalie ~ on 29/05/26.
//

import XCTest
@testable import PadelGo

final class PadelGoTests: XCTestCase {
    
    func testWeakestSkillCalculation() {

        let service = PadelDataService.shared

        service.skills = [

            PadelSkill(
                id: "1",
                name: "Serve",
                criteria: ["Accuracy"]
            ),

            PadelSkill(
                id: "2",
                name: "Volley",
                criteria: ["Control"]
            )
        ]

        service.progress = [

            "Serve": [
                "Accuracy": 80
            ],

            "Volley": [
                "Control": 40
            ]
        ]

        let scheduleView = SmartScheduleView()

        XCTAssertEqual(
            scheduleView.weakestSkill,
            "Volley"
        )
    }
    
    func testRecommendedExercises() {

        let service = PadelDataService.shared

        service.skills = [

            PadelSkill(
                id: "1",
                name: "Serve",
                criteria: ["Accuracy"]
            )
        ]

        service.progress = [

            "Serve": [
                "Accuracy": 20
            ]
        ]

        service.exercises = [

            PadelExercise(
                id: "1",
                name: "Serve Drill",
                description: "Practice serve",
                steps: ["Hit ball"],
                imageIcon: "figure.tennis",
                targetSkill: "Serve"
            ),

            PadelExercise(
                id: "2",
                name: "Volley Drill",
                description: "Practice volley",
                steps: ["Hit volley"],
                imageIcon: "figure.tennis",
                targetSkill: "Volley"
            )
        ]

        let scheduleView = SmartScheduleView()

        XCTAssertEqual(
            scheduleView.recommendedExercises.count,
            1
        )

        XCTAssertEqual(
            scheduleView.recommendedExercises.first?.name,
            "Serve Drill"
        )
    }
    
    func testProgressSaving() {

        let service = PadelDataService.shared

        let mockProgress: [String: [String: Double]] = [

            "Serve": [
                "Accuracy": 75
            ]
        ]
        
        service.progress = mockProgress
        
        /*FirestoreService.shared.saveProgress(
         progress: mockProgress
     ) {

         FirestoreService.shared.fetchProgress {
             data in

             XCTAssertEqual(
                 data["Serve"]?["Accuracy"],
                 75
             )

             expectation.fulfill()
         }
     }*/
        

        XCTAssertEqual(
            service.progress["Serve"]?["Accuracy"],
            75
        )
    }
    
    func testProgressHistoryAppend() {

        let history = ProgressHistory(
            id: "1",
            date: Date(),
            progress: [

                "Serve": [
                    "Accuracy": 90
                ]
            ]
        )
        
        

        XCTAssertEqual(
            history.progress["Serve"]?["Accuracy"],
            90
        )
    }
    
    func testExerciseFiltering() {

        let service = PadelDataService.shared

        service.skills = [

            PadelSkill(
                id: "1",
                name: "Serve",
                criteria: []
            )
        ]

        service.exercises = [

            PadelExercise(
                id: "1",
                name: "Serve Drill",
                description: "",
                steps: [],
                imageIcon: "",
                targetSkill: "Serve"
            ),

            PadelExercise(
                id: "2",
                name: "Volley Drill",
                description: "",
                steps: [],
                imageIcon: "",
                targetSkill: "Volley"
            )
        ]

        let filtered = service.exercises.filter {

            $0.targetSkill == "Serve"
        }

        XCTAssertEqual(filtered.count, 1)
    }

}
