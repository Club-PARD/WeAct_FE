import SwiftUI

struct MainView: View {
    @StateObject private var groupStore = GroupStore()
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var homeGroups: [HomeGroupModel] = []
    @State private var navigationPath = NavigationPath()
    @State private var TodayDate = Date()
    
    // 무한 호출 방지를 위한 플래그
    @State private var isLoading = false
    
    // 각 그룹별 오늘 인증 가능 여부를 저장하는 딕셔너리
    @State private var canCertifyToday: [Int: Bool] = [:]
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Color(hex: "F7F7F7")
                    .edgesIgnoringSafeArea(.all)
                
                VStack(alignment: .leading) {
                    
                    HStack {
                        Image("logo")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 30)
                        Spacer()
                        Button {
                            navigationPath.append(NavigationDestination.notification)
                        } label: {
                            Image(systemName: "bell.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color(hex: "9FADBC"))
                        }
                        .padding(.trailing, 7)
                        
                        Button {
                            navigationPath.append(NavigationDestination.myPage)
                        } label: {
                            Image(systemName: "person.fill")
                                .font(.system(size: 20))
                                .foregroundColor(Color(hex: "9FADBC"))
                        }
                    } // HStack
                    .padding(.top, 22)
                    
                    ZStack(alignment: .leading) {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("\(Calendar.current.component(.month, from: TodayDate))")
                                    .font(.custom("Pretendard-SemiBold", size: 26))
                                    .foregroundColor(Color(hex: "FF4B2F"))
                                
                                Text("월")
                                    .font(.custom("Pretendard-SemiBold", size: 26))
                                    .foregroundColor(Color(hex: "171717"))
                                
                                Text("\(Calendar.current.component(.day, from: TodayDate))")
                                    .font(.custom("Pretendard-SemiBold", size: 26))
                                    .foregroundColor(Color(hex: "FF4B2F"))
                                
                                Text("일")
                                    .font(.custom("Pretendard-SemiBold", size: 26))
                                    .foregroundColor(Color(hex: "171717"))
                            } // HStack
                            
                            Text("습관 인증 해볼까요?")
                                .foregroundColor(Color(hex: "171717"))
                                .font(.custom("Pretendard-SemiBold", size: 26))
                        } // VStack
                        
