//
//  APICaller.swift
//  CurrencyConverter
//
//  Created by David on 22.08.2022.
//

import Foundation
import Combine

enum APIError: Error {
    case incorrectURL
    case invalidResponse(String)
    case unknown(String)
}

struct ExchangeResult: Decodable {
    let amount: Double
    let currency: String
    
    private enum CodingKeys: String, CodingKey {
        case amount
        case currency
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.currency = try container.decode(String.self, forKey: .currency)
        self.amount = Double(try container.decode(String.self, forKey: .amount)) ?? 0
    }
}

class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    func exchange(from: Currency, to: Currency) -> Future<ExchangeResult, Error> {
        return Future { promise in
            
            guard let url = URL(string: "http://api.evp.lt/currency/commercial/exchange/\(from.value)-\(from.symbol)/\(to.symbol)/latest") else {
                promise(.failure(APIError.incorrectURL))
                return
            }
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    if let result = try? JSONDecoder().decode(ExchangeResult.self, from: data) {
                        promise(.success(result))
                    }
                } else if let error = error {
                    promise(.failure(APIError.invalidResponse("HTTP Request Failed \(error)")))
                } else {
                    promise(.failure(APIError.unknown("Invalid Response")))
                }
            }
            
            task.resume()
        }
    }
}
