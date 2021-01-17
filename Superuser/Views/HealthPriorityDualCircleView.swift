//
//  HealthPriorityDualCircleView.swift
//  Superuser
//
//  Created by Phi on 2021-01-16.
//

import SwiftUI

struct HealthPriorityDualCircleView: View {
    var health: Int16
    var priority: Int16
    var outerCircleSize: CGFloat = 28
    var innerCircleSize: CGFloat = 16
    var lineWidth: CGFloat = 4
    
    var body: some View {
        ZStack {
            ProgressCircleView(progress: CGFloat(priority), circleSize: outerCircleSize, lineWidth: lineWidth, color: Color.red)
            ProgressCircleView(progress: CGFloat(health), circleSize: innerCircleSize, lineWidth: lineWidth, color: Color.green)
        }
    }
}

struct HealthPriorityDualCircleView_Previews: PreviewProvider {
    static var previews: some View {
        HealthPriorityDualCircleView(health: 5, priority: 5)
    }
}
