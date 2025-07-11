//
//  GroupModel.swift
//  WeAct
//
//  Created by 최승아 on 6/30/25.
//

import SwiftUI

struct GroupModel: Hashable, Identifiable, Codable { // POST의 room
    let id: Int
    let name: String
    let startDate: Date
    let endDate: Date
    let reward: String
    let partners: [String]
    let selectedDaysString: String
    let selectedDaysCount: Int
    
    // 서버 응답에서 받은 추가 정보
    let roomId: Int?
    let creatorName: String?
    
    // 기본 생성자
    init(id: Int = UUID().hashValue,
         name: String,
         startDate: Date,
         endDate: Date,
         reward: String,
         partners: [String],
         selectedDaysString: String,
         selectedDaysCount: Int,
         roomId: Int? = nil,
         creatorName: String? = nil) {
        self.id = id
        self.name = name
        self.startDate = startDate
        self.endDate = endDate
        self.reward = reward
        self.partners = partners
        self.selectedDaysString = selectedDaysString
        self.selectedDaysCount = selectedDaysCount
        self.roomId = roomId
        self.creatorName = creatorName
    }
}

extension GroupModel {
    var frequencyText: String {
        return selectedDaysCount == 7 ? "매일" : "주 \(selectedDaysCount)회"
    }
    
    // 화면 표시용 - yyyy.MM.dd 형식
    var period: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let start = formatter.string(from: startDate)
        let end = formatter.string(from: endDate)
        return "\(start) - \(end)"
    }
    
    // 화면 표시용 - MM.dd 형식
    var periodShort: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM.dd"
        let start = formatter.string(from: startDate)
        let end = formatter.string(from: endDate)
        return "\(start) - \(end)"
    }
    
    // 화면 표시용 - yyyy.MM.dd - MM.dd 형식
    var periodShort2: String {
        let startFormatter = DateFormatter()
        startFormatter.dateFormat = "yyyy.MM.dd"
        let start = startFormatter.string(from: startDate)
        
        let endFormatter = DateFormatter()
        endFormatter.dateFormat = "MM.dd"
        let end = endFormatter.string(from: endDate)
        
        return "\(start) - \(end)"
    }
    
    // 서버 통신용 - yyyy-MM-dd 형식
    var serverStartDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: startDate)
    }
    
    var serverEndDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: endDate)
    }
}
