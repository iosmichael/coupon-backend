//
//  Manager.swift
//  Backend
//
//  Created by Michael Liu on 3/7/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit
import Firebase

class Manager: NSObject {
    var storeRef:FIRDatabaseReference?
    var couponRef:FIRDatabaseReference?
    
    override init() {
        super.init()
        storeRef = FIRDatabase.database().reference().child("stores")
        couponRef = FIRDatabase.database().reference().child("coupons")
    }
    
    func queryNewStores(limit:Int)->FIRDatabaseQuery{
        return (storeRef?.queryLimited(toLast: UInt(limit)))!
    }
    
    func queryStoresBySearchStr(limit:Int, query:String)->FIRDatabaseQuery{
        return (storeRef?.queryLimited(toLast: UInt(limit)).queryOrdered(byChild: "name").queryStarting(atValue: query))!
    }
    
    func queryNewCoupons(limit:Int)->FIRDatabaseQuery{
        return (couponRef?.queryLimited(toLast: UInt(limit)))!
    }
    
    func queryCouponsBySearchStr(limit:Int, query:String)->FIRDatabaseQuery{
        return (couponRef?.queryLimited(toLast: UInt(limit)).queryOrdered(byChild: "name").queryStarting(atValue: query))!
    }
    
    public func getStores(snapshot:FIRDataSnapshot)->[Item]{
        var stores = [Item]()
        for child:FIRDataSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot]{
            let store = Item()
            store.itemId = child.key
            print("snapshot --------> \(snapshot)")
            print("child --------> \(child)")
            for elem:FIRDataSnapshot in child.children.allObjects as! [FIRDataSnapshot]{
                switch elem.key {
                case "name":
                    store.name = elem.value as! String!
                    break
                case "detail":
                    store.detail = elem.value as! String!
                    break
                case "thumbnail":
                    store.thumbnail = elem.value as! String!
                    break
                case "images":
                    for url in elem.value as! [String:String] {
                        store.imagesURL.insert(url.value, at: 0)
                    }
                    break
                case  "date":
                    store.date = elem.value as! String!
                    break
                case "tags":
                    break
                default:
                    break
                }
            }
            stores.append(store)
        }
        return stores
    }
    
    public func getCoupons(snapshot:FIRDataSnapshot)->[Coupon]{
        var items = [Coupon]()
        for child:FIRDataSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot]{
            let item = Coupon()
            let store = Item()
            item.couponId = child.key
            print("snapshot --------> \(snapshot)")
            print("child --------> \(child)")
            for elem:FIRDataSnapshot in child.children.allObjects as! [FIRDataSnapshot]{
                switch elem.key {
                case "name":
                    item.name = elem.value as! String!
                    break
                case "storeId":
                    store.itemId = elem.value as! String!
                    break
                case "storeName":
                    store.name = elem.value as! String!
                    break
                case "storeThumbnail":
                    store.thumbnail = elem.value as! String!
                    break
                case "detail":
                    item.detail = elem.value as! String!
                    break
                case  "date":
                    item.date = elem.value as! String!
                    break
                case "tags":
                    break
                default:
                    break
                }
            }
            item.store = store
            items.append(item)
        }
        return items
    }


}
