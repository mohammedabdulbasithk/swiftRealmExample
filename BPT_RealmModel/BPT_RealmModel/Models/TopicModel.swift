//
//  TopicModel.swift
//  BPT_RealmModel
//
//  Created by Apple on 25/02/20.
//  Copyright © 2020 Agaze. All rights reserved.
//

import Foundation
import RealmSwift

class TopicModel : Object{
    
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    var vent_id_list = List<Int> ()
    var children = List<String> ()
    @objc dynamic var parent_id: String?
    @objc dynamic var is_parent: Bool = false
    
    override static func primaryKey() -> String {
        return "id";
    }
}