                        HStack {
                            Spacer()
                            Image("IllustHome")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 92)
                        } // HStack
                        
                    } // HStack
                    .padding(.top, 25)
                    
                    // 그룹 없을 때
                    if homeGroups.isEmpty {
                        HStack {
                            Spacer()
                            VStack {
                                Image("NoGroup")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .padding(.bottom, 32)
                                    .padding(.top, UIScreen.main.bounds.height * 0.106)
                                
                                Text("생성된 습관 그룹이 없어요\n 그룹을 추가해 주세요")
                                    .foregroundColor(Color(hex: "C6C6C6"))
                                    .font(.custom("Pretendard-Medium", size: 20))
                                    .multilineTextAlignment(.center)
                            } // VStack
                            Spacer()
                        } // HStack
                    }
                    // 그룹 있을 때
                    else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(groupStore.groups) { group in
                                    GroupList(
                                        navigationPath: $navigationPath,
                                        homeGroup: convertToHomeGroupModel(from: group),
                                        group: group,
                                        canCertifyToday: canCertifyToday[group.id] ?? false,
                                        onTap: {
                                            navigationPath.append(NavigationDestination.groupBoard(group))
                                        }
                                    )
                                }
                            }
                        }
                    }
                    
                    Spacer()
                    
                    // 그룹 만들기 버튼
                    HStack {
                        Spacer()
                        Button {
                            navigationPath.append(NavigationDestination.createGroup)
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                                Text("그룹 만들기")
                                    .foregroundColor(.white)
                                    .font(.custom("Pretendard-Medium", size: 16))
                            } // HStack
                            .padding(.vertical, 11)
                            .padding(.horizontal, 18)
                            .background(Color(hex: "464646"))
                            .cornerRadius(30)
                        } // Button
                        .padding(.bottom, 42)
                    } // HStack
                    .padding(.horizontal, 4)
                    
                }
                .padding(.horizontal, 20)
                .navigationDestination(for: NavigationDestination.self) { destination in
                    switch destination {
                    case .createGroup:
                        CreateGroup(groupStore: groupStore, navigationPath: $navigationPath)
                            .environmentObject(userViewModel)
                    case .addPartner:
                        AddPartner(groupStore: groupStore, navigationPath: $navigationPath)
                            .environmentObject(userViewModel)
                    case .groupBoard(let group):
                        GroupDetailBoard(navigationPath: $navigationPath, groupResponse: nil, group: group, groupStore: groupStore)
                    case .notification:
                        NotificationView(navigationPath: $navigationPath)
                    case .myPage:
                        MypageView(navigationPath: $navigationPath)
                            .environmentObject(userViewModel)
                    case .nameEdit:
                        NameEditView(navigationPath: $navigationPath)
                            .environmentObject(userViewModel)
                    case .certification:
                        CertificationView()
                    case .setuphabit:
                        SetUpHabbit(navigationPath: $navigationPath)
                    }
                }
            } // ZStack
            .onAppear {
                guard !isLoading else { return }
                if let userId = userViewModel.user.userId {
                    print("✅ [onAppear] 유저 ID 확인됨: \(userId)")
                    isLoading = true
                    fetchHomeGroups()
                }
            }
            .onChange(of: userViewModel.user.userId) { newUserId in
                guard !isLoading else { return }
                if let id = newUserId {
                    print("🔄 [onChange] 유저 ID 감지됨: \(id) → 그룹 새로 요청")
                    isLoading = true
                    fetchHomeGroups()
                }
            }
            // 기존 navigationPath onChange 제거하고 다른 방법으로 처리
            .refreshable {
                // Pull to refresh 기능 추가
                if !isLoading {
                    fetchHomeGroups()
                }
            }
        } // NavigationStack
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Helpers
    
    private func convertToHomeGroupModel(from group: GroupModel) -> HomeGroupModel {
        // GroupModel → HomeGroupModel 변환 (필요한 경우)
        return HomeGroupModel(
            roomId: 1,
            roomName: group.name,
            period: datePeriodString(from: group.startDate, to: group.endDate),
            dayCountByWeek: group.selectedDaysCount,
            percent: 0 // 아직 달성률이 없으면 0으로 처리
        )
    }
    
    private func datePeriodString(from startDate: Date, to endDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return "\(formatter.string(from: startDate)) ~ \(formatter.string(from: endDate))"
    }
    
    // MARK: - 데이터 요청
    private func fetchHomeGroups() {
        Task {
            do {
                guard let token = TokenManager.shared.getToken() else { return }
                let response = try await HomeGroupService.shared.getHomeGroups(token: token)
                
                await MainActor.run {
                    if let date = Calendar.current.date(from: DateComponents(month: response.month, day: response.day)) {
                        self.TodayDate = date
                    }
                    
                    self.homeGroups = response.roomInformationDtos
                    
                    self.groupStore.groups = response.roomInformationDtos.map { homeGroup in
                        GroupModel(
                            id: homeGroup.roomId ?? Int.random(in: 0...9999),
                            name: homeGroup.roomName,
                            startDate: parseDate(from: homeGroup.period) ?? Date(),
                            endDate: parseEndDate(from: homeGroup.period) ?? Date(),
                            reward: "보상 미정",
                            partners: [],
                            selectedDaysString: "",
                            selectedDaysCount: homeGroup.dayCountByWeek,
                        )
                    }
                    print("✅ [UI 업데이트 완료] 표시할 그룹 수: \(self.groupStore.groups.count)")
                    isLoading = false // 호출 종료 후 반드시 false로 해제
                }
            } catch {
                print("❌ 홈 그룹 조회 실패:", error.localizedDescription)
                await MainActor.run {
                    isLoading = false
                }
            }
        }
    }
}

// MARK: - 날짜 파싱 헬퍼 함수들
private func parseDate(from period: String) -> Date? {
    let components = period.components(separatedBy: " ~ ")
    guard let startString = components.first else { return nil }
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd"
    return formatter.date(from: startString)
}

private func parseEndDate(from period: String) -> Date? {
    let components = period.components(separatedBy: " ~ ")
    guard components.count > 1 else { return nil }
    
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy.MM.dd"
    return formatter.date(from: components[1])
}



#Preview {
    let testUserModel = UserViewModel()
    MainView()
        .environmentObject(testUserModel)
}
