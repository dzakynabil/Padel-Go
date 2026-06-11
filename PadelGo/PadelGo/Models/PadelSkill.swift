//
//  PadelSkill.swift
//  PadelGo
//
//  Created by ~ Natalie ~ on 02/06/26.
//

import Foundation
import SwiftUI
import Combine

// SKILL MODEL

struct PadelSkill: Identifiable, Codable {

    var id: String
    var name: String
    var criteria: [String]
}

