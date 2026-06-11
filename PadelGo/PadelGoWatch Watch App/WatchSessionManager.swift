import Foundation
import WatchConnectivity

class WatchSessionManager: NSObject, WCSessionDelegate {
    
    
    static let shared = WatchSessionManager()
    
    
    private var session: WCSession?
    private var isReachable: Bool {
        return session?.isReachable ?? false
    }
    
    
    private override init() {
        super.init()
        setupSession()
    }
    
    
    private func setupSession() {
        if WCSession.isSupported() {
            session = WCSession.default
            session?.delegate = self
            session?.activate()
            print("✅ WatchConnectivity session activated")
        } else {
            print("❌ WCSession not supported on this device")
        }
    }
    
    
    func send(skills: String, progress: [String: [String: Double]]) {
        guard let session = session, session.isReachable else {
            print("⚠️ iPhone not reachable")
            return
        }
        
        let message: [String: Any] = [
            "skill": skills,
            "progress": progress,
            "timestamp": Date().timeIntervalSince1970
        ]
        
        session.sendMessage(message, replyHandler: { reply in
            print("✅ iPhone replied: \(reply)")
        }, errorHandler: { error in
            print("❌ Failed to send message: \(error.localizedDescription)")
        })
    }
    
    
    func requestSkills(completion: @escaping ([PadelSkill]) -> Void) {
        guard let session = session, session.isReachable else {
            print("⚠️ Cannot request skills - iPhone not reachable")
            completion(PadelSkill.allSkills) // Return hardcoded as fallback
            return
        }
        
        session.sendMessage(
            ["request": "skills"],
            replyHandler: { response in
                if let data = response["skills"] as? Data {
                    do {
                        let decoded = try JSONDecoder().decode([PadelSkill].self, from: data)
                        DispatchQueue.main.async {
                            completion(decoded)
                        }
                        return
                    } catch {
                        print("❌ Failed to decode skills: \(error)")
                    }
                }
                // Fallback to hardcoded data
                DispatchQueue.main.async {
                    completion(PadelSkill.allSkills)
                }
            },
            errorHandler: { error in
                print("❌ Request failed: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(PadelSkill.allSkills) // Fallback
                }
            }
        )
    }
    
    
    func sendProgressFile(progress: [String: [String: Double]]) {
        guard let session = session, session.isReachable else { return }
        
        do {
            let data = try JSONSerialization.data(withJSONObject: progress, options: .prettyPrinted)
            let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("progress_\(Date().timeIntervalSince1970).json")
            try data.write(to: tempURL)
            
            session.transferFile(tempURL, metadata: ["type": "progress"])
            print("📁 File transfer initiated")
        } catch {
            print("❌ Failed to create file: \(error)")
        }
    }
    
    
    func session(_ session: WCSession,
                 activationDidCompleteWith activationState: WCSessionActivationState,
                 error: Error?) {
        switch activationState {
        case .activated:
            print("✅ WCSession activated")
        case .inactive:
            print("⚠️ WCSession inactive")
        case .notActivated:
            print("❌ WCSession not activated")
        @unknown default:
            print("⚠️ Unknown activation state")
        }
        
        if let error = error {
            print("❌ Activation error: \(error.localizedDescription)")
        }
    }
    
    func sessionReachabilityDidChange(_ session: WCSession) {
        print("📱 iPhone reachability changed: \(session.isReachable)")
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("📨 Received message from iPhone: \(message)")
        
        // Handle responses from iPhone if needed
        if let response = message["response"] as? String {
            print("iPhone says: \(response)")
        }
    }
}
