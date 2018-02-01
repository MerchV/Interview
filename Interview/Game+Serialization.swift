//
//  Game+Serialization.swift
//  Interview
//
//  Created by Merch on 2018-01-26.
//  Copyright © 2018 Merch. All rights reserved.
//

import Foundation

// I'm doing the JSON parsing in extensions of the NSManagedObject subclass so that each managed object is responsible for its own JSON parsing
extension Game {

    func deserialize(jsonObject: [String:Any?]) {
        name = jsonObject["name"] as? String
        developer = jsonObject["developer"] as? String
        year = jsonObject["year"] as? String
        image = jsonObject["image"] as? String
    }
}
