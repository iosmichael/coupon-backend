//
//  ItemTableViewCell.swift
//  CouponApp
//
//  Created by Michael Liu on 3/5/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    static let height:CGFloat = 72
    
    @IBOutlet weak var couponName: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var storeName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCoupon(coupon:Coupon){
        self.storeName.text = coupon.store?.name
        self.couponName.text = coupon.name
        if coupon.store?.thumbnailImg == nil{
            self.thumbnail.image = UIImage.init(named: "amazon")
        }else{
            self.thumbnail.image = coupon.store?.thumbnailImg
            //downloadImage(imageURL: item.thumbnail!)
        }
    }
    
    func setThumbnailImage(image:UIImage){
        self.thumbnail.image = image
        self.setNeedsLayout()
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    class func getHeight()->CGFloat{
        return height
    }
    
}
