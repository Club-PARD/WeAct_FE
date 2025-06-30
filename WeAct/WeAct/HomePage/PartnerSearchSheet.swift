//
//  PartnerSearchSheet.swift
//  WeAct
//
//  Created by 최승아 on 6/30/25.
//

import SwiftUI

struct PartnerSearchSheet: View {
    @Binding var selectedPartners: Set<String>
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    
    // 샘플 사용자 데이터
    let sampleUsers = [
        "김철수", "이영희", "박민수", "정수진", "최지훈",
        "한예린", "송태현", "임다은", "오준호", "윤서연"
    ]
    
    var filteredUsers: [String] {
        if searchText.isEmpty {
            return sampleUsers
        } else {
            return sampleUsers.filter { $0.contains(searchText) }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // 검색 바
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Color(hex: "8691A2"))
                    
                    TextField("아이디 검색", text: $searchText)
                        .font(.system(size: 16))
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(hex: "F8F9FA"))
                .cornerRadius(8)
                .padding()
                
                // 사용자 목록
                List {
                    ForEach(filteredUsers, id: \.self) { user in
                        HStack {
                            Circle()
                                .fill(Color(hex: "40444B"))
                                .frame(width: 40, height: 40)
                                .overlay(
                                    //Text(String(user.first ?? "U"))
                                    Image(systemName: "person")
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(.white)
                                )
                            
                            VStack(alignment: .leading, spacing: 2) {
                                Text(user)
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(Color(hex: "40444B"))
                                
                                Text("@\(user.lowercased())")
                                    .font(.system(size: 14))
                                    .foregroundColor(Color(hex: "8691A2"))
                            }
                            
                            Spacer()
                            
                            Button(action: {
                                if selectedPartners.contains(user) {
                                    selectedPartners.remove(user)
                                } else {
                                    selectedPartners.insert(user)
                                }
                            }) {
                                Image(systemName: selectedPartners.contains(user) ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(selectedPartners.contains(user) ? Color(hex: "40444B") : Color(hex: "8691A2"))
                                    .font(.system(size: 20))
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                .listStyle(PlainListStyle())
            }
            .navigationTitle("파트너 선택")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("취소") {
                    dismiss()
                },
                trailing: Button("완료") {
                    dismiss()
                }
                .disabled(selectedPartners.isEmpty)
                .foregroundColor(selectedPartners.isEmpty ? Color(hex: "8691A2") : Color(hex: "40444B"))
            )
        }
    }
}
