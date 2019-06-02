//
//  ERManager+Update.swift
//  ExchangeRates
//
//  Created by Vladimir on 03.06.2019.
//  Copyright © 2019 Vladimir. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

extension ERManager {
    func update () {
        request(host + "/ticker").response { response in
            let result = try! JSONDecoder().decode(RateList.self, from: response.data!)
            
            let realm = try! Realm()
            
            let mirror = Mirror(reflecting: result)
            for item in mirror.children {
                if let name: String = item.label, let rate:Rate = item.value as? Rate {
                    let exchange = ExchangeRate()
                    exchange.sCurrencyCode = name
                    exchange.sCurrencySymbol = rate.symbol!
                    exchange.nBuyRate = rate.buy!
                    exchange.nLastRate = rate.last!
                    exchange.nSellRate = rate.sell!
                    
                    try! realm.write {
                        realm.add(exchange)
                    }
                }
            }
            
            print (self.rates)
        }
    }
}
