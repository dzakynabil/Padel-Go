//
//  WatchSessionManager.swift
//  PadelGo
//
//  Created by Macbook on 11/06/26.
//

import SwiftUI
import Combine
import WatchConnectivity

class WatchSessionManager: NSObject, ObservableObject, WCSessionDelegate {

    static let shared = WatchSessionManager()

    override init() {
        super.init()

        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    // Receive data from Apple Watch
    func session(_ session: WCSession,
                 didReceiveMessage message: [String : Any],
                 replyHandler: @escaping ([String : Any]) -> Void) {

        if let request = message["request"] as? String, request == "skills" {

            do {
                let data = try JSONEncoder().encode(PadelDataService.shared.skills)

                replyHandler(["skills": data])

            } catch {
                replyHandler(["skills": Data()])
            }
        }
    }

    // required delegates
    func sessionDidBecomeInactive(_ session: WCSession) {}
    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate()
    }
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {}
}
