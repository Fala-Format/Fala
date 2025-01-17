//
//  CustomDataView.swift
//  SubscriptionWidgetExtension
//
//  Created by kimi on 2025/1/16.
//

import SwiftUI
import WidgetKit

struct CustomDataWidgetView: View {
    let model: WidgetCustomDataModel
    let family: WidgetFamily
    var body: some View {
        ZStack {
            VStack {
                Text(model.title)
                    .font(.system(size: 9))
                    .foregroundColor(.gray.opacity(0.5))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                Spacer()
            }
            GeometryReader { geometry in
                let width = geometry.size.width
                let height = geometry.size.height
                VStack {
                    HStack {
                        LazyHGrid(rows: Array(repeating: GridItem(.flexible(), spacing: 0), count: 2)) {
                            ForEach(0..<model.data.count) { index in
                                if(model.chart == nil || index < 2 || (family == .systemLarge && index < 4)) {
                                    VStack(spacing: 3) {
                                        Spacer()
                                        Text(model.data[index].title)
                                            .font(.system(size: 12, weight: .bold))
                                            .foregroundColor(mainColor)
                                            .frame(maxWidth: .infinity, alignment: .leading)
                                        HStack {
                                            Spacer()
                                            Spacer()
                                            let c = Text(model.data[index].value)
                                                .font(.system(size: 20, weight: .bold))
                                                .foregroundColor(.black)
                                                .frame(maxWidth: .infinity, alignment: .leading)
                                            
                                            if (model.data[index].value.count > 13){
                                                c.fixedSize(horizontal: true, vertical: false)
                                                    .position(x:width/2, y:13)
                                            } else {
                                                c
                                            }
                                        }
                                        Spacer()
                                    }
                                    .frame(width: (family == .systemLarge || (model.data.count > 1 && family != .systemSmall)) ? width / 2 : nil)
                                }
                            }
                        }
                        if model.chart != nil && !model.chart!.isEmpty && family == .systemMedium {
                            AreaChartView(chartData: model.chart!, hint: model.chart_hint)
                        }
                    }
                    .padding(.top, 10)
                    if model.chart != nil && !model.chart!.isEmpty && family == .systemLarge {
                        AreaChartView(chartData: model.chart!, hint: model.chart_hint)
                            .padding(.bottom, 6)
                    }
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
}
