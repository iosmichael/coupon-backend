//
//  Store.swift
//  Proxitude
//
//  Created by Michael Liu on 11/25/16.
//  Copyright © 2016 Michael Liu. All rights reserved.
//

import UIKit
import Firebase

class Store: NSObject {
    let storageURL = "gs://coupon-6f01b.appspot.com/"
    var itemId:String!
    var name:String!
    var detail:String!
    var date: String!
    var thumbnail:String!
    var thumbnailImg: UIImage!
    
    var latitude:Float?
    var longtitude:Float?
    var website:String!
    var category:String?
    
    var imagesURL = [String]()
    
    //below for post
    var tags = [String]()
    var images = [UIImage]()
    var ref: FIRDatabaseReference? = FIRDatabase.database().reference()
    var storageRef: FIRStorageReference?
    
    
    
    func postData(name:String,detail:String,tags:[String],images:[UIImage], latitude:String, longitude:String, website:String){
        self.name = name
        self.detail = detail
        self.tags = tags
        self.website = website
        self.images = images
        
        if Float(latitude) != nil {
            self.latitude = Float(latitude)
        }
        if Float(longitude) != nil {
            self.longtitude = Float(longitude)
        }
        writeItem()
    }
    
    func readData(itemId:String){
        let dataNode = ref?.child("stores").value(forKey: itemId)
        print("\(dataNode)")
    }
    
    func writeItem(){
        storageRef = FIRStorage.storage().reference(forURL: storageURL)
        let itemsNode = ref?.child("stores").childByAutoId()
        
        let autoId = itemsNode?.key
    
        let screenWidth = UIScreen.main.bounds.width
        let sqrThumbnailImage = UIImage.cropToBounds(image: images[0], width: Double(screenWidth), height: Double(screenWidth))
        let thumbnailImg = sqrThumbnailImage.resizeWith(width: 70)
        let thumbnailData = UIImageJPEGRepresentation(thumbnailImg!, 0.2)
        let thumbnailRef = storageRef?.child("images/\(autoId)-image-thumbnail.jpg")
        let thumbMetaData = FIRStorageMetadata()
        thumbMetaData.contentType = "image/jpg"
        thumbnailRef?.put(thumbnailData!, metadata: thumbMetaData){ metadata, error in
            if (error != nil) {
                print(error!)
                // Uh-oh, an error occurred!
            }
            let downloadURL:String = (metadata!.downloadURL()?.absoluteString)!
            itemsNode?.child("thumbnail").setValue("\(downloadURL)")
        }
        
        for i in 0...images.count-1{
            let sqrImage = UIImage.cropToBounds(image: images[i], width: Double(screenWidth), height: Double(screenWidth))
            let smImage = sqrImage.resizeWith(width: screenWidth)
            let data = UIImageJPEGRepresentation(smImage!, 0.5)
            let picRef = storageRef?.child("images/\(autoId)-image-\(i).jpg")
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpg"
            picRef?.put(data!, metadata: metaData) { metadata, error in
                if (error != nil) {
                    print(error!)
                    // Uh-oh, an error occurred!
                }
                let downloadURL:String = (metadata!.downloadURL()?.absoluteString)!
                // Metadata contains file metadata such as size, content-type, and download URL.
                itemsNode?.child("images/image-\(i)").setValue("\(downloadURL)")
            }
        }
        //#warning - Need dates! here!
        let currentDate: Date = Date()
        let dateString: String = currentDate.convertDateToString()
        let categoryStr: String = tags.joined(separator: ", ")
        var posts:[String : Any]?
        if latitude != nil && longtitude != nil {
            posts = ["name":name!, "detail":detail!, "date":dateString, "category":categoryStr, "latitude":latitude!, "longtitude":longtitude!, "website":website] as [String : Any]
        }else{
            posts = ["name":name!, "detail":detail!, "date":dateString, "category":categoryStr, "website":website] as [String : Any]
        }
        itemsNode?.updateChildValues(posts!)
        for tag in tags{
            //category links
            itemsNode?.updateChildValues([tag:"1"])
        }
    }
    
    
    func deleteStore(storeId:String){
        let itemsNode = ref?.child("stores").child(storeId)
        itemsNode?.removeValue()
        //delete all the coupons
        let couponNode = ref?.child("coupons").queryOrdered(byChild: "storeId").queryEqual(toValue: storeId)
        couponNode?.observe(.value, with: { (snapshot) in
            for child:FIRDataSnapshot in snapshot.children.allObjects as! [FIRDataSnapshot]{
                self.ref?.child("coupons").child(child.key).removeValue()
            }
        })
    }
    
    
}

extension Date{
    func convertDateToString()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: self)
    }
    
    func convertDateToDueDateString()->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
    
    func convertStringToDate(date:String)->Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.date(from: date)!
    }
}


extension UIImage{
    
    public func resizeWith(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    class func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {
        
        let contextImage: UIImage = UIImage.init(cgImage: image.cgImage!)
        
        let contextSize: CGSize = contextImage.size
        
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)
        
        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }
        let rect: CGRect = CGRect.init(x: posX, y: posY, width: cgwidth, height: cgheight)
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        return image
    }
}
