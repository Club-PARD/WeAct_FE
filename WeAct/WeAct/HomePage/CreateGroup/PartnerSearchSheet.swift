//
//  PartnerSearchSheet.swift
//  WeAct
//
//  Created by 최승아 on 6/30/25.
//
// MARK: searchUser를 통해 유저 정보 가져오도록 업데이트됨

import SwiftUI

struct PartnerSearchSheet: View {
    @Binding var selectedPartners: Set<PartnerModel>
    @StateObject private var viewModel = UserSearchViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 검색 바
                searchBar
                
                // 사용자 목록
                userList
            }
            .navigationTitle("친구 검색")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: doneButton
            )
            .onChange(of: searchText) { newValue in
               Task {
                   await viewModel.searchUsers(containing: newValue) // ✅ 4. 검색어 변경 시 서버 호출
               }
           }
        }
    }
    
    // MARK: - View Components
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(Color(hex: "8691A2"))
            
            TextField("친구를 검색해보세요", text: $searchText)
                .font(.system(size: 16))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(hex: "F8F9FA"))
        .cornerRadius(8)
        .padding()
    }
    
    private var userList: some View {
        List {
            if viewModel.isLoading {
                ProgressView()
            } else if let error = viewModel.errorMessage {
                Text(error).foregroundColor(.red)
            } else {
                ForEach(viewModel.searchedUsers) { user in // ✅ 3. 서버 응답 사용
                    let partner = PartnerModel(id: user.id, name: user.userId, profileImageName: nil)
                    userRow(partner)
                }
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func userRow(_ user: PartnerModel) -> some View {
        HStack {
            // 프로필 이미지
            Circle()
                .fill(Color(hex: "40444B"))
                .frame(width: 40, height: 40)
                .overlay(
                    Image(systemName: "person")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(.white)
                )
            
            // 사용자 정보
            VStack(alignment: .leading, spacing: 2) {
                Text(user.name)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(Color(hex: "40444B"))
                
                Text("@\(user.name.lowercased())")
                    .font(.system(size: 14))
                    .foregroundColor(Color(hex: "8691A2"))
            }
            
            Spacer()
            
            // 선택 버튼
            Button(action: {
                toggleSelection(for: user)
            }) {
                let isSelected = selectedPartners.contains(where: { $0.id == user.id })
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(isSelected ? Color(hex: "FF4B2F") : Color(hex: "F7F7F7"))
                    .font(.system(size: 20))
            }
        }
        .padding(.vertical, 4)
    }

    private var doneButton: some View {
        Button("추가") {
            dismiss()
        }
        .font(.custom("Pretendard-Medium", size: 18))
        .disabled(selectedPartners.isEmpty)
        .foregroundColor(Color(hex: "FF4B2F"))
    }
    
    // MARK: - Actions
    
    private func toggleSelection(for user: PartnerModel) {
        if let existingUser = selectedPartners.first(where: { $0.id == user.id }) {
            selectedPartners.remove(existingUser)
        } else {
            selectedPartners.insert(user)
        }
    }
}
