//
//  HealthPriorityDualCircleView.swift
//  Superuser
//
//  Created by Phi on 2021-01-16.
//

import SwiftUI

enum DualProgressCircleSize {
    case small, large
}

struct DualProgressCircleMetrics {
    var outerCircleSize: CGFloat
    var innerCircleSize: CGFloat
    var lineWidth: CGFloat
}

private func getMetrics(size: DualProgressCircleSize) -> DualProgressCircleMetrics {
    switch (size) {
        case .large: return DualProgressCircleMetrics(outerCircleSize: 32, innerCircleSize: 56, lineWidth: 8)
        case .small: return DualProgressCircleMetrics(outerCircleSize: 16, innerCircleSize: 28, lineWidth: 4)
    }
}

struct DualProgressCircleView: View {
    var innerValue: Int16
    var outerValue: Int16
    var size: DualProgressCircleSize
    var metrics: DualProgressCircleMetrics
    
    init(innerValue: Int16, outerValue: Int16, size: DualProgressCircleSize = .small) {
        self.innerValue = innerValue
        self.outerValue = outerValue
        self.size = size
        metrics = getMetrics(size: size)
    }
    
    var body: some View {
        ZStack {
            ProgressCircleView(progress: CGFloat(innerValue), circleSize: metrics.innerCircleSize, lineWidth: metrics.lineWidth, color: Color.green)
            ProgressCircleView(progress: CGFloat(outerValue), circleSize: metrics.outerCircleSize, lineWidth: metrics.lineWidth, color: Color.red)
        }
    }
}

struct DualProgressCircleView_Previews: PreviewProvider {
    static var previews: some View {
        DualProgressCircleView(innerValue: 5, outerValue: 5)
    }
}
