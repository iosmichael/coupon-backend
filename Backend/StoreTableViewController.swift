//
//  StoreTableViewController.swift
//  Backend
//
//  Created by Michael Liu on 3/7/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit
import Firebase

class StoreTableViewController: UITableViewController {
    
    var data:[Store] = []
    let initialQueryLimits = 200

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(UINib.init(nibName: "StoreTableViewCell", bundle: nil), forCellReuseIdentifier: "store")
        setupNav()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "store", for: indexPath) as! StoreTableViewCell
        let store = data[indexPath.row]
        cell.setStore(store: store)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return StoreTableViewCell.getHeight()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let postCoupon = storyboard.instantiateViewController(withIdentifier: "coupon") as! PostCouponViewController
        postCoupon.store = data[indexPath.row]
        self.navigationController?.pushViewController(postCoupon, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            let store = data[indexPath.row]
            let storeCell: StoreTableViewCell = cell as! StoreTableViewCell
            if store.thumbnail != nil {
                DispatchQueue.global().async {
                    if let url = NSURL(string: store.thumbnail) {
                        if let data = NSData(contentsOf: url as URL) {
                            let thumbnailImg = UIImage.init(data: data as Data!)
                            store.thumbnailImg = thumbnailImg
                            DispatchQueue.main.async {
                                storeCell.setThumbnailImage(image: thumbnailImg!)
                            }
                        }
                    }
                }
            }
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction  = UITableViewRowAction(style: .default, title: "Delete") { (rowAction, indexPath) in
            let store = self.data[indexPath.row]
            store.deleteStore(storeId: store.itemId)
        }
        deleteAction.backgroundColor = UIColor.red
        return [deleteAction]
    }

    
    //data
    func setupData(){
        let manager = Manager()
        manager.queryNewStores(limit: initialQueryLimits).observe(.value, with: { (snapshot) in
            let stores = manager.getStores(snapshot: snapshot)
            self.data = stores
            self.tableView.reloadData()
        })
    }
    
    func setupNav(){
        navigationController?.navigationBar.barTintColor = UIColor.init(hex: "525659")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:UIFont.italicSystemFont(ofSize: 17)]
        let navRightBtn = UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(post))
        navigationItem.rightBarButtonItem = navRightBtn
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    func post(){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let postStore = storyboard.instantiateViewController(withIdentifier: "store") as! PostItemViewController
        self.navigationController?.pushViewController(postStore, animated: true)
    }
}
