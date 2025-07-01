//
//  MainView.swift
//  WeAct
//
//  Created by 최승아 on 6/30/25.
//

import SwiftUI

struct MainView: View {
    @State private var navigationPath = NavigationPath()
    @State private var TodayDate = Date()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack(alignment: .leading) {
                HStack {
                    // 로고
                    Text("로고")
                    Spacer()

                    // 알림 버튼
                    Button {
                        // 알림 기능 구현 예정
                    } label: {
                        Image(systemName: "bell.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                            .foregroundColor(Color(hex: "9FADBC"))
                    }
                    .padding(.trailing, 7)

                    // 프로필 버튼
                    Button {
                        // 프로필 기능 구현 예정
                    } label: {
                        Image(systemName: "person.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                            .foregroundColor(Color(hex: "9FADBC"))
                    }
                }
                .padding(.bottom, 33)

                // 오늘 날짜
                Text(TodayDate.formatted(.dateTime.month(.wide).day().locale(Locale(identifier: "ko_KR"))))
                    .font(.system(size: 26, weight: .medium))
                    .foregroundColor(Color(hex: "5F656E"))

                // 안내 문구
                Text("습관 인증을 해볼까요")
                    .foregroundColor(Color(hex: "8691A2"))
                    .font(.system(size: 26, weight: .medium))

                Spacer()

                // 빈 상태 안내
                HStack {
                    Spacer()
                    Image("")
                    Text("습관 방이 텅 비어있어요\n         추가해주세요")
                        .foregroundColor(Color(hex: "9FADBC"))
                        .font(.system(size: 20, weight: .medium))
                    Spacer()
                }

                Spacer()

                // 추가 버튼
                HStack {
                    Spacer()
                    Button {
                        navigationPath.append(NavigationDestination.createGroup)
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 74)
                            .foregroundColor(Color(hex: "9FADBC"))
                    }
                    .padding(.bottom, 58)
                }
                .padding(.horizontal, 24)
            }
            .padding(.horizontal, 18)
            .navigationBarBackButtonHidden(true) // 🔥 여기서 뒤로가기 버튼 제거
            .navigationDestination(for: NavigationDestination.self) { destination in
                switch destination {
                case .createGroup:
                    CreateGroup(navigationPath: $navigationPath)
                case .addPartner:
                    AddPartner(navigationPath: $navigationPath)
                }
            }
        }
    }
}
