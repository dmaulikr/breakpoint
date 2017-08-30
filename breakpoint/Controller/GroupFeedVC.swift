//
//  GroupFeedVC.swift
//  breakpoint
//
//  Created by Roger on 29/08/17.
//  Copyright © 2017 Decodely. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupTitle: UILabel!
    
    @IBOutlet weak var membersLbl: UILabel!
    @IBOutlet weak var sendView: UIView!
    @IBOutlet weak var messageTF: insetTextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    var groupMessages = [Message]()
    
    var group: Group?
    
    func initData(forGroup group: Group){
        self.group = group
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        sendView.bindToKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        groupTitle.text = group?.title
        DataService.instance.getEmails(forGroup: group!) { (returnedEmails) in
            self.membersLbl.text = returnedEmails.joined(separator: ", ")
        }
        
        DataService.instance.REF_GROUPS.observeSingleEvent(of: .value) { (snapshot) in
            DataService.instance.getAllMessages(forGroup: self.group!, handler: { (returnedGroupMessages) in
                self.groupMessages = returnedGroupMessages
                self.tableView.reloadData()
                
                if self.groupMessages.count > 0 {
                    self.tableView.scrollToRow(at: IndexPath(row: self.groupMessages.count - 1, section: 0), at: .none, animated: true)
                }
            })
        }
        
    }
    
    @IBAction func backBtnPressed(_ sender: UIButton) {
        dismissDetail()
        
    }
    @IBAction func sendBtnPressed(_ sender: UIButton) {
        
        if messageTF.text != "" {
            messageTF.isEnabled = false
            sendBtn.isEnabled = false
            
            DataService.instance.uploadPost(withMessage: self.messageTF.text!, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: self.group?.uid, sendComplete: { (complete) in
                if complete{
                    self.messageTF.isEnabled = true
                    self.sendBtn.isEnabled = true
                    
                    self.messageTF.text = ""
                }
            })
        }
    }
    

}

extension GroupFeedVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessages.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupFeedCell", for: indexPath) as? groupFeedCell else { return UITableViewCell() }
        
        let message = groupMessages[indexPath.row]
        let image = UIImage(named: "defaultProfileImage")
        
        DataService.instance.getUsername(forUID: message.senderId) { (email	) in
        	cell.configureCell(profileImage: image!, email: email, content: message.content)
        }
        return cell
    }
}
