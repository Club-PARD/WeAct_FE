//
//  RoomInfoList.swift
//  WeAct
//
//  Created by 최승아 on 7/7/25.
//

import Foundation
import Combine

struct HomeGroupResponse: Decodable {
    let month: Int
    let day: Int
    let roomInformationDtos: [HomeGroupModel]
}

struct HomeGroupModel: Decodable { // roomInformationDtos의 [HomeGroupModel]
    let roomName: String
    let habit: String?  // null 값 허용
    let period: String
    let dayCountByWeek: Int
    let percent: Int
    let memberCount: Int
    let roomId: Int
}

extension HomeGroupModel {
    var isCheckPointTime: Bool {
        let result = percent >= 50 && percent < 60
        print("🔍 [중간점검] roomId=\(roomId), 진행률=\(percent)%, 중간점검시점=\(result)")
        return result
    }
    
    var isCheckPointPassed: Bool {
        let result = percent >= 60
        print("🔍 [중간점검] roomId=\(roomId), 진행률=\(percent)%, 중간점검완료=\(result)")
        return result
    }
    
    var isBeforeCheckPoint: Bool {
        let result = percent < 50
        print("🔍 [중간점검] roomId=\(roomId), 진행률=\(percent)%, 중간점검전=\(result)")
        return result
    }
}

class HomeGroupService {
    static let shared = HomeGroupService()
    private init() {}
    
    func getHomeGroups(token: String) async throws -> HomeGroupResponse {
        guard let url = URL(string: APIConstants.baseURL + "/user/home") else {
            throw URLError(.badURL)
        }

        return try await NetworkService.shared.get(url: url, accessToken: token)
    }
}


//import Foundation
//import Combine
//
//// 전체 홈그룹 리스트를 관리하는 클래스
//class HomeGroupListManager: ObservableObject {
//    @Published var homeGroups: [HomeGroupData] = []
//    @Published var isLoading = false
//    @Published var errorMessage: String?
//    
//    private let homeGroupService = HomeGroupService.shared
//    
//    init() {}
//    
//    // API에서 데이터 가져오기
//    func fetchHomeGroups(token: String) async {
//        await MainActor.run {
//            isLoading = true
//            errorMessage = nil
//        }
//        
//        do {
//            let response = try await homeGroupService.getHomeGroups(token: token)
//            
//            await MainActor.run {
//                // API 응답을 HomeGroupData 객체들로 변환
//                self.homeGroups = response.roomInformationDtos.map { model in
//                    HomeGroupData(from: model)
//                }
//                self.isLoading = false
//            }
//        } catch {
//            await MainActor.run {
//                self.errorMessage = error.localizedDescription
//                self.isLoading = false
//            }
//        }
//    }
//    
//    // 특정 그룹 찾기
//    func findGroup(by roomId: Int) -> HomeGroupData? {
//        return homeGroups.first { $0.roomId == roomId }
//    }
//    
//    // 특정 그룹의 habit 업데이트
//    func updateGroupHabit(roomId: Int, newHabit: String?) {
//        if let group = findGroup(by: roomId) {
//            group.updateHabit(newHabit)
//        }
//    }
//    
//    // 특정 그룹의 percent 업데이트
//    func updateGroupPercent(roomId: Int, newPercent: Int) {
//        if let group = findGroup(by: roomId) {
//            group.updatePercent(newPercent)
//        }
//    }
//    
//    // 특정 그룹의 멤버 수 업데이트
//    func updateGroupMemberCount(roomId: Int, newCount: Int) {
//        if let group = findGroup(by: roomId) {
//            group.updateMemberCount(newCount)
//        }
//    }
//    
//    // 그룹 추가
//    func addGroup(_ model: HomeGroupModel) {
//        let newGroup = HomeGroupData(from: model)
//        homeGroups.append(newGroup)
//    }
//    
//    // 그룹 제거
//    func removeGroup(roomId: Int) {
//        homeGroups.removeAll { $0.roomId == roomId }
//    }
//    
//    // 데이터 새로고침
//    func refreshData(token: String) async {
//        await fetchHomeGroups(token: token)
//    }
//}
//
//// 개별 홈그룹 데이터 클래스
//class HomeGroupData: ObservableObject {
//    @Published var roomName: String
//    @Published var habit: String?
//    @Published var period: String
//    @Published var dayCountByWeek: Int
//    @Published var percent: Int
//    @Published var memberCount: Int
//    let roomId: Int
//    
//    init(from model: HomeGroupModel) {
//        self.roomName = model.roomName
//        self.habit = model.habit
//        self.period = model.period
//        self.dayCountByWeek = model.dayCountByWeek
//        self.percent = model.percent
//        self.memberCount = model.memberCount
//        self.roomId = model.roomId
//    }
//    
//    // 개별 속성 업데이트 함수들
//    func updateHabit(_ newHabit: String?) {
//        habit = newHabit
//    }
//    
//    func updatePercent(_ newPercent: Int) {
//        percent = newPercent
//    }
//    
//    func updateMemberCount(_ newCount: Int) {
//        memberCount = newCount
//    }
//    
//    func updateRoomName(_ newName: String) {
//        roomName = newName
//    }
//    
//    func updatePeriod(_ newPeriod: String) {
//        period = newPeriod
//    }
//    
//    func updateDayCountByWeek(_ newCount: Int) {
//        dayCountByWeek = newCount
//    }
//    
//    // 중간점검 관련 computed properties
//    var isCheckPointTime: Bool {
//        let result = percent >= 50 && percent < 60
//        print("🔍 [중간점검] roomId=\(roomId), 진행률=\(percent)%, 중간점검시점=\(result)")
//        return result
//    }
//    
//    var isCheckPointPassed: Bool {
//        let result = percent >= 60
//        print("🔍 [중간점검] roomId=\(roomId), 진행률=\(percent)%, 중간점검완료=\(result)")
//        return result
//    }
//    
//    var isBeforeCheckPoint: Bool {
//        let result = percent < 50
//        print("🔍 [중간점검] roomId=\(roomId), 진행률=\(percent)%, 중간점검전=\(result)")
//        return result
//    }
//}
//
//// API 응답용 모델들
//struct HomeGroupResponse: Decodable {
//    let month: Int
//    let day: Int
//    let roomInformationDtos: [HomeGroupModel]
//}
//
//struct HomeGroupModel: Decodable {
//    let roomName: String
//    let habit: String?
//    let period: String
//    let dayCountByWeek: Int
//    let percent: Int
//    let memberCount: Int
//    let roomId: Int
//}
//
//class HomeGroupService {
//    static let shared = HomeGroupService()
//    private init() {}
//    
//    func getHomeGroups(token: String) async throws -> HomeGroupResponse {
//        guard let url = URL(string: APIConstants.baseURL + "/user/home") else {
//            throw URLError(.badURL)
//        }
//        
//        return try await NetworkService.shared.get(url: url, accessToken: token)
//    }
//}
//
//
//
