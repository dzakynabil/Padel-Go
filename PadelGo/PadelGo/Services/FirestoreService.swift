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

    
    


}
