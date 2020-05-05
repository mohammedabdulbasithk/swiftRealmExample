//
//  AppModel.swift
//  BPT_RealmModel
//
//  Created by Apple on 28/02/20.
//  Copyright © 2020 Agaze. All rights reserved.
//

import Foundation
class TheAppModel {
    
    static let sharedInstance = TheAppModel()
    
    var realmConnector: RealmConnector?
    var locationService: LocationService?
    
    func modelInit (){
        realmConnector = RealmConnector()
        locationService = LocationService.sharedInstance
        locationService?.startUpdatingLocation()
    }
    
    func getRealmInstance () -> RealmConnector?{
        return realmConnector
    }
    
    func getLocationServiceInstance () -> LocationService?{
        return locationService
    }
}
