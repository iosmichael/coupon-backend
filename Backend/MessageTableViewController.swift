//
//  MessageTableViewController.swift
//  Backend
//
//  Created by Michael Liu on 3/22/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit

class MessageTableViewController: UITableViewController {
    
    var messages:[Message] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        setupNav()
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "message")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messages.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: "message")
        cell.detailTextLabel?.text = messages[indexPath.row].content
        cell.textLabel?.text = messages[indexPath.row].title
        return cell
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction  = UITableViewRowAction(style: .default, title: "Delete") { (rowAction, indexPath) in
            let message = self.messages[indexPath.row]
            message.deleteMessage(messageId: message.messageId)
        }
        deleteAction.backgroundColor = UIColor.red
        return [deleteAction]
    }

    func setupData(){
        let manager = Manager()
        manager.queryNewMessages().observe(.value, with: { (snapshot) in
            let messages = manager.getMessages(snapshot: snapshot)
            self.messages = messages
            self.tableView.reloadData()
        })
    }
    
    func post(){
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let postMessage = storyboard.instantiateViewController(withIdentifier: "postMessage") as! PostMessageViewController
        self.navigationController?.pushViewController(postMessage, animated: true)
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
}
