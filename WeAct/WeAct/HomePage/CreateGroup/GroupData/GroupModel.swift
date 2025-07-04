//
//  GroupModel.swift
//  WeAct
//
//  Created by 최승아 on 6/30/25.
//

import SwiftUI

struct GroupModel: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let period: String
    let reward: String
    let partners: [String]
    let selectedDaysString: [String]
    let selectedDaysCount: Int
    var habitText: String
}

extension GroupModel {
    var frequencyText: String {
        return selectedDaysCount == 7 ? "매일" : "주 \(selectedDaysCount)회"
    }
    
    var periodShort: String {
        let parts = period.components(separatedBy: " - ")
        guard parts.count == 2 else { return period }
        
        let start = String(parts[0].suffix(5))
        let end = String(parts[1].suffix(5))
        
        return "\(start) - \(end)"
    }
}
