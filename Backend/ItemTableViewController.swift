//
//  ItemTableViewController.swift
//  Backend
//
//  Created by Michael Liu on 3/7/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class ItemTableViewController: UITableViewController {
    
    var data:[Coupon] = []
    let initialQueryLimits = 200

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "ItemTableViewCell", bundle: nil), forCellReuseIdentifier: "coupon")
        setupData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "coupon", for: indexPath) as! ItemTableViewCell
        let coupon = data[indexPath.row]
        cell.setCoupon(coupon: coupon)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return ItemTableViewCell.getHeight()
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let coupon = data[indexPath.row]
        let couponCell: ItemTableViewCell = cell as! ItemTableViewCell
        if coupon.store?.thumbnail != nil {
            DispatchQueue.global().async {
                if let url = NSURL(string: (coupon.store?.thumbnail)!) {
                    if let data = NSData(contentsOf: url as URL) {
                        let thumbnailImg = UIImage.init(data: data as Data!)
                        coupon.store?.thumbnailImg = thumbnailImg
                        DispatchQueue.main.async {
                            couponCell.setThumbnailImage(image: thumbnailImg!)
                        }
                    }
                }
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction  = UITableViewRowAction(style: .default, title: "Delete") { (rowAction, indexPath) in
            let coupon = self.data[indexPath.row]
            coupon.deleteCoupon(couponId: coupon.couponId)
        }
        deleteAction.backgroundColor = UIColor.red
        return [deleteAction]
    }

    func setupData(){
        let manager = Manager()
        manager.queryNewCoupons(limit: initialQueryLimits).observe(.value, with: { (snapshot) in
            self.data = manager.getCoupons(snapshot: snapshot)
            self.tableView.reloadData()
        })
    }
}
