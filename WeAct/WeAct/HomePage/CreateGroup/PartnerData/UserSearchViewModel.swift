//
//  UserSearchViewModel.swift
//  WeAct
//
//  Created by 주현아 on 7/5/25.
//
// MARK: searchUser(서버통신)한 내용을 view에 띄울 때 사용하는 코드

import Foundation

@MainActor
class UserSearchViewModel: ObservableObject {
    @Published var searchedUsers: [UserSearchResponse] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    // 서버에 검색 요청을 보내고 응답 결과를 저장
    func searchUsers(containing keyword: String) async {
        guard !keyword.trimmingCharacters(in: .whitespaces).isEmpty else {
            searchedUsers = []
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let result = try await UserSearchService.shared.searchUsers(containing: keyword)
            searchedUsers = result
            isLoading = false
        } catch {
            errorMessage = "검색 실패: \(error.localizedDescription)"
            isLoading = false
        }
    }
}
