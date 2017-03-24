//
//  PostMessageViewController.swift
//  Backend
//
//  Created by Michael Liu on 3/15/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class PostMessageViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    enum cellType{
        case LL
        case LI
    }
    @IBOutlet weak var tableView: UITableView!
    
    var list = [(cellType.LI, "Title", "e.g "),
                (cellType.LL, "Detail", "Required")]
    var messageDetail: String = ""
    var messageTitle: UITextField?
    let detailIndex = 1
    let customListCellHeight:CGFloat = 44
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "ListCell")
        self.setupNav()
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
        let cell:CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! CustomTableViewCell
        cell.selectionStyle = .none
        let (type,L1,L2) = list[indexPath.row]
        fill(cell: cell,type: type,L1: L1,L2: L2)
        if indexPath.row == 0{
            messageTitle = cell.rightInput
        }
        return cell
        
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
            let detailController = MessageDetailController()
            detailController.parentC = self
            navigationController?.pushViewController(detailController, animated: true)
        }
    }
    
    func fillDetail(detail:String){
        list[detailIndex] = (cellType.LL,"Detail",detail)
        self.messageDetail = detail
        self.tableView.reloadData()
    }
    
    func setupNav(){
        navigationController?.navigationBar.barTintColor = UIColor.init(hex: "525659")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:UIFont.italicSystemFont(ofSize: 17)]
        let navRightBtn = UIBarButtonItem.init(image: UIImage.init(named:"check"),style:.plain, target: self, action: #selector(submit))
        navigationItem.rightBarButtonItem = navRightBtn
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    func submit(){
        if !validate(){
            print("fields input incorrect!")
            return
        }
        
        Message().postMessage(messageTitle: (self.messageTitle?.text)!, messageContent: self.messageDetail)
        //post messages
        self.navigationController?.popViewController(animated: true)
    }
    
    func validate()->Bool{
        //validate
        if messageDetail == "" || (messageTitle?.text?.isEmpty)!{
            return false
        }
        return true
    }
    
    func fill(cell:CustomTableViewCell,type:cellType, L1:String, L2:String){
        switch type {
        case .LL:
            cell.fillLL(labelStr: L1, inputStr: L2)
            break;
        case .LI:
            cell.fillLI(labelStr: L1, inputStr: L2)
            break;
        }
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


class MessageDetailController:UIViewController{
    
    var detail: String?
    var textView: UITextView?
    weak var parentC: PostMessageViewController?
    let leftMargin:CGFloat = 20
    let topMargin:CGFloat = 10
    
    override func viewDidLoad() {
        let contentView:CGRect = self.view.frame
        textView = UITextView.init(frame:CGRect.init(x: leftMargin, y: topMargin, width: contentView.width-2*leftMargin, height: contentView.height-2*topMargin))
        textView?.layer.borderWidth = 0
        textView?.backgroundColor = UIColor.white
        textView?.font = UIFont.init(name: "HelveticaNeue", size: 18)
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.view.addSubview(textView!)
        setupNav()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupNav(){
        let navLeftBtn = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(dismissCurrent))
        navigationItem.leftBarButtonItem = navLeftBtn
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        navigationItem.title = "Description"
    }
    
    func dismissCurrent(){
        parentC?.fillDetail(detail: (textView?.text)!)
        self.navigationController?.popViewController(animated: true)
    }
    
}
