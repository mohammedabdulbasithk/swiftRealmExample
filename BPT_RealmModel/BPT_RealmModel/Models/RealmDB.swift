//
//  RealmDB.swift
//  BPT_RealmModel
//
//  Created by Apple on 24/02/20.
//  Copyright © 2020 Agaze. All rights reserved.
//

import Foundation
import RealmSwift

class RealmDb {
    
    var realm = try! Realm()

    func initializeRealmDb(){
        realm = try! Realm()
    }
    
    func checkIfDbExists()->Bool {
//        let realm = try! Realm()
        let nodes = realm.objects(header.self)
        return !nodes.isInvalidated
    }
    
    func getRealmDbVersion ()-> Double {
//        let realm = try! Realm()
        let headerNodes = realm.objects(header.self)
        var verNumber = 0.0
        if !headerNodes.isInvalidated {
            if (headerNodes.count > 0){
                for node in headerNodes{
                    let verString = node.theme_version
                    let NSstringFromString = NSString(string: verString as NSString)
                    let doubleFromNSString = NSstringFromString.doubleValue
                    if doubleFromNSString > verNumber  {
                        verNumber = doubleFromNSString
                    }
                }
            }
        }
        return verNumber
    }
    
    //fun to parse a json file from the app directory...
    func loadDatatoRelamFromJsonFile(jsonfile:String, typeClass: Object.Type, callback:@escaping (APP_RET_VAL) -> Void) {
        
//        self.clearCurrentLocalDb()
        if let path = Bundle.main.path(forResource: jsonfile, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
//                loadHeaderNodeinRealm(jsonResult : jsonResult)
                
                if let jsonResultnodes = jsonResult as? Dictionary<String,AnyObject>,
                    let nodes = jsonResultnodes["nodes"] as? [Any] {
                    for value in nodes {
                        try! realm.write {
                            realm.create(typeClass.self, value:value, update:.modified)
                        }
                    }
                    callback( APP_RET_VAL.RET_SUCCESS)
                }
            } catch {
                callback(APP_RET_VAL.RET_ERROR)
            }
        }else{
            callback(APP_RET_VAL.RET_ERROR)
        }
    }
    
    private func loadHeaderNodeinRealm(jsonResult : Any) {
        if let jsonResultnodes = jsonResult as? Dictionary<String,AnyObject>,
            let nodes = jsonResultnodes["header"] as? Any {
            try! realm.write {
                realm.create(header.self, value:nodes, update:.modified)
            }
        }
    }
    
    //func to parse the json header..
    func parseJsonHeader(jsonfile:String, callback:@escaping (APP_RET_VAL) -> Void){
        if let path = Bundle.main.path(forResource: jsonfile, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String,AnyObject>,
                    let headerobj = jsonResult["header"] as? AnyObject {
                    
                    try! realm.write {
                        realm.create(header.self, value: headerobj, update:.modified)
                    }
                    callback(APP_RET_VAL.RET_SUCCESS)
                }
                
            } catch {
                callback(APP_RET_VAL.RET_ERROR)
            }
        }else{
            callback(APP_RET_VAL.RET_ERROR)
        }
    }
    
    //func to fetch the parent nodes for a node
    func getParentNode(node:M_Node) -> Results<M_Node>{
        let parentId = node.parent_id
        let nodes = fetchNodesFromRealmforProperty(property: "id", value: parentId)
        return nodes as Results<M_Node>
    }
    
    //func to fetch the theme nodes for vent cast
    func getThemeNodes(value:String) -> Results<M_Node>{
        let nodes = fetchNodesFromRealmforProperty(property: "tree", value: value)
        return nodes as Results<M_Node>
    }
    
    //func to fetch the childdren nodes for a node
    func getChildrenNodes(node:M_Node) {
        let childrenIdList = node.children
        for id in childrenIdList{
            print("childrenNodes",fetchNodesFromRealmforProperty(property: "id", value: id))
        }
    }
    
    //func to fetch nodes based on a property
    func fetchNodesFromRealmforProperty(property:String,value:String) -> Results<M_Node> {
        let realm = try! Realm()
        let nodes = realm.objects(M_Node.self).filter("\(property)='\(value)'")//filter("\(property)=\(value)") for Int values.
        print(nodes)
        return nodes as Results<M_Node>
    }
    
    func fetchNodeFromRealmforProperty(property:String,value:String) -> M_Node? {
        let realm = try! Realm()
        let node = realm.objects(M_Node.self).filter("\(property)='\(value)'").first//filter("\(property)=\(value)") for Int values.
        print(node)
        return node
    }
    
    
    //func to fetch all the nodes of realmDb
    
    func fetchFromRealmAllHeadrObjs() -> Results<header>{
        let realm = try! Realm()
        let nodes = realm.objects(header.self)
        return nodes
    }
    
    func fetchAllObjectsFromRealm(objectType: Object.Type) -> Results<Object> {
        let nodes = realm.objects(objectType.self)
        return nodes
    }
    
    func deleteRealmDbObjects(){
        self.clearCurrentLocalDb()
    }
    //func to delete the realm db..
    func removeRealmDb(){
        try!
            FileManager.default.removeItem(at: Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    private func clearCurrentLocalDb() {
        if !realm.isEmpty {
            realm.deleteAll()
        }
    }
    
    //func to delete a node
    private func deleteNodeFromRealm(id: String){
//        let realm = try! Realm()
        let node = fetchNodesFromRealmforProperty(property: "id", value: id)
        try? realm.write ({
            realm.delete(node)
        })
        
    }
}

class M_Node : Object {
    
    @objc dynamic var id = "12345"
    @objc dynamic var name : String = ""
    let children = List<String>()
    @objc dynamic var parent_id:String = "123"
    
    override static func primaryKey() -> String{
        return "id";
    }
    func createNode(nodeValue:String){
        name = nodeValue
    }
    func addChild(child: String) {
        children.append(child)
    }
    func setParent(parentNode: String){
        parent_id = parentNode
    }
}

class header : Object{
    @objc dynamic var top_left_lat :  Double = 0
    @objc dynamic var top_left_long : Double = 0
    @objc dynamic var btm_right_lat : Double = 0
    @objc dynamic var btm_right_long : Double = 0
    @objc dynamic var mtheme_id : String = ""
    @objc dynamic var theme_version : String = ""
    @objc dynamic var mtheme_name : String = ""
    @objc dynamic var mrootnode_id : String = "0"
    @objc dynamic var mDate: String = ""
    
    override static func primaryKey() -> String{
        return "mtheme_id";
    }
}

public enum APP_RET_VAL {
    case RET_SUCCESS
    case RET_ERROR
}

