//
//  StoreTableViewCell.swift
//  CouponApp
//
//  Created by Michael Liu on 3/5/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class StoreTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var category: UILabel!
    @IBOutlet weak var storeTitle: UILabel!
    static let height:CGFloat = 50
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    func setStore(store:Item){
        self.storeTitle.text = store.name
        self.category.text = "Category"
        if store.thumbnailImg == nil{
            self.thumbnail.image = UIImage.init(named: "test-item")
        }else{
            self.thumbnail.image = store.thumbnailImg
            //downloadImage(imageURL: item.thumbnail!)
        }
    }
    
    func setThumbnailImage(image:UIImage){
        self.thumbnail.image = image
        self.setNeedsLayout()
    }
    

    
    class func getHeight() -> CGFloat{
        return height
    }
}
