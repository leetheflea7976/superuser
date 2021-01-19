//
//  NumericModels.swift
//  Superuser
//
//  Created by Phi on 2021-01-17.
//

import SwiftUI

enum Numeric {
    case health, priority, severity
}

struct NumericData {
    var key: String
    var label: String
    var color: Color
}

let HealthData = NumericData(key: "health", label: "Health", color: Color.green)
let PriorityData = NumericData(key: "priority", label: "Priority", color: Color.red)
let SeverityData = NumericData(key: "severity", label: "Severity", color: Color.yellow)
