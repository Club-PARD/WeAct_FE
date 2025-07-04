//
//  ToastView.swift
//  WeAct
//
//  Created by 주현아 on 7/3/25.
//

import SwiftUI

struct ToastView: View {
    let message: String

    var body: some View {

        HStack(spacing: 10) {
            Image("RedCheckmark")
                .frame(width: 22.15384, height: 22.15384)

            Text(message)
                .foregroundColor(.white)
                .font(
                    Font.custom("Pretendard", size: 16)
                        .weight(.medium)
                )
        }//HStack
        .padding(.horizontal, 28)
        .padding(.vertical, 14)
        
        .frame(width: 343, height: 54, alignment: .leading)
        .background(Color(red: 0.27, green: 0.27, blue: 0.27))
        .cornerRadius(10)
    }

}
