//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "9E4C354D-FEA5-424F-8503-8EAEC5669532"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    func getCoinPrice(for currency: String) {
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        print(urlString)
        performRequest(with: urlString)
    }
            
    func performRequest(with urlString: String) {
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                
                if error != nil {
                    // TODO: Show error in delegate
                    return
                }
                
                if let safeData = data {
                    if let coinInfo = parseJSON(safeData) {
                        print(String(data: safeData, encoding: .utf8) ?? "")
                    }
                }
            }
            
            task.resume()
        }
    }
    
    func parseJSON(_ coinData: Data) -> CoinModel? {
        let decoder = JSONDecoder()
        
        do {
            let decodedData = try decoder.decode(CoinData.self, from: coinData)
            
            let cryptoCurrency = decodedData.asset_id_base
            let fiatCurrency = decodedData.asset_id_quote
            let rate = decodedData.rate
            
            let coin = CoinModel(cryptoCurrency: cryptoCurrency, fiatCurrency: fiatCurrency, rate: rate)
            return coin
            
        } catch {
            // TODO: Show error in delegate
            return nil
        }
    }
}
