//
//  HPCirclesView.swift
//  Superuser
//
//  Created by Phi on 2021-01-17.
//

import SwiftUI

struct HPCirclesView: View {
    @ObservedObject var area: Area
    var size: DualProgressCircleSize = .small
    
    var body: some View {
        DualProgressCircleView(innerTuple: (area.health, HealthData.color), outerTuple: (area.priority, PriorityData.color), size: size)
    }
}

struct SPCirclesView: View {
    @ObservedObject var obstacle: Obstacle
    var size: DualProgressCircleSize = .small
    
    var body: some View {
        DualProgressCircleView(innerTuple: (obstacle.severity, SeverityData.color), outerTuple: (obstacle.priority, PriorityData.color), size: size)
    }
}
