//
//  AreaChartView.swift
//  Runner
//
//  Created by kimi on 2025/1/16.
//

import SwiftUI

struct AreaChartView: View {
    let chartData: [AreaChartData]
    let hint: CGFloat
    init(chartData: [AreaChartData], hint: CGFloat? = 0) {
        self.chartData = chartData
        self.hint = CGFloat(cbrtf(Float(hint ?? 0)))
    }
    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width
            let height = geometry.size.height
            let data = chartData.map { CGFloat(cbrtf(Float($0.value))) }
            let maxValue = data.max() ?? 1
            let minValue = data.min() ?? 0
            let points = data.enumerated().map { index, value in
                CGPoint(
                    x: width / CGFloat(data.count - 1) * CGFloat(index),
                    y: height - (value - minValue) / (maxValue - minValue) * height
                )
            }
        
            ZStack {
                AreaShape(points: points)
                    .fill(LinearGradient(
                        colors: [
                            mainColor.opacity(0.6),
                            mainColor.opacity(0)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    ))
                
                Path { path in
                    guard let firstPoint = points.first else { return }
                    path.move(to: firstPoint)
                    for point in points.dropFirst() {
                        path.addLine(to: point)
                    }
                }
                .stroke(mainColor.opacity(0.6), lineWidth: 2)
                
                DashedLine(yPosition: height - (hint - minValue) / (maxValue - minValue) * height)
                    .stroke(Color.gray.opacity(0.1), style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                
                ForEach(0..<data.count, id: \.self) { index in
                    let point = points[index]
                    Text(chartData[index].title ?? "")
                        .font(.system(size: 10))
                        .foregroundColor(.gray.opacity(0.5))
                        .position(x: point.x, y: height + 20)
                        .padding(.leading, index == 0 ? 6 : 0)
                }
            }
        }
        .padding(.vertical)
    }
}

struct AreaShape: Shape {
    var points: [CGPoint]

    func path(in rect: CGRect) -> Path {
        var path = Path()

        guard let firstPoint = points.first else { return path }

        // 起始点
        path.move(to: CGPoint(x: firstPoint.x, y: rect.height))
        path.addLine(to: firstPoint)

        // 曲线
        for point in points.dropFirst() {
            path.addLine(to: point)
        }

        // 收尾封闭路径
        if let lastPoint = points.last {
            path.addLine(to: CGPoint(x: lastPoint.x, y: rect.height))
        }

        path.closeSubpath()
        return path
    }
}


struct DashedLine: Shape {
    var yPosition: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: yPosition))
        path.addLine(to: CGPoint(x: rect.width, y: yPosition))
        return path
    }
}
