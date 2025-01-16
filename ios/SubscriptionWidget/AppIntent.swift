//
//  AppIntent.swift
//  SubscriptionWidget
//
//  Created by Kimi on 2025/1/7.
//

import WidgetKit
import AppIntents

struct SubscriptionSource: AppEntity {
    var id: String
    var dataType: String
    var type: String
    var url: String
    
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Subscription source"
    
    var displayRepresentation: DisplayRepresentation {
        .init(stringLiteral: id)
    }
    static var defaultQuery = SubscriptionSourceQuery()
}

struct SubscriptionSourceQuery: EntityStringQuery{
    func entities(for identifiers: [SubscriptionSource.ID]) async throws -> [SubscriptionSource] {
        []
    }
    func entities(matching string: String) async throws -> [SubscriptionSource] {
        []
    }
}

struct SubscriptionEntity: AppEntity {
    var id: String
    var title: String
    var source: [SubscriptionSource]
    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Subscription Entity"
    static var defaultQuery = SubscriptionQuery()
    var displayRepresentation: DisplayRepresentation {
        .init(stringLiteral: title)
    }
    static var allSubscriptions: [SubscriptionEntity] {
        let userDefault = UserDefaults(suiteName: "group.io.fala.ios.client")
        let subscriptions = userDefault?.stringArray(forKey: "subscriptions") ?? []
        var result: [SubscriptionEntity] = []
        var index = 0
        for item in subscriptions {
            if let jsonData = item.data(using: .utf8) {
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: jsonData) as? [String: Any] {
                        if let subscriptions = jsonObject["subscriptions"] as? [[String: Any]] {
                            for subscription in subscriptions {
                                if let title = subscription["title"] as? String, let visible = subscription["visible"] as? Bool, visible, let sources = subscription["sources"] as? [[String: Any]], !sources.filter({ source in
                                    if let type = source["type"] as? String, type.contains("widget_") {
                                        return true
                                    }
                                    return false
                                }).isEmpty {
                                    var sourceArray: [SubscriptionSource] = []
                                    for source in sources.filter({ source in
                                        if let type = source["type"] as? String, type.contains("widget_") {
                                            return true
                                        }
                                        return false
                                    }) {
                                        sourceArray.append(.init(id: source["type"] as! String, dataType: source["data_type"] as! String, type: source["type"] as! String, url: source["url"] as! String))
                                    }
                                    result.append(.init(id: "\(index)", title: title, source: sourceArray))
                                    index += 1
                                }
                            }
                        }
                    }
                } catch {
                    print("Failed to convert JSON string to object: \(error)")
                }
            }
        }
        return result
    }
}

struct SubscriptionQuery: EntityStringQuery {
    func entities(matching string: String) async throws -> [SubscriptionEntity] {
        SubscriptionEntity.allSubscriptions.filter { $0.title.range(of: string, options: .caseInsensitive) != nil }
    }
    
    func entities(for identifiers: [SubscriptionEntity.ID]) async throws -> [SubscriptionEntity] {
        SubscriptionEntity.allSubscriptions.filter { identifiers.contains($0.id) }
    }
    
    func suggestedEntities() async throws -> [SubscriptionEntity] {
        SubscriptionEntity.allSubscriptions
    }
    
    func defaultResult() async -> SubscriptionEntity? {
        SubscriptionEntity.allSubscriptions.first
    }
}


struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource { "Configuration" }
    static var description: IntentDescription { "This is an subscription widget." }

    // An example configurable parameter.
    @Parameter(title: "Subscription")
    var subscription: SubscriptionEntity?
    
    init(subscription: SubscriptionEntity? = nil) {
        self.subscription = subscription
    }
    
    init() {
        
    }
}
