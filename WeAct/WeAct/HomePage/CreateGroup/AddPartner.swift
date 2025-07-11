//
//  AddPartner.swift
//  WeAct
//
//  Created by 최승아 on 6/30/25.
//

import SwiftUI

struct AddPartner: View {
    @ObservedObject var groupStore: GroupStore
    @EnvironmentObject var userViewModel: UserViewModel
    @Binding var navigationPath: NavigationPath
    @State private var selectedPartners: Set<PartnerModel> = []
    @State private var showingBottomSheet = false
    
    var isFormValid: Bool {
        return !selectedPartners.isEmpty
    }
    
    var customBackButton: some View {
        Button(action: {
            if !navigationPath.isEmpty {
                navigationPath.removeLast()
            }
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .frame(width: 12, height: 21)
            }
            .foregroundColor(.black)
        }
    }
    
    var body: some View {
        ZStack {
            Color(hex: "F7F7F7")
                .edgesIgnoringSafeArea(.all)
            VStack(alignment: .leading) {
                // 헤더
                headerView
                
                // 선택된 파트너 카운트
                selectedCountView
                
                // 파트너 선택 영역
                partnerSelectionView
                
                Spacer()
                
                // 방 생성 버튼
                createRoomButton
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 18)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: customBackButton)
            .navigationTitle("친구초대")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showingBottomSheet) {
                PartnerSearchSheet(selectedPartners: $selectedPartners)
                    .presentationDetents([.height(UIScreen.main.bounds.height * 0.576)])
                    .environmentObject(userViewModel)
            }
            
        }
    }
    
    // MARK: - View Components
    
    private var headerView: some View {
        Text("함께 할 친구를\n초대해 주세요")
            .foregroundColor(Color(hex: "171717"))
            .font(.system(size: 26, weight: .medium))
            .padding(.bottom, 14)
    }
    
    private var selectedCountView: some View {
        HStack {
            Text("\(selectedPartners.count)")
                .font(.custom("Pretendard-Medium", size: 16))
                .foregroundColor(Color(hex: "FF4B2F"))
            Text("명 선택되었어요")
                .font(.custom("Pretendard-Medium", size: 16))
                .foregroundColor(Color(hex: "858588"))
        }
        .padding(.bottom, 32)
    }
    
    private var partnerSelectionView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                addButton // 추가 버
                myProfileView // 내 프로필
                selectedPartnersView // 선택된 파트너들
            }
            .padding(.vertical, 8)
        }
    }
    
    private var addButton: some View {
        Button(action: {
            showingBottomSheet = true
        }) {
            VStack(spacing: 7) {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.white)
                    .padding(25)
                    .background(Color(hex: "FF4B2F"))
                    .cornerRadius(20)
                
                Text("추가")
                    .font(.custom("Pretendard-Medium", size: 14))
                    .foregroundColor(Color(hex: "FF4B2F"))
            }
        }
    }
    
    private var myProfileView: some View {
        VStack(spacing: 7) {
            AsyncImage(url: URL(string: userViewModel.user.profileImageURL ?? "")) { image in
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .cornerRadius(20)
            } placeholder: {
                Image("BasicProfile") // 기본 이미지
                    .resizable()
                    .scaledToFit()
                    .frame(height: 70)
            }
            
            if let userId = userViewModel.user.userId {
                Text(userId)
                    .font(.custom("Pretendard-Medium", size: 14))
                    .foregroundColor(Color(hex: "464646"))
            } else {
                Text("나")
                    .font(.custom("Pretendard-Medium", size: 14))
                    .foregroundColor(Color(hex: "464646"))
            }
        }
    }
    
    private var selectedPartnersView: some View {
        ForEach(Array(selectedPartners), id: \.self) { partner in 
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 7) {
                    // 프로필 이미지
                    if let imageName = partner.profileImageName {
                        Image(imageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 70, height: 70)
                            .cornerRadius(20)
                    } else {
                        Image("BasicProfile")
                            .resizable()
                            .scaledToFit()
                            .frame(height: 70)
                    }
                    
                    Text(partner.name)
                        .font(.custom("Pretendard-Medium", size: 14))
                        .foregroundColor(Color(hex: "464646"))
                    
                    
                }
                .cornerRadius(20)
                
                Button(action: {
                    selectedPartners.remove(partner)
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.white)
                        .font(.system(size: 10, weight: .bold))
                        .frame(width: 24, height: 24)
                        .background(Color(hex: "464646"))
                        .clipShape(Circle())
                }
                .offset(x: 5, y: -5)
            }
        }
    }
    
    private var createRoomButton: some View {
        Button(action: createRoom) {
            Text("그룹 만들기")
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isFormValid ? .white : Color(hex: "8691A2"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(isFormValid ? Color(hex: "FF4B2F") : Color(hex: "E7E7E7"))
                .cornerRadius(8)
        }
        .disabled(!isFormValid)
        .padding(.bottom, 10)
    }
    
    // MARK: - Actions
    
    private func createRoom() {
        print("선택된 파트너: \(selectedPartners)")
        
        // 토큰 확인
        guard let token = TokenManager.shared.getToken() else { 
            print("❌ 토큰 없음 - 방 생성 불가")
            return
        }
        
        let invitedIds = selectedPartners.map { $0.id }
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        
        let startDateString = formatter.string(from: CreateGroupData.shared.startDate)
        let endDateString = formatter.string(from: CreateGroupData.shared.endDate)
        
        let request = GroupRequest(
            invitedIds: invitedIds,
            roomName: CreateGroupData.shared.name,
            startDate: startDateString,
            endDate: endDateString,
            reward: CreateGroupData.shared.reward,
            days: CreateGroupData.shared.selectedDaysString,
            dayCountByWeek: CreateGroupData.shared.selectedDaysCount,
        )
        
        Task {
            do {
                // 토큰과 함께 서버에 요청
                let response = try await GroupService.shared.createGroup(request: request, token: token)
                print("✅ 서버에 그룹 생성 성공")
                
                // 메인 스레드에서 UI 업데이트 실행
                await MainActor.run {
                    // 새로운 그룹 생성
                    let newGroup = GroupModel(
                        id: response.roomId,
                        name: CreateGroupData.shared.name,
                        startDate: CreateGroupData.shared.startDate,
                        endDate: CreateGroupData.shared.endDate,
                        reward: CreateGroupData.shared.reward,
                        partners: selectedPartners.map { $0.name },
                        selectedDaysString: CreateGroupData.shared.selectedDaysString,
                        selectedDaysCount: CreateGroupData.shared.selectedDaysCount,
                    )
                    
                    // 그룹 스토어에 추가
                    groupStore.addGroup(newGroup)
                    
                    // 습관 설정 페이지로 이동
                    navigationPath.append(NavigationDestination.setuphabit(roomId: response.roomId))
                    
                    print("✅ 습관 설정 페이지로 이동")
                }
                
            } catch {
                print("❌ 그룹 생성 실패: \(error.localizedDescription)")
                // 에러 처리도 메인 스레드에서
                await MainActor.run {
                    // 여기에 에러 알림 UI 추가 가능
                }
            }
        }//Task
    }
}
