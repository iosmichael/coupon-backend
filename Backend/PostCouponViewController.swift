//
//  PostCouponViewController.swift
//  Backend
//
//  Created by Michael Liu on 3/7/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class PostCouponViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    enum cellType{
        case LL
        case LI
    }
    
    let detailIndex = 1
    let customListCellHeight:CGFloat = 44
    
    var list = [(cellType.LI, "Title", "e.g "),
                (cellType.LL, "Detail", "Required"),
                (cellType.LL, "Store Name", "store")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return customListCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == detailIndex{
            //push detail controller
        }
        
    }
    
    func setupNav(){
        navigationController?.navigationBar.barTintColor = UIColor.init(hex: "525659")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:UIFont.italicSystemFont(ofSize: 17)]
        let navRightBtn = UIBarButtonItem.init(image: UIImage.init(named:"check"),style:.plain, target: self, action: #selector(submit))
        let navLeftBtn = UIBarButtonItem.init(image: UIImage.init(named: "close"), style: .plain, target: self, action: #selector(cancel))
        navigationItem.rightBarButtonItem = navRightBtn
        navigationItem.leftBarButtonItem = navLeftBtn
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    func submit(){
        
    }
    
    func cancel(){
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
