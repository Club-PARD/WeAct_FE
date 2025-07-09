//
//  TooltipShapeView.swift
//  WeAct
//
//  Created by 최승아 on 7/5/25.
//

import SwiftUI

struct TooltipShapeView: View {
    var body: some View {
        ZStack {
            CustomTriangleShape()
                .fill(Color(hex: "464646"))
                .padding(.leading, 145)
            
            CustomRectangleShape(text: "인증 기간 내 N회 이상 무단으로 미인증하면 방에서 강제 퇴장돼요. 단, ‘해명할래요’ 기능은 횟수 제한 없이 사용 가능해요.")
        }
        .frame(width: 190, height: 100)
    }
}

struct CustomTriangleShape: Shape {
    private var width: CGFloat
    private var height: CGFloat
    private var radius: CGFloat
    
    init(width: CGFloat = 24, height: CGFloat = 24, radius: CGFloat = 1) {
        self.width = width
        self.height = height
        self.radius = radius
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX + width / 2 - radius, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX + width / 2 + radius, y: rect.minY),
            control: CGPoint(x: rect.minX + width / 2, y: rect.minY + radius)
        )
        path.addLine(to: CGPoint(x: rect.minX + width, y: rect.minY + height))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + height))
        
        path.closeSubpath()
        
        return path
    }
}

struct CustomRectangleShape: View {
    var text: String
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(text)
                .font(.custom("Pretendard-Medium", size: 12))
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
                .background(
                    RoundedRectangle(cornerRadius:10)
                        .fill(Color(hex: "464646"))
                )
        }
    }
}


#Preview {
    TooltipShapeView()
}
