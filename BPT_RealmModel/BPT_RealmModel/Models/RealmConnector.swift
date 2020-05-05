//
//  RealmConnector.swift
//  BPT_RealmModel
//
//  Created by Apple on 24/02/20.
//  Copyright © 2020 Agaze. All rights reserved.
//

import Foundation

class RealmConnector: RealmDb {
    
    func fetchNodesFromRealm(keyword:String, value: String) -> [ M_Node]? {
        var nodeList = [M_Node]()
        let nodes = super.fetchNodesFromRealmforProperty(property: keyword, value: value)
        for node in nodes{
            nodeList.append(node)
        }
        return nodeList
    }
    
    func fetchNodeFromRealm(keyword: String, value: String) -> M_Node? {
        let node = super.fetchNodeFromRealmforProperty(property: keyword, value: value)
        return node
    }
    
    func getNodes(node: M_Node){
        
    }
    
    func loadJsonDatatoRealm(jsonFileName: String, loadStatus: @escaping (APP_RET_VAL) -> Void){
        super.loadDatatoRelamFromJsonFile(jsonfile: jsonFileName, typeClass: M_Node.self) { (loadJsonStatus) in
            print(loadJsonStatus)
            loadStatus(loadJsonStatus)
        }
    }
}


