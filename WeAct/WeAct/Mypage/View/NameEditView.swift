//
//  Mypage.swift
//  WeAct
//
//  Created by 주현아 on 6/30/25.
//

import SwiftUI

struct NameEditView: View {
    // 새로 입력한 이름
    @Binding var navigationPath: NavigationPath
    @EnvironmentObject var userViewModel: UserViewModel
    // 이름이 변경되었고 공백이 아닌지 확인
    @State private var editedName: String = ""

    private var isFormValid: Bool {
           !editedName.trimmingCharacters(in: .whitespaces).isEmpty &&
            editedName != userViewModel.user.userName
       }
    
    // 커스텀 뒤로가기 버튼
    private var customBackButton: some View {
            Button(action: {
                if !navigationPath.isEmpty {
                    navigationPath.removeLast()
                }
            }) {
                Image(systemName: "chevron.left")
                    .frame(width: 12, height: 21)
                    .foregroundColor(.black)
            }
        }
    
    var body: some View {
        NavigationView {
            VStack{
                VStack(alignment: .leading){
                    Text("이름")
                        .foregroundColor(Color(red: 0.52, green: 0.52, blue: 0.53))
                        .padding()
                    TextField("이름 입력", text: $editedName)
                        .padding(.leading, 22)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity, minHeight: 54, maxHeight: 54, alignment: .leading)
                        .background(.white)
                        .cornerRadius(8)
                        .onAppear {
                            editedName = userViewModel.user.userName
                        }
                }
                Spacer()
                
                Button(action: {
                    Task{
                        userViewModel.user.userName = editedName
                        //임시
                        navigationPath.append(NavigationDestination.myPage)
                    }
                }) {
                    Text("저장하기")
                        .font(.custom("Pretendard-Medium", size: 16))
                        .foregroundColor(.white)
                }
                .foregroundColor(.white)
                
                .frame(width: 330, height: 56)
                .background(Color(red: 1, green: 0.29, blue: 0.18))
                .cornerRadius(8)
                
            }
            .padding(.horizontal,17)
            .background(Color(red: 0.97, green: 0.97, blue: 0.97))
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: customBackButton)
        .navigationTitle("이름 변경")
        .navigationBarTitleDisplayMode(.inline)
        
        Spacer()
    }
}

