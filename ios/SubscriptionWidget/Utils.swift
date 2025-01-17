//
//  Utils.swift
//  SubscriptionWidgetExtension
//
//  Created by kimi on 2025/1/16.
//

import SwiftUI

func loadJsonData<T: Decodable>(_ data: Data) -> T? {
    do {
        return try JSONDecoder().decode(T.self, from: data)
    } catch {
        return nil
    }
}

let mainColor: Color = Color(red: 0.86, green: 0.47, blue: 0.22)
