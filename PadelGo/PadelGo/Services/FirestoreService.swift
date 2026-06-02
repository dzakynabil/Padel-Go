//
//  FirestoreService.swift
//  PadelGo
//
//  Created by ~ Natalie ~ on 02/06/26.
//

import Foundation
import FirebaseFirestore

class FirestoreService {

static let shared = FirestoreService()

private let db = Firestore.firestore()

    // FETCH SKILLS

    func fetchSkills(
        completion: @escaping ([PadelSkill]) -> Void
    ) {

        db.collection("skills")
            .getDocuments(source: .server) { snapshot, error in
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }
                
                let skills = documents.compactMap {
                    document -> PadelSkill? in
                    
                    let data = document.data()

                    guard
                        let id = data["id"] as? String,
                        let name = data["name"] as? String,
                        let criteria =
                            data["criteria"] as? [String]
                    else {

                        return nil
                    }

                    return PadelSkill(
                        id: id,
                        name: name,
                        criteria: criteria
                    )

                }

                completion(skills)

            }
    }
    
    // FETCH EXERCISES

    func fetchExercises(
        completion: @escaping ([PadelExercise]) -> Void
    ) {

        db.collection("exercises")
            .getDocuments(source: .server) { snapshot, error in

                guard let documents = snapshot?.documents else {

                    completion([])
                    return
                }

                let exercises = documents.compactMap {
                    document -> PadelExercise? in

                    let data = document.data()

                    guard
                        let id = data["id"] as? String,
                        let name = data["name"] as? String,
                        let description =
                            data["description"] as? String,
                        let steps =
                            data["steps"] as? [String],
                        let imageIcon =
                            data["imageIcon"] as? String,
                        let targetSkill =
                            data["targetSkill"] as? String
                    else {

                        return nil
                    }

                    return PadelExercise(
                        id: id,
                        name: name,
                        description: description,
                        steps: steps,
                        imageIcon: imageIcon,
                        targetSkill: targetSkill
                    )
                }

                completion(exercises)
            }
    }
    
    // SAVE FULL CURRENT PROGRESS

    func saveProgress(
        progress: [String: [String: Double]],
        completion: (() -> Void)? = nil
    ) {

        db.collection("user_progress")
            .document("local_user")
            .setData(progress) { error in

                if let error = error {

                    print("Error saving progress: \(error)")
                } else {

                    print("Progress saved successfully")
                    completion?()
                }
            }
    }
    
    // FETCH CURRENT PROGRESS

    func fetchProgress(
        completion: @escaping ([String: [String: Double]]) -> Void
        
    ) {

        db.collection("user_progress")
            .document("local_user")
            .getDocument { snapshot, error in

                guard let data = snapshot?.data() else {

                    completion([:])
                    return
                }

                var formatted:
                [String: [String: Double]] = [:]

                for (skill, value) in data {

                    if let criteria =
                        value as? [String: Double] {
                        
                        formatted[skill] = criteria
                    }
                }

                completion(formatted)
            }
    }
    
    // SAVE HISTORY

    func saveProgressHistory(
        progress: [String: [String: Double]]
    ) {

        let historyId = UUID().uuidString


        db.collection("progress_history")
            .document(historyId)
            .setData([

                "id": historyId,
                "date": Timestamp(date: Date()),
                "progress": progress
            ]) { error in

                if let error = error {

                    print("History save error: \(error)")
                } else {

                    print("History saved")
                }
            }
    }
    
    // FETCH LAST 7 HISTORY

    func fetchLast7History(
        completion: @escaping ([ProgressHistory]) -> Void
    ) {

        db.collection("progress_history")
            .order(by: "date", descending: true)
            .limit(to: 7)
            .getDocuments(source: .server) { snapshot, error in

                guard let documents = snapshot?.documents else {

                    completion([])
                    return
                }

                let history = documents.compactMap {
                    document -> ProgressHistory? in

                    let data = document.data()

                    guard
                        let id = data["id"] as? String,
                        let timestamp =
                            data["date"] as? Timestamp,
                        let progress =
                            data["progress"]
                            as? [String: [String: Double]]
                    else {

                        return nil
                    }

                    return ProgressHistory(
                        id: id,
                        date: timestamp.dateValue(),
                        progress: progress
                    )
                }

                completion(history.reversed())
            }
    }
    


}
