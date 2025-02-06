//
//  SubscriptionWidget.swift
//  SubscriptionWidget
//
//  Created by Kimi on 2025/1/7.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SubscriptionEntry {
        .init(date: .now, type: "text", data: "Subscription".data(using: .utf8)!, family: context.family)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SubscriptionEntry {
        .init(date: .now, type: "text", data: "Subscription".data(using: .utf8)!, family: context.family)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SubscriptionEntry> {
        var entries: [SubscriptionEntry] = []

        if let sources = configuration.subscription?.source, !sources.isEmpty {
            var source = sources.first!
            
            let size = context.family == .systemSmall ? "widget_small" : context.family == .systemMedium ? "widget_middle" : "widget_large"
            if sources.filter({ $0.type == size }).first != nil {
                source = sources.filter { $0.type == size }.first!
            }
            let result = await NetworkManager.shared.getData(url: source.url)
            if case .success(let data) = result {
                entries.append(.init(date: .now, type: source.dataType, data: data, family: context.family))
            }
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SubscriptionEntry: TimelineEntry {
    let date: Date
    let type: String
    let data: Data
    let family: WidgetFamily
}

struct SubscriptionWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            if(entry.type == "text"){
                Text(String(data: entry.data, encoding: .utf8) ?? "empty data").font(.system(size: 14))
            } else if(entry.type == "image") {
                Image(uiImage: UIImage(data: entry.data)!)
                    .resizable()
                    .aspectRatio(contentMode: ContentMode.fill)
            } else if let model: WidgetCustomDataModel = loadJsonData(entry.data), entry.type == "custom" {
                CustomDataWidgetView(model: model, family: entry.family)
            }
        }
    }
}

struct SubSubscriptionBackgroupView: View {
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        colorScheme == .dark ? Color(red: 0.1, green: 0.1, blue: 0.1) : .white
    }
}

struct SubscriptionWidget: Widget {
    let kind: String = "SubscriptionWidget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            SubscriptionWidgetEntryView(entry: entry)
                .containerBackground(for: .widget) {
                    SubSubscriptionBackgroupView()
                }
        }
    }
}
