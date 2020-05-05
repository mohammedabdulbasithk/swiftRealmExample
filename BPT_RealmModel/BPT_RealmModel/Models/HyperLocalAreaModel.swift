//
//  HyperLocalAreaModel.swift
//  BPT_RealmModel
//
//  Created by Apple on 25/02/20.
//  Copyright © 2020 Agaze. All rights reserved.
//

import Foundation
import RealmSwift

class HyperLocalArea: Object{
    @objc dynamic var areaName: String?
    @objc dynamic var id: String = ""
    var topics = List<String>()
    @objc dynamic var isActive: Bool = false
    @objc dynamic var lat: Double = 0.0
    @objc dynamic var lng: Double = 0.0
    
    override static func primaryKey() -> String {
        return "id";
    }
}
