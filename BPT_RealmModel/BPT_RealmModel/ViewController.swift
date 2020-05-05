//
//  ViewController.swift
//  BPT_RealmModel
//
//  Created by Apple on 24/02/20.
//  Copyright © 2020 Agaze. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        TheAppModel.sharedInstance.getRealmInstance()?.loadDatatoRelamFromJsonFile(jsonfile: "topicJson", typeClass: TopicModel.self) { (result) in
//            print(result)
//        }
//        TheAppModel.sharedInstance.getRealmInstance()?.loadDatatoRelamFromJsonFile(jsonfile: "areaJson", typeClass: HyperLocalArea.self) { (result) in
//            print(result)
//        }

        let nodes = TheAppModel.sharedInstance.getRealmInstance()?.fetchAllObjectsFromRealm(objectType: TopicModel.self)
        print(nodes)
        // Do any additional setup after loading the view.
    }

}

