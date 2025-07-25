//
//  MypageRow.swift
//  WeAct
//


import SwiftUI

struct MypageRow: View {
    @Binding var navigationPath: NavigationPath
    var text: String
    var action: () -> Void

    var body: some View {
        HStack {
            Text(text)
                .font(.custom("Pretendard-Medium", size: 16))
                .foregroundColor(Color(red: 0.09, green: 0.09, blue: 0.09))

            Spacer()
            
            Button(action: {
                action()
            }){
                Image(systemName: "chevron.right")
                    .foregroundColor(Color(red: 0.09, green: 0.09, blue: 0.09))
            }
            //.buttonStyle(.plain)
        }
       
    }
    
    
    
    
}

#Preview {
    @State var dummyPath = NavigationPath()
    return MypageRow(navigationPath: $dummyPath, text: "Hi") {
        print("Chevron tapped")
    }
}
