import SwiftUI
import WatchKit

struct WatchProgressView: View {
    
    
    @State private var selectedSkillIndex = 0
    @State private var tempProgress: [String: [String: Double]] = [:]
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    
    private var skills: [PadelSkill] {
        PadelSkill.allSkills
    }
    
    private var selectedSkillName: String {
        skills[selectedSkillIndex].name
    }
    
    private var currentSkill: PadelSkill {
        skills[selectedSkillIndex]
    }
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                
                // Header
                headerView
                
                // Skill Selector
                skillSelectorView
                
                Divider()
                    .background(Color.gray.opacity(0.3))
                
                // Current Skill Name
                Text(currentSkill.name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.green)
                    .padding(.top, 4)
                
                // Sliders Section
                slidersView
                
                Divider()
                    .background(Color.gray.opacity(0.3))
                    .padding(.vertical, 4)
                
                // Send Button
                sendButtonView
                
                // Footer Info
                footerView
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 12)
        }
        .onAppear {
            initializeProgress()
        }
        .alert("Status", isPresented: $showingAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
    
    
    private var headerView: some View {
        HStack {
            Image(systemName: "figure.padel")
                .font(.title3)
                .foregroundColor(.green)
            
            Text("PadelGo Tracker")
                .font(.headline)
                .fontWeight(.semibold)
            
            Spacer()
            
            // Progress indicator
            if !allProgressSaved() {
                Circle()
                    .fill(Color.orange)
                    .frame(width: 8, height: 8)
            }
        }
        .padding(.bottom, 4)
    }
    
    private var skillSelectorView: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("SELECT SKILL")
                .font(.system(size: 10))
                .fontWeight(.medium)
                .foregroundColor(.gray)
                .padding(.leading, 4)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 6) {
                    ForEach(Array(skills.enumerated()), id: \.element.id) { index, skill in
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedSkillIndex = index
                            }
                        }) {
                            Text(skill.name)
                                .font(.system(size: 13, weight: .medium))
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(
                                    selectedSkillIndex == index ?
                                    Color.green : Color.gray.opacity(0.25)
                                )
                                .cornerRadius(20)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .frame(height: 36)
        }
    }
    
    private var slidersView: some View {
        VStack(spacing: 14) {
            ForEach(currentSkill.criteria, id: \.self) { criteria in
                sliderRow(for: criteria)
            }
        }
        .padding(.top, 8)
    }
    
    private func sliderRow(for criteria: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(criteria)
                    .font(.system(size: 12))
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("\(Int(sliderValue(for: criteria)))")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.green)
                    .monospacedDigit()
            }
            
            Slider(
                value: Binding(
                    get: { sliderValue(for: criteria) },
                    set: { newValue in
                        updateProgress(criteria: criteria, value: newValue)
                    }
                ),
                in: 0...100,
                step: 5
            )
            .accentColor(.green)
        }
        .padding(.horizontal, 4)
    }
    
    private var sendButtonView: some View {
        Button(action: sendToiPhone) {
            HStack(spacing: 8) {
                Image(systemName: "iphone.and.arrow.right")
                    .font(.system(size: 14))
                Text("SEND TO IPHONE")
                    .font(.system(size: 13, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(
                LinearGradient(
                    colors: [Color.green, Color.green.opacity(0.7)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(25)
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var footerView: some View {
        Text("Adjust sliders then Send")
            .font(.system(size: 10))
            .foregroundColor(.gray)
            .padding(.top, 4)
    }
    
    
    private func sliderValue(for criteria: String) -> Double {
        return tempProgress[selectedSkillName]?[criteria] ?? 50.0
    }
    
    private func updateProgress(criteria: String, value: Double) {
        if tempProgress[selectedSkillName] == nil {
            tempProgress[selectedSkillName] = [:]
        }
        tempProgress[selectedSkillName]?[criteria] = value
    }
    
    private func initializeProgress() {
        for skill in skills {
            if tempProgress[skill.name] == nil {
                var initialValues: [String: Double] = [:]
                for criteria in skill.criteria {
                    initialValues[criteria] = 50.0
                }
                tempProgress[skill.name] = initialValues
            }
        }
    }
    
    private func allProgressSaved() -> Bool {
        // Check if all skills have progress (always true in this case)
        return true
    }
    
    private func sendToiPhone() {
        // Haptic feedback
        WKInterfaceDevice.current().play(.click)
        
        guard let currentProgress = tempProgress[selectedSkillName] else {
            alertMessage = "No progress data to send"
            showingAlert = true
            return
        }
        
        let singleSkillProgress = [selectedSkillName: currentProgress]
        
        WatchSessionManager.shared.send(
            skills: selectedSkillName,
            progress: singleSkillProgress
        )
        
        // Success feedback
        WKInterfaceDevice.current().play(.success)
        alertMessage = "✓ \(selectedSkillName) progress sent to iPhone!"
        showingAlert = true
        
        // Optional: Log untuk debugging
        print("📱 Sent: \(selectedSkillName)")
        print("📊 Progress: \(currentProgress)")
    }
}

#Preview {
    WatchProgressView()
}
