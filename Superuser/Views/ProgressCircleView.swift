//
//  ProgressCircleView.swift
//  Superuser
//
//  Created by Phi on 2021-01-16.
//

import SwiftUI

struct ProgressCircleView: View {
    var progress: CGFloat
    var circleSize: CGFloat
    var lineWidth: CGFloat
    var color: Color
    @State var initialized = false
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .opacity(0.3)
                .foregroundColor(color)
                .frame(width: circleSize, height: circleSize)
            Circle()
                .trim(from: 0.0, to: CGFloat(min((initialized ? self.progress : 0) / 10, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round))
                .foregroundColor(color)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear)
                .frame(width: circleSize, height: circleSize)
        }
        .onAppear {
            initialized = true
        }
        .onDisappear {
            initialized = false
        }
    }
}

struct ProgressCircleView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressCircleView(progress: 10.0, circleSize: 20, lineWidth: 4, color: Color.red)
    }
}
