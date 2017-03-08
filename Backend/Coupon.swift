//
//  Coupon.swift
//  Backend
//
//  Created by Michael Liu on 3/7/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class Coupon: NSObject {
    var couponId:String!
    var name:String!
    var detail:String!
    var storeId:String!
    var date: String!
    
    func postData(type:Bool, name:String,detail:String,storeId:String){
        self.name = name
        self.detail = detail
        self.storeId = storeId
        writeCoupon()
    }
    
    func writeCoupon(){
        
    }
    
}
