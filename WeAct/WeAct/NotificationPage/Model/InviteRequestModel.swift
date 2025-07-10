//
//  InviteRequestModel.swift
//  WeAct
//
//  Created by 주현아 on 7/11/25.
//

import Foundation

struct InviteRequestModel: Codable {
    let roomId: Int
    let state: Int // -1: 거절, 1: 수락
}
