//
//  PartnerModel.swift
//  WeAct
//
//  Created by 최승아 on 7/2/25.
//
import Foundation

struct PartnerModel: Hashable, Identifiable {
    let id = UUID()
    let name: String
    let profileImageName: String? // nil이면 기본 프로필 출력
    
    // Hashable을 위한 커스텀 구현
    func hash(into hasher: inout Hasher) {
        hasher.combine(name) // name을 기준으로 hash
    }
    
    // Equatable을 위한 커스텀 구현
    static func == (lhs: PartnerModel, rhs: PartnerModel) -> Bool {
        return lhs.name == rhs.name // name을 기준으로 비교
    }
}
