//
//  ERManager.swift
//  ExchangeRates
//
//  Created by Vladimir on 03.06.2019.
//  Copyright © 2019 Vladimir. All rights reserved.
//

import Foundation
import RealmSwift

class ERManager {
    let host = "https://blockchain.info";
    static let shared = ERManager()
    
    var rates:Results<ExchangeRate> {
        get {
            let realm = try! Realm()
            return realm.objects(ExchangeRate.self)
        }
    }
    
    private init() {}
}
