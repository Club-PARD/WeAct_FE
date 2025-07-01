//
//  FinalResultPage.swift
//  WeAct
//
//  Created by 현승훈 on 7/1/25.
//
import SwiftUI

struct FinalResultPage_Rank4: View {
    @Environment(\.presentationMode) var presentationMode

    struct UserResult: Identifiable {
        let id = UUID()
        let rank: Int
        let name: String
        let mission: String
        let achievement: String
        let isSelf: Bool
    }

    let resultList: [UserResult] = [
        UserResult(rank: 1, name: "최승아", mission: "독서 10분", achievement: "100%", isSelf: false),
        UserResult(rank: 2, name: "이단진", mission: "자기 전 일기 쓰기", achievement: "90%", isSelf: false),
        UserResult(rank: 3, name: "이단진", mission: "자기 전 일기 쓰기", achievement: "90%", isSelf: false),
        UserResult(rank: 4, name: "이주원", mission: "독서 10분", achievement: "90%", isSelf: true),
        UserResult(rank: 5, name: "이단진", mission: "자기 전 일기 쓰기", achievement: "90%", isSelf: false),
        UserResult(rank: 6, name: "이단진", mission: "자기 전 일기 쓰기", achievement: "90%", isSelf: false)
    ]

    var body: some View {
        VStack(spacing: 20) {
            // Top Bar
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 4) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                        Text("뒤로")
                            .foregroundColor(.black)
                            .font(.body)
                    }
                }
                Spacer()
                Text("최종 결과")
                    .font(.headline)
                Spacer()
                Image(systemName: "line.3.horizontal")
                    .foregroundColor(.black)
            }
            .padding(.horizontal)
            .padding(.top, 20)

            // Mission Info
            VStack(alignment: .leading, spacing: 8) {
                Text("롱커톤 모여라")
                    .font(.headline)
                Text("2025.6.3 - 6.9")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                HStack(spacing: 10) {
                    Text("주기")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(4)
                        .background(Color(.systemGray6))
                        .cornerRadius(6)
                    Text("월,화,수,목,금")
                        .font(.caption)
                    Text("보상")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(4)
                        .background(Color(.systemGray6))
                        .cornerRadius(6)
                    Text("일일 노예 시키기")
                        .font(.caption)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)

            // Final Ranking
            VStack(alignment: .leading) {
                Text("최종 랭킹")
                    .font(.headline)
                    .padding(.horizontal)

                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(resultList) { user in
                            HStack {
                                // Rank
                                if user.rank <= 3 {
                                    Image("rank\(user.rank)")
                                        .resizable()
                                        .frame(width: 35, height: 47)
                                } else {
                                    Text("\(user.rank)")
                                        .font(.headline)
                                        .frame(width: 24)
                                }

                                // User info
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack(spacing: 4) {
                                        Text(user.name)
                                            .font(.subheadline)
                                        if user.isSelf {
                                            Text("나")
                                                .font(.caption)
                                                .padding(4)
                                                .background(Color(.systemGray5))
                                                .cornerRadius(5)
                                        }
                                    }
                                    Text(user.mission)
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }

                                Spacer()

                                // Achievement
                                Text("달성률 \(user.achievement)")
                                    .font(.caption)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 10)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 10)
                        }
                    }
                    .padding(.horizontal)
                }
            }

            Spacer()
        }
        .navigationBarBackButtonHidden(true)
    }
}
