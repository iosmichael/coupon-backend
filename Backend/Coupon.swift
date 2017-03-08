//
//  Coupon.swift
//  Backend
//
//  Created by Michael Liu on 3/7/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit
import Firebase

class Coupon: NSObject {
    var couponId:String!
    var name:String!
    var detail:String!
    var store:Item?
    var date: String!
    
    var ref: FIRDatabaseReference? = FIRDatabase.database().reference()
    
    func postData(name:String,detail:String, store:Item){
        self.name = name
        self.detail = detail
        self.store = store
        writeCoupon()
    }
    
    func writeCoupon(){
        let childNode = ref?.child("coupons").childByAutoId()
        //#warning - Need dates! here!
        let currentDate: Date = Date()
        let dateString: String = currentDate.convertDateToString()
        let posts = ["name":name!, "detail":detail!, "date":dateString, "storeId":(store?.itemId)!, "storeName":(store?.name)!, "storeThumbnail":(store?.thumbnail)!] as [String : Any]
        print("post data here: ------>\(posts)")
        childNode?.updateChildValues(posts)
    }
    
    func deleteCoupon(couponId:String){
        let itemsNode = ref?.child("coupons").child(couponId)
        itemsNode?.removeValue()
    }
    
}
