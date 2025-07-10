import SwiftUI

struct MainView: View {
    @StateObject private var groupStore = GroupStore()
    @EnvironmentObject var userViewModel: UserViewModel
    @State private var homeGroups: [HomeGroupModel] = []
    @State private var navigationPath = NavigationPath()
    @State private var TodayDate = Date()
    
    // 더 구체적인 로딩 상태 관리
    @State private var isInitialLoading = true
    @State private var isRefreshing = false
    
    // 각 그룹별 오늘 인증 가능 여부를 저장하는 딕셔너리
    @State private var canCertifyToday: [Int: Bool] = [:]
    
    // 마지막 로드 시간 추적으로 중복 요청 방지
    @State private var lastLoadTime: Date = Date.distantPast
    
    // 화면 복귀 감지를 위한 상태
    @State private var isViewActive = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                Color(hex: "F7F7F7")
                    .edgesIgnoringSafeArea(.all)
                
                if isInitialLoading {
                    // 로딩 인디케이터
                    VStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                        Text("로딩 중...")
                            .font(.custom("Pretendard-Medium", size: 16))
                            .foregroundColor(Color(hex: "171717"))
                            .padding(.top, 16)
                    }
                } else {
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
                            
                        } // ZStack
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
                }
                
            } // ZStack
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
                case .setuphabit(let roomId):
                    SetUpHabbit(navigationPath: $navigationPath, roomId: roomId)
                        .environmentObject(userViewModel)
                }
            }
            .onAppear {
                print("🔄 [MainView] onAppear - isViewActive: \(isViewActive)")
                
                // 초기 로딩 시에만 데이터 로드
                if isInitialLoading {
                    loadDataIfNeeded()
                } else if isViewActive {
                    // 🔥 화면 복귀 시 데이터 새로고침
                    print("🔄 [MainView] 화면 복귀 감지 → 데이터 리로드")
                    loadDataIfNeeded(force: true)
                }
                
                isViewActive = true
            }
            .onDisappear {
                print("📤 [MainView] onDisappear")
                isViewActive = false
            }
            .onChange(of: userViewModel.user.userId) { _, newUserId in
                // 사용자 ID 변경 시에만 데이터 리로드
                if newUserId != nil {
                    print("🔄 [onChange] 유저 ID 변경 감지 → 데이터 리로드")
                    loadDataIfNeeded(force: true)
                }
            }
            // 🔥 추가: navigationPath 변경 감지
            .onChange(of: navigationPath) { oldPath, newPath in
                print("🔄 [navigationPath] 변경 감지 - count: \(newPath.count)")
                
                // 다른 화면에서 메인 화면으로 돌아왔을 때 (navigationPath가 비어졌을 때)
                if oldPath.count > 0 && newPath.count == 0 {
                    print("🔄 [navigationPath] 메인 화면으로 복귀 → 데이터 리로드")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        loadDataIfNeeded(force: true)
                    }
                }
            }
            .refreshable {
                // Pull to refresh 기능
                if !isRefreshing {
                    await refreshData()
                }
            }
        } // NavigationStack
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Helpers
    
    private func convertToHomeGroupModel(from group: GroupModel) -> HomeGroupModel {
        return HomeGroupModel(
            roomName: group.name,
            habit: nil, // 또는 적절한 기본값
            period: datePeriodString(from: group.startDate, to: group.endDate),
            dayCountByWeek: group.selectedDaysCount,
            percent: 0,
            memberCount: 0,
            roomId: group.id
        )
    }
    
    private func datePeriodString(from startDate: Date, to endDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return "\(formatter.string(from: startDate)) ~ \(formatter.string(from: endDate))"
    }
    
    // MARK: - 데이터 로딩 메서드들
    
    private func loadDataIfNeeded(force: Bool = false) {
        // 중복 요청 방지: 마지막 로드 후 1초 이내면 스킵
        let timeSinceLastLoad = Date().timeIntervalSince(lastLoadTime)
        if !force && timeSinceLastLoad < 1.0 {
            print("⏱️ 중복 요청 방지: 마지막 로드 후 \(timeSinceLastLoad)초")
            return
        }
        
        guard let userId = userViewModel.user.userId else {
            print("❌ 사용자 ID가 없음")
            return
        }
        
        print("✅ 데이터 로딩 시작 - 사용자 ID: \(userId)")
        lastLoadTime = Date()
        
        Task {
            await fetchHomeGroups()
        }
    }
    
    private func refreshData() async {
        isRefreshing = true
        await fetchHomeGroups()
        isRefreshing = false
    }
    
    private func fetchHomeGroups() async {
        do {
            guard let token = TokenManager.shared.getToken() else {
                print("❌ 토큰이 없음")
                await MainActor.run {
                    self.isInitialLoading = false
                }
                return
            }
            
            let response = try await HomeGroupService.shared.getHomeGroups(token: token)
            
            await MainActor.run {
                // 날짜 업데이트
                if let date = Calendar.current.date(from: DateComponents(month: response.month, day: response.day)) {
                    self.TodayDate = date
                }
                
                // 홈 그룹 업데이트
                self.homeGroups = response.roomInformationDtos
                
                // 그룹 스토어 업데이트
                self.groupStore.groups = response.roomInformationDtos.map { homeGroup in
                    GroupModel(
                        id: homeGroup.roomId,
                        name: homeGroup.roomName,
                        startDate: parseDate(from: homeGroup.period) ?? Date(),
                        endDate: parseEndDate(from: homeGroup.period) ?? Date(),
                        reward: "보상 미정",
                        partners: [],
                        selectedDaysString: "",
                        selectedDaysCount: homeGroup.dayCountByWeek
                    )
                }
                
                print("✅ 데이터 로딩 완료 - 그룹 수: \(self.groupStore.groups.count)")
                self.isInitialLoading = false
            }
        } catch {
            print("❌ 홈 그룹 조회 실패: \(error.localizedDescription)")
            await MainActor.run {
                self.isInitialLoading = false
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
