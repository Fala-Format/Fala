//
//  DataModel.swift
//  Runner
//
//  Created by kimi on 2025/1/16.
//

import Foundation

struct AreaChartData : Codable {
    let value: CGFloat
    let title: String?
    init(_ value: CGFloat, title: String? = nil) {
        self.value = value
        self.title = title
    }
}

struct WidgetCustomDataModel: Codable {
    let title: String
    let data: [WidgetShowDataModel]
    let chart: [AreaChartData]?
    let chart_hint: CGFloat?
    let last_time: String?
}

struct WidgetShowDataModel: Codable {
    let title: String
    let value: String
}
