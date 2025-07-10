//
//  NotificationViewModel.swift
//  WeAct
//
//  Created by 주현아 on 7/10/25.
//

import SwiftUI
import Foundation


@MainActor
class NotificationViewModel: ObservableObject {
    @Published var notifications: [NotificationModel] = []
    private let service = NotificationService()
    
    func fetchNotifications() async {
        guard let token = TokenManager.shared.getToken() else {
            print("❌ 토큰 없음")
            return
        }
        
        do {
            print("📡 알림 요청 시작")
            let result = try await service.fetchNotifications(token: token)
            self.notifications = result
            print("✅ 알림 불러오기 완료: \(result.count)개")
        } catch {
            print("❌ 알림 불러오기 실패: \(error)")
        }
    }
    
    // 초대 수락 메서드 추가
        func acceptInvite(roomId: Int) async -> Bool {
            guard let token = TokenManager.shared.getToken() else {
                print("❌ 토큰 없음 - 초대 수락 불가")
                return false
            }
            
            do {
                print("📡 초대 수락 요청 시작")
                let success = try await service.respondToInvite(token: token, roomId: roomId, accept: true)
                print("✅ 초대 수락 완료")
                return success
            } catch {
                print("❌ 초대 수락 실패: \(error)")
                return false
            }
        }
    
    // 초대 거절 메서드 추가
        func rejectInvite(roomId: Int) async -> Bool {
            guard let token = TokenManager.shared.getToken() else {
                print("❌ 토큰 없음 - 초대 거절 불가")
                return false
            }
            
            do {
                print("📡 초대 거절 요청 시작")
                let success = try await service.respondToInvite(token: token, roomId: roomId, accept: false)
                print("✅ 초대 거절 완료")
                return success
            } catch {
                print("❌ 초대 거절 실패: \(error)")
                return false
            }
        }
    
    // 알림 제거 메서드 (UI에서만 제거)
       func removeNotification(roomId: Int) {
           notifications.removeAll { $0.roomId == roomId }
       }
}
