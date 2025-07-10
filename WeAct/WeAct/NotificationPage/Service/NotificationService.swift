//
//  NotificationService.swift
//  WeAct
//
//  Created by 주현아 on 7/10/25.
//
import Foundation

class NotificationService {
    private let networkService = NetworkService.shared

    func fetchNotifications(token: String) async throws -> [NotificationModel] {
        guard let url = URL(string: APIConstants.baseURL + APIConstants.InAppNotification.getNotification) else {
            throw URLError(.badURL)
        }

        print("🌐 [알림 조회 요청] \(url.absoluteString)")

        do {
            let notifications: [NotificationModel] = try await networkService.get(url: url, accessToken: token)
            print("✅ 알림 조회 성공: \(notifications.count)개 수신")
            return notifications
        } catch let error as NSError {
            print("❌ 알림 조회 실패: \(error.localizedDescription)")
            throw error
        }
    }
    
    // 초대 수락/거절 메서드 수정 (응답 없는 API)
       func respondToInvite(token: String, roomId: Int, accept: Bool) async throws -> Bool {
           // API 문서에 따라 /invite 엔드포인트 사용
           guard let url = URL(string: APIConstants.baseURL + "/invite") else {
               throw URLError(.badURL)
           }
           
           let requestModel = InviteRequestModel(roomId: roomId, state: accept ? 1 : -1)
           
           print("🌐 [초대 응답 요청] \(url.absoluteString)")
           print("📤 요청 데이터: roomId=\(roomId), state=\(accept ? "수락(1)" : "거절(-1)")")
           
           do {
               // 응답이 없는 POST 요청 - Boolean 반환 메서드 사용
               let success = try await networkService.postWithBodyNoResponse(url: url, body: requestModel, accessToken: token)
               print("✅ 초대 응답 성공: \(accept ? "수락" : "거절")")
               return success
           } catch let error as NSError {
               print("❌ 초대 응답 실패: \(error.localizedDescription)")
               print("❌ 에러 코드: \(error.code)")
               
               // 403 오류 상세 분석
               if error.code == 403 {
                   print("🔍 403 오류 원인 분석:")
                   print("   - 토큰 만료되었거나 유효하지 않음")
                   print("   - 해당 방에 대한 초대 권한 없음")
                   print("   - 이미 처리된 초대일 가능성")
                   print("   - userId가 초대장의 대상자와 일치하지 않음")
               }
               
               throw error
           }
       }
}
