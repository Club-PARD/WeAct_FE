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
    //@ObservedObject var userModel: UserModel
    @ObservedObject var userViewModel: UserViewModel
    // 이름이 변경되었고 공백이 아닌지 확인
    @State private var editedName: String = ""

    private var isFormValid: Bool {
           !editedName.trimmingCharacters(in: .whitespaces).isEmpty &&
            editedName != userViewModel.user.username
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
                    
                    TextField("이름 입력", text: $editedName)
                        .padding(.leading, 22)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity, minHeight: 54, maxHeight: 54, alignment: .leading)
                        .background(.white)
                        .cornerRadius(8)
                        .onAppear {
                            editedName = userViewModel.user.username
                        }
                    
                }
                Spacer()
                
                Button(action: {
                    Task{
                        await userViewModel.saveNewName(editedName: editedName)
                        navigationPath.append(NavigationDestination.myPage)
                    }
                }) {
                    Text("저장하기")
                        .font(Font.custom("Pretendard", size: 16).weight(.medium))
                        .foregroundColor(.white)
                }
                .foregroundColor(.white)
                .frame(width: 330, height: 56)
                .cornerRadius(8)
                .disabled(!isFormValid)
                .background(isFormValid ? (Color(red: 1, green: 0.39, blue: 0.18)): Color(red: 0.93, green: 0.95, blue: 0.96))
                
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

#Preview {
    @State var path = NavigationPath()
    let userViewModel = UserViewModel()  
    return NameEditView(navigationPath: .constant(path), userViewModel: userViewModel)
}


