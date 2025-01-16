//
//  NetworkManager.swift
//  SubscriptionWidgetExtension
//
//  Created by Kimi on 2025/1/7.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    func getData(url: String) async -> Result<Data, Error> {
        return await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                self.fetchData(url: url) { result in
                    continuation.resume(returning: result)
                }
            }
        }
    }
    
    func fetchData(url: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let uri = URL(string: url) else {
            completion(.failure(NSError(domain: "url is empty", code: -1)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: uri) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "data is empty", code: -1)))
                return
            }
            completion(.success(data))
        }
        task.resume()
    }
}
