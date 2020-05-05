//
//  Bubbles.swift
//  BPT_RealmModel
//
//  Created by Apple on 27/02/20.
//  Copyright © 2020 Agaze. All rights reserved.
//

import Foundation
import UIKit

final class Bubble{
    var bubble_id : Int?
    var bubble_name: String?
    var bubble_color: UIColor?

    init(){
        self.bubble_id = 0
        self.bubble_name = "name"
        self.bubble_color = UIColor.red
    }
    
    init(id:Int,name:String){
        self.bubble_id = id
        self.bubble_name = name
    }
    
    init(id:Int,name:String,color:UIColor){
        self.bubble_id = id
        self.bubble_name = name
        self.bubble_color = color
    }
    
    func getBubbleName()->String{
        if(self.bubble_name == ""){
            assertionFailure("bubble name is empty")
        }
        return self.bubble_name!
    }
    
    func getBubbleColor()->UIColor{
        return self.bubble_color!
    }
    
    func getBubbleId()->Int{
        if(self.bubble_id == 0){
            // assertionFailure("bubble id is zero")
        }
        return self.bubble_id!
    }
}

class BubbleModelForView{
    var bubblesList = [Int: Bubble]()
    var m_currentParentNode : M_Node?
    var m_currentParentBubbleId : Int = 0

    let CHILD_BUBBLE_RADIUS = 60 // bubble radius made to 60 as per discussion with deepu
    let PARENT_BUBBLE_RADIUS = 60
    var bubblesSelected = false
    var parentBubble = Bubble()
    var childrenBubble = Bubble()
    var childrenNames = [String]()
 
    func getBubblesCount()->Int{
        var listcount = 0
        if(bubblesList.isEmpty){
            listcount = 0
        }else{
            listcount = bubblesList.count
        }
        return listcount
    }
    
    func setCurrentParentBubbleId(bubbleId:Int){
        self.m_currentParentBubbleId = bubbleId
    }
    
    func getCurrentParentBubbleId()->Int{
        if(self.m_currentParentBubbleId == nil){
            assertionFailure("parentBubble not set")
        }
        return self.m_currentParentBubbleId
    }
    /*
    func getCurrentGrandParentBubbleId()->Int {
        return self.getCurrentGrandParentBubble().getBubbleId()
    }*/
    
    func setBubblesSelected(){
        self.bubblesSelected = true
    }
    
    func getBubblesSelected()->Bool{
        return self.bubblesSelected
    }
    
    func getCurrentChildrenBubbles()->[Bubble]{
        return Array(bubblesList.values)
    }
    
    /* SAN Commeneted on 27-02-2020 func getCurrentParentBubble()->Bubble{
        var parent_node : M_Node
        let currentTheme = theAppModel.sharedInstance.getCurrentTheme() // as! VentTheme
        parent_node = currentTheme.getParentofCurrentTheme()
        if(!parent_node.name.isEmpty){
            self.parentBubble = Bubble(id: parent_node.id, name: parent_node.name, color: UIColor.parentColor)
        }else{
            self.parentBubble = Bubble(id: 999, name: "Oops!", color: UIColor.black)
        }
        return parentBubble
    }

    func getCurrentGrandParentBubble()->Bubble{
        var parent_node : M_Node
        let currentTheme = theAppModel.sharedInstance.getCurrentTheme() // as! VentTheme
        
        parent_node = currentTheme.getParentNodes(id: m_currentParentBubbleId)
        if(!parent_node.name.isEmpty){
            self.parentBubble = Bubble(id: parent_node.id, name: parent_node.name, color: UIColor.parentColor)
        }else{
            self.parentBubble = Bubble(id: 999, name: "Oops!", color: UIColor.black)
        }
        return parentBubble
    }
    */

