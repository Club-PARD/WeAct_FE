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
    @ObservedObject var userModel: UserModel
    // 이름이 변경되었고 공백이 아닌지 확인
    @State private var editedName: String = ""

    private var isFormValid: Bool {
           !editedName.trimmingCharacters(in: .whitespaces).isEmpty &&
            editedName != userModel.username
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
        VStack{
            Text("이름 변경")
                .font(Font.custom("Pretendard", size: 18).weight(.medium))
                .foregroundColor(.black)
                .frame(height: 44)
                .padding(.top, 5)
                .padding(.bottom, 44)
            
            
            VStack(alignment: .leading){
                Text("이름")
                    .foregroundColor(Color(red: 0.53, green: 0.57, blue: 0.64))
                
                TextField("이름 입력", text: $editedName)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Color(red: 0.93, green: 0.95, blue: 0.96))
                    .cornerRadius(4)
                    .onAppear {
                        editedName = userModel.username
                    }


            }
            Spacer()
            
            Button(action: {
                userModel.username = editedName
                navigationPath.append(NavigationDestination.myPage)
            }) {
                Text("저장하기")
                    .font(
                      Font.custom("Pretendard", size: 16)
                        .weight(.medium)
                      )
                    .foregroundColor(.white)
            }
            .font(Font.custom("Pretendard", size: 16).weight(.medium))
                   .foregroundColor(.white)
                   .frame(width: 330, height: 56)
                   //.background(Color(red: 0.37, green: 0.4, blue: 0.43))
                   .cornerRadius(4)
                   .disabled(!isFormValid)
                   .background(isFormValid ? Color(red: 0.37, green: 0.4, blue: 0.43) : Color(red: 0.93, green: 0.95, blue: 0.96))
            
        }
        .padding(.horizontal,10)
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: customBackButton)
        Spacer()
    }
}

#Preview {
    @State var path = NavigationPath()
    @StateObject var userModel = UserModel()
    return NameEditView(navigationPath: .constant(path), userModel: userModel)
}
