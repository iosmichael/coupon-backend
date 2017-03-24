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
    var messageRef:FIRDatabaseReference?
    
    override init() {
        super.init()
        storeRef = FIRDatabase.database().reference().child("stores")
        couponRef = FIRDatabase.database().reference().child("coupons")
        messageRef = FIRDatabase.database().reference().child("messages")
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
    
    func queryNewMessages()->FIRDatabaseQuery{
        return (messageRef?.queryOrdered(byChild: "date"))!
    }
    
    public func getStores(snapshot:FIRDataSnapshot)->[Store]{
        var stores = [Store]()
        for child:FIRDataSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot]{
            let store = Store()
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
                        store.imagesURL.append(url.value)
                    }
                    break
                case  "date":
                    store.date = elem.value as! String!
                    break
                case "category":
                    store.category = elem.value as! String!
                    break
                case "latitude":
                    store.latitude = elem.value as! Float!
                    break
                case "longtitude":
                    store.longtitude = elem.value as! Float!
                    break
                case "website":
                    store.website = elem.value as! String!
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
            let store = Store()
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
    
    public func getMessages(snapshot:FIRDataSnapshot)->[Message]{
        var messages = [Message]()
        for child:FIRDataSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot]{
            let message = Message()
            message.messageId = child.key
            print("snapshot --------> \(snapshot)")
            print("child --------> \(child)")
            for elem:FIRDataSnapshot in child.children.allObjects as! [FIRDataSnapshot]{
                switch elem.key {
                case "title":
                    message.title = elem.value as! String!
                    break
                case "detail":
                    message.content = elem.value as! String!
                    break
                case  "date":
                    message.date = elem.value as! String!
                    break
                default:
                    break
                }
            }
            messages.append(message)
        }
        return messages
    }



}
