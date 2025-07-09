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
    
//    func createGroup(request: RoomRequest) async {
//        guard let url = URL(string: "https://your-server.com/rooms") else {
//            print("Invalid URL")
//            return
//        }
//        
//        var urlRequest = URLRequest(url: url)
//        urlRequest.httpMethod = "POST"
//        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        
//        do {
//            urlRequest.httpBody = try JSONEncoder().encode(request)
//        } catch {
//            print("Encoding error: \(error)")
//            return
//        }
//        
//        do {
//            let (data, response) = try await URLSession.shared.data(for: urlRequest)
//            
//            guard let httpResponse = response as? HTTPURLResponse,
//                  (200...299).contains(httpResponse.statusCode) else {
//                print("Server error: \(response)")
//                return
//            }
//            
//            let newGroup = try JSONDecoder().decode(RoomModel.self, from: data)
//            groups.append(newGroup)
//            print("방 생성 성공: \(newGroup.roomName)")
//            
//        } catch {
//            print("Network or Decoding error: \(error)")
//        }
//    }
    
}
