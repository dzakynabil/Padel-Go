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

// MARK: - FETCH SKILLS

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
    
    


}