    func getParentBubble()->Bubble{
        return parentBubble
    }
    /*
    private func getParentBubble(for_bubble_id:Int)->Bubble{
        var parent_node : M_Node
        
        let currentTheme = theAppModel.sharedInstance.getCurrentTheme() //as! VentTheme
        parent_node = currentTheme.getParentNodes(id: for_bubble_id)
        
        if(!parent_node.name.isEmpty){
            self.parentBubble = Bubble(id: parent_node.id, name: parent_node.name, color: UIColor.parentColor)
        }else{
            self.parentBubble = Bubble(id: 999, name: "Oops!", color: UIColor.black)
        }
        return parentBubble
    }
    */
    func getParentBubbleId()->Int{
        return parentBubble.getBubbleId()
    }
    
    func setParentBubble(parent_bubble:Bubble){
        self.parentBubble = parent_bubble
    }

    func getChildBubblesCount(for_theme:String)->Int{
        return bubblesList.count
    }
    /*
    func getChildrenBubbles(){
        var childrenList : M_Node?
        self.bubblesList.removeAll()
        let currentTheme = theAppModel.sharedInstance.getCurrentTheme() // as! VentTheme
        currentTheme.getChildrenNodes(id: m_currentParentBubbleId/*for_theme_id*/) { (childrens) in
            childrenList = childrens
            self.addBubbletoView(childrenList: childrenList)
            
        }
    }*/
    
    
    /*private*/ func getNodeNames(nameString : String)->(shortName:String, longName:String) {
        let names = nameString.split(separator: "$")
        var shortname = nameString
        var longname = nameString
        if (names.count > 1){
            shortname = String(names[0])
            longname = String(names[1])
        }
        return (shortname, longname)
    }
    /*
    func addBubbletoView(childrenList : M_Node?){
        let bubbleColorObj = ColorsForBubbles()
        if(!childrenList!.name.isEmpty){
            
            if childrenNames.contains(childrenList!.name){
                // continue
            }else{
                self.childrenBubble = Bubble(id: childrenList!.id, name: childrenList!.name, color: getNextColor())

                self.bubblesList.updateValue(childrenBubble, forKey: childrenList!.id)
                self.childrenNames.append(childrenList!.name)
            }
            
        }else {
            self.childrenBubble = Bubble(id: 999, name: "Oops!", color: UIColor.black)
        }
    }

    func setSelectedBubbleId(selectedBubbleId:Int){
        theAppModel.sharedInstance.getCurrentTheme().setSelectedNodeId(id:selectedBubbleId)
    }
    func getSelectedBubble()->Bubble{
        let bubbleid = theAppModel.sharedInstance.getCurrentTheme().getSelectedNodeId()
        if  bubblesList.keys.contains(bubbleid){
            return bubblesList[bubbleid]!
        }else if m_currentParentBubbleId == bubbleid{
            return parentBubble
        }else{
            return Bubble(id: bubbleid, name: "notSelected", color: UIColor.black)
            
        }
        
    }
    */
    func getChildBubbleRadius()->Int{
        return CHILD_BUBBLE_RADIUS
    }
    func getParentBubbleRadius()->Int{
        return PARENT_BUBBLE_RADIUS
    }
    
    var fetchIndex = 0
    /*func getNextColor()->UIColor{
        if fetchIndex > UIColor.bubbleColors.count{
            assertionFailure("index out of range")
        }
        let color = UIColor.bubbleColors[fetchIndex]
        fetchIndex += 1
        if(fetchIndex>19){
            fetchIndex = 0
        }
        return color
    }*/
    
    func getShortName(name:String)->String{
        let bubble_name = self.getNodeNames(nameString: name)
        return bubble_name.shortName
    }
}
/* SAN Commented on 27-02-2020
class ColorsForBubbles{
    var fetchIndex = 0
    init(){
        fetchIndex = 0
    }
    func getColor(index:Int)->UIColor{
        if index>UIColor.bubbleColors.count{
            assertionFailure("index out of range")
        }
        return UIColor.bubbleColors[index]
    }
    func getNextColor()->UIColor{
        if fetchIndex > UIColor.bubbleColors.count{
            assertionFailure("index out of range")
        }
        let color = UIColor.bubbleColors[fetchIndex]
        fetchIndex += 1
        return color
    }
}
*/
