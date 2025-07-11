//
//  HabitPostViewModel.swift
//  WeAct
//
//  Created by 주현아 on 7/11/25.
//

import Foundation

@MainActor
class HabitBoardViewModel: ObservableObject {
    @Published var posts: [HabitBoardResponse] = []
    @Published var selectedPostDetail: HabitPostDetailResponse? = nil  // ✅ 올바른 위치
    
    private let boardService = HabitBoardService.shared
    
    func loadPosts(roomId: Int, date: Date) async {
        guard let token = TokenManager.shared.getToken() else { return }
   
        do {
            let result = try await HabitBoardService.shared.fetchHabitPosts(roomId: roomId, date: date, token: token)
            posts = result
            print("✅ 인증 포스트 로드 완료: \(result.count)개")
        } catch {
            print("❌ 인증 포스트 로드 실패: \(error)")
        }
    }
    
    func loadPostDetail(postId: Int) async {
        guard let token = TokenManager.shared.getToken() else { return }
        do {
           let detail = try await boardService.fetchPostDetail(postId: postId, token: token)
           selectedPostDetail = detail
       } catch {
           print("❌ Post Detail Fetch Error: \(error)")
       }
   }
    
}
