//
//  UserSearchViewModel.swift
//  WeAct
//
//  Created by 주현아 on 7/5/25.
//
// MARK: searchUser(서버통신)한 내용을 view에 띄울 때 사용하는 코드

import Foundation

class UserSearchViewModel: ObservableObject {
    @Published var searchedUsers: [UserSearchResponse] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    // 서버에 검색 요청을 보내고 응답 결과를 저장
    func searchUsers(containing keyword: String) async {
        guard !keyword.trimmingCharacters(in: .whitespaces).isEmpty else {
            DispatchQueue.main.async {
                self.searchedUsers = []
            }
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let result = try await UserSearchService.shared.searchUsers(containing: keyword)
            DispatchQueue.main.async {
                self.searchedUsers = result
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "검색 실패: \(error.localizedDescription)"
                self.isLoading = false
            }
        }
    }
}
