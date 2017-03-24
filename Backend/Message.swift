//
//  Message.swift
//  Backend
//
//  Created by Michael Liu on 3/22/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var messageId:String!
    var title:String!
    var content:String!
    var date: String!
    
    func postMessage(messageTitle:String, messageContent:String){
        let childNode = FIRDatabase.database().reference().child("messages").childByAutoId()
        //#warning - Need dates! here!
        let currentDate: Date = Date()
        let dateString: String = currentDate.convertDateToString()
        let posts = ["title":messageTitle, "content":messageContent, "date":dateString] as [String : Any]
        childNode.updateChildValues(posts)
    }
    
    func deleteMessage(messageId:String){
        let messageNode = FIRDatabase.database().reference().child("messages").child(messageId)
        messageNode.removeValue()
    }

}
