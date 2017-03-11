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
    var store:Store?
    var date: String!
    var hours: Double!
    var bannerImage:UIImage?
    
    var ref: FIRDatabaseReference? = FIRDatabase.database().reference()
    
    func postData(name:String,detail:String, store:Store, hours:Double){
        self.name = name
        self.detail = detail
        self.store = store
        self.hours = hours
        writeCoupon()
    }
    
    func postData(name:String,detail:String, store:Store, bannerImage:UIImage, hours:Double){
        self.name = name
        self.detail = detail
        self.store = store
        self.bannerImage = bannerImage
        self.hours = hours
        writeCoupon()
    }
    
    func writeCoupon(){
        let childNode = ref?.child("coupons").childByAutoId()
        //#warning - Need dates! here!
        let currentDate: Date = Date()
        let dueDate: Date = currentDate.addingTimeInterval(self.hours * 60 * 60)
        let dateString: String = currentDate.convertDateToString()
        let dueString: String = dueDate.convertDateToDueDateString()
        let posts = ["name":name!, "detail":detail!, "date":dateString,"due": dueString, "storeId":(store?.itemId)!, "storeName":(store?.name)!, "storeThumbnail":(store?.thumbnail)!, "storeDetail": (store?.detail)!, "images": (store?.imagesURL)!, "storeLatitude":store?.latitude, "storeLongtitude": store?.longtitude, "category":store?.category, "website":store?.website] as [String : Any]
        if self.bannerImage != nil {
            let screenWidth = UIScreen.main.bounds.width
            let sqrImage = UIImage.cropToBounds(image: self.bannerImage!, width: Double(screenWidth), height: Double(screenWidth) / 375 * 163)
            let smImage = sqrImage.resizeWith(width: screenWidth)
            let data = UIImageJPEGRepresentation(smImage!, 0.5)
            let picRef = FIRStorage.storage().reference().child("banners/\(childNode?.key)-banner.jpg")
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpg"
            picRef.put(data!, metadata: metaData) { metadata, error in
                if (error != nil) {
                    print(error!)
                    // Uh-oh, an error occurred!
                }
                let downloadURL:String = (metadata!.downloadURL()?.absoluteString)!
                // Metadata contains file metadata such as size, content-type, and download URL.
                childNode?.child("bannerImage").setValue("\(downloadURL)")
                childNode?.child("isBanner").setValue(1)
            }
        }
        childNode?.updateChildValues(posts)
    }
    
    func deleteCoupon(couponId:String){
        let itemsNode = ref?.child("coupons").child(couponId)
        let archiveNode = ref?.child("histories")
        itemsNode?.observe(.value, with: { (snapshot) in
            let childNode = archiveNode?.childByAutoId().key
            archiveNode?.updateChildValues([childNode!:snapshot.value!])
            itemsNode?.removeValue()
        })
        
    }
    
}
