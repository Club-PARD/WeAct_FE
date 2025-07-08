//
//  CheckPointMember.swift
//  WeAct
//
//  Created by 최승아 on 7/8/25.
//

import SwiftUI

struct CheckPointResponse: Codable, Identifiable {
    let id = UUID()
    let firstRanker: [CheckPointMember]
    let secondRanker: [CheckPointMember]
    let restMembers: [CheckPointMember]?
}

struct CheckPointMember: Codable {
    let userName: String
    let profileImage: String?
}

class CheckPointService {
    static let shared = CheckPointService()
    
    private init() {}
    
    func fetchCheckPointIfNeeded(for group: HomeGroupModel) async throws -> CheckPointResponse? {
        print("🔍 [중간점검] checkPointIfNeeded 호출됨")
        print("📊 [중간점검] roomId: \(group.roomId), 현재 진행률: \(group.percent)%")
        
        guard group.isCheckPointTime else {
            print("⏰ [중간점검] 아직 시점 아님 (50% 미만 또는 60% 이상)")
            return nil
        }
        
        return try await fetchCheckPoint(roomId: group.roomId)
    }
    
    func fetchCheckPoint(roomId: Int) async throws -> CheckPointResponse {
        print("🔍 [중간점검] fetchCheckPoint 호출됨")
        print("📡 [중간점검] roomId: \(roomId)")
        
//        guard let url = URL(string: "https://naruto.asia/room/checkPoint/\(roomId)") else {
//            print("❌ [중간점검] URL 생성 실패")
//            throw URLError(.badURL)
//        }
        guard let url = URL(string: "http://172.18.130.119:8080/room/checkPoint/\(roomId)") else {
                    print("❌ [중간점검] URL 생성 실패")
                    throw URLError(.badURL)
                }
        
        
        print("📡 [중간점검] API URL: \(url.absoluteString)")
        print("🚀 [중간점검] API 요청 시작...")
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            // HTTP 응답 확인
            if let httpResponse = response as? HTTPURLResponse {
                print("📊 [중간점검] 응답 상태 코드: \(httpResponse.statusCode)")
                print("📋 [중간점검] 응답 헤더: \(httpResponse.allHeaderFields)")
            }
            
            // 원시 데이터 확인
            print("📦 [중간점검] 원시 응답 데이터 크기: \(data.count) bytes")
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📝 [중간점검] 원시 응답 내용: '\(jsonString)'")
            } else {
                print("⚠️ [중간점검] 응답 데이터를 문자열로 변환 실패")
            }
            
            // JSON 파싱 시도
            print("🔧 [중간점검] JSON 파싱 시작...")
            let checkPoint = try JSONDecoder().decode(CheckPointResponse.self, from: data)
            
            print("✅ [중간점검] JSON 파싱 성공!")
            print("🥇 [중간점검] 1등 수: \(checkPoint.firstRanker.count)")
            print("🥈 [중간점검] 2등 수: \(checkPoint.secondRanker.count)")
            print("👥 [중간점검] 나머지 수: \(checkPoint.restMembers?.count ?? 0)")
            
            // 각 순위별 상세 정보
            if !checkPoint.firstRanker.isEmpty {
                print("🥇 [중간점검] 1등 명단:")
                for (index, member) in checkPoint.firstRanker.enumerated() {
                    print("   \(index + 1). \(member.userName)")
                }
            }
            
            if !checkPoint.secondRanker.isEmpty {
                print("🥈 [중간점검] 2등 명단:")
                for (index, member) in checkPoint.secondRanker.enumerated() {
                    print("   \(index + 1). \(member.userName)")
                }
            }
            
            return checkPoint
            
        } catch let decodingError as DecodingError {
            print("❌ [중간점검] JSON 파싱 오류: \(decodingError)")
            print("❌ [중간점검] 파싱 에러 상세: \(decodingError.localizedDescription)")
            throw decodingError
        } catch let urlError as URLError {
            print("❌ [중간점검] 네트워크 오류: \(urlError)")
            print("❌ [중간점검] 네트워크 에러 상세: \(urlError.localizedDescription)")
            throw urlError
        } catch {
            print("❌ [중간점검] 알 수 없는 오류: \(error)")
            print("❌ [중간점검] 오류 상세: \(error.localizedDescription)")
            throw error
        }
    }
}
