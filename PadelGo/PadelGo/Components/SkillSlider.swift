//
//  SkillSlider.swift
//  PadelGo
//
//  Created by Macbook on 02/06/26.
//

import SwiftUI

struct SkillSlider: View {
    let title: String
    @Binding var value: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(title) 
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Text("\(Int(value))%")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.blue)
            }
            
            Slider(value: $value, in: 0...100, step: 1)
                .tint(.blue)
            
            HStack {
                Text("Poor")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Spacer()
                Text("Average")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Spacer()
                Text("Excellent")
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

