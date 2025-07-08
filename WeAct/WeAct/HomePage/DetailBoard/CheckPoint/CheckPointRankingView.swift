//
//  CheckPointRankingView.swift
//  WeAct
//
//  Created by 최승아 on 7/8/25.
//
//
//  CheckPointRankingView.swift
//  WeAct
//
//  Created by 최승아 on 7/8/25.
//

import SwiftUI

struct CheckPointRankingView: View {
    @State private var checkPoint: CheckPointResponse?
    @State private var isLoading = true
    let roomId: Int?
    let mockData: CheckPointResponse?
    
    var body: some View {
        Group {
            if isLoading && mockData == nil {
                ProgressView("랭킹 불러오는 중...")
            } else if let checkPoint = checkPoint ?? mockData {
                VStack(alignment: .leading) {
                    Text("중간 랭킹 공개")
                        .font(.custom("Pretendard-Medium", size: 16))
                        .foregroundColor(Color(hex: "858588"))
                  
                    // 랭킹 멤버 중에 내가 있으면 '나'라는 버튼으로 이름 옆에 포시
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            
                            // 1등
                            if !checkPoint.firstRanker.isEmpty {
                                RankingCard(
                                    members: checkPoint.firstRanker,
                                    rank: 1,
                                    medalImage: "gold",
                                )
                            }
                            
                            // 2등
                            if !checkPoint.secondRanker.isEmpty {
                                RankingCard(
                                    members: checkPoint.secondRanker,
                                    rank: 2,
                                    medalImage: "silver",
                                )
                            }
                        } // HStack
                        .padding(.vertical, 6)
                    }
                }
            } else {
                Text("랭킹 정보를 불러올 수 없습니다")
            }
        }
        .task {
            if mockData == nil, let roomId = roomId {
                await loadCheckPoint(roomId: roomId)
            }
        }
    }
    
    // 실제 API 호출용 이니셜라이저
    init(roomId: Int) {
        self.roomId = roomId
        self.mockData = nil
    }
    
    // 기존 방식 (데이터 직접 전달)
    init(checkPoint: CheckPointResponse) {
        self.roomId = nil
        self.mockData = checkPoint
        self._isLoading = State(initialValue: false)
    }
    
    // Preview용 Mock 데이터 이니셜라이저
    init(mockData: CheckPointResponse) {
        self.roomId = nil
        self.mockData = mockData
        self._isLoading = State(initialValue: false)
    }
    
    private func loadCheckPoint(roomId: Int) async {
        do {
            print("🔍 [뷰] CheckPointRankingView에서 API 호출 시작")
            let result = try await CheckPointService.shared.fetchCheckPoint(roomId: roomId)
            await MainActor.run {
                self.checkPoint = result
                self.isLoading = false
            }
            print("✅ [뷰] CheckPointRankingView API 호출 완료")
        } catch {
            print("❌ [뷰] CheckPointRankingView API 호출 실패: \(error)")
            await MainActor.run {
                self.isLoading = false
            }
        }
    }
}

struct RankingCard: View {
    let members: [CheckPointMember]
    let rank: Int
    let medalImage: String
    
    var body: some View {
        HStack(spacing: 18) {
                    ForEach(members, id: \.userName) { member in
                        VStack(spacing: 7) {
                            ZStack {
                                Image("myprofile")
                                    .resizable()
                                    .frame(width: 54, height: 54)
                                    .cornerRadius(15)

                                Image(medalImage)
                                   .resizable()
                                    .frame(width: 26, height: 26)
                                    .offset(x: 0, y: -22)
                            }

                            Text(member.userName)
                                .font(.custom("Pretendard-Medium", size: 14))
                                .foregroundColor(Color(hex: "464646"))
                        }
                    }
                }
    }
}

#Preview {
//    CheckPointRankingView(checkPoint: CheckPointResponse(
//        firstRanker: [
//            CheckPointMember(userName: "이주원", profileImage: nil),
//            CheckPointMember(userName: "주현아", profileImage: nil)
//        ],
//        secondRanker: [
//            CheckPointMember(userName: "이단진", profileImage: nil)
//        ],
//        restMembers: [
//            CheckPointMember(userName: "김종언", profileImage: nil)
//        ]
//    ))
    CheckPointRankingView(roomId: 1)
}
