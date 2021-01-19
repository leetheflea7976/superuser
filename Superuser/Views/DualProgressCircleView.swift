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
    var innerCircleSize: CGFloat
    var outerCircleSize: CGFloat
    var lineWidth: CGFloat
}

private func getMetrics(size: DualProgressCircleSize) -> DualProgressCircleMetrics {
    switch (size) {
        case .large: return DualProgressCircleMetrics(innerCircleSize: 32, outerCircleSize: 56, lineWidth: 8)
        case .small: return DualProgressCircleMetrics(innerCircleSize: 16, outerCircleSize: 28, lineWidth: 4)
    }
}

struct DualProgressCircleView: View {
    var innerTuple: (Int16, Color)
    var outerTuple: (Int16, Color)
    var size: DualProgressCircleSize
    var metrics: DualProgressCircleMetrics
    
    init(innerTuple: (Int16, Color), outerTuple: (Int16, Color), size: DualProgressCircleSize = .small) {
        self.innerTuple = innerTuple
        self.outerTuple = outerTuple
        self.size = size
        metrics = getMetrics(size: size)
    }
    
    var body: some View {
        ZStack {
            ProgressCircleView(progress: CGFloat(innerTuple.0), circleSize: metrics.innerCircleSize, lineWidth: metrics.lineWidth, color: innerTuple.1)
            ProgressCircleView(progress: CGFloat(outerTuple.0), circleSize: metrics.outerCircleSize, lineWidth: metrics.lineWidth, color: outerTuple.1)
        }
    }
}

struct DualProgressCircleView_Previews: PreviewProvider {
    static var previews: some View {
        DualProgressCircleView(innerTuple: (5, Color.red), outerTuple: (5, Color.green))
    }
}
