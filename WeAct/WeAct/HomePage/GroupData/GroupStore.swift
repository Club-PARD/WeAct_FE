//
//  GroupStore.swift
//  WeAct
//
//  Created by 최승아 on 7/1/25.
//

import SwiftUI

class GroupStore: ObservableObject {
    @Published var groups: [GroupModel] = []
    
    func addGroup(_ group: GroupModel) {
        groups.append(group) // 로컬에만 저장
    }
    
//    EX)
//    func addGroup(_ group: GroupModel) async {
//           // 서버에 POST 요청
//           await APIService.createGroup(group)
//           // 성공시 로컬 상태 업데이트
//           groups.append(group)
//       }
//       
//       func fetchGroups() async {
//           // 서버에서 그룹 목록 GET 요청
//           groups = await APIService.fetchGroups()
//       }
    
}
