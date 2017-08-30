//
//  CreateGroupVC.swift
//  breakpoint
//
//  Created by Roger on 29/08/17.
//  Copyright © 2017 Decodely. All rights reserved.
//

import UIKit
import Firebase

class CreateGroupVC: UIViewController {

	@IBOutlet weak var titleTF: insetTextField!
	@IBOutlet weak var descriptionTF: insetTextField!
	@IBOutlet weak var peopleTF: insetTextField!
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var doneBtn: UIButton!
	@IBOutlet weak var groupMembersLbl: UILabel!

	var emailArray = [String]()
	var chosenUserArray = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()

		tableView.delegate = self
		tableView.dataSource = self

		peopleTF.delegate = self
		peopleTF.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

	override func viewWillAppear(_ animated: Bool) {
		doneBtn.isHidden = true
	}

	@objc func textFieldDidChange(){
		if peopleTF.text == "" {
			emailArray = []
			tableView.reloadData()
		} else {
			DataService.instance.getEmail(forSearchQuery: peopleTF.text!, handler: { (returnedEmailArray) in
				self.emailArray = returnedEmailArray
				self.tableView.reloadData()
			})
		}
	}

	@IBAction func closeBtnPressed(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}

	@IBAction func doneBtnPressed(_ sender: UIButton) {
		if titleTF.text != "" && descriptionTF.text != "" {
			DataService.instance.getIds(forUsernames: chosenUserArray, handler: { (returnedIdsArray) in
				var userIds = returnedIdsArray
				userIds.append((Auth.auth().currentUser?.uid)!)

				DataService.instance.createGroup(withTitle: self.titleTF.text!, andDescription: self.descriptionTF.text!, forUsersIds: userIds, handler: { (groupCreated) in
					if groupCreated {
						self.dismiss(animated: true, completion: nil)
					} else {
						print("Error while creating group")
					}
				})
			})
		}
	}

}

extension CreateGroupVC: UITableViewDelegate, UITableViewDataSource {
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}

	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return emailArray.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else { return UITableViewCell() }

		let email = emailArray[indexPath.row]
		let image = UIImage.init(named: "defaultProfileImage")

		if chosenUserArray.contains(emailArray[indexPath.row]) {
			cell.configureCell(profileImage: image!, email: email, isSelected: true)
		} else {
			cell.configureCell(profileImage: image!, email: email, isSelected: false)
		}

		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else { return }

		if !chosenUserArray.contains(cell.emailLbl.text!) {
			chosenUserArray.append(cell.emailLbl.text!)
			groupMembersLbl.text = chosenUserArray.joined(separator: ", ")
			self.doneBtn.isHidden = false
		} else {
			chosenUserArray = chosenUserArray.filter({ $0 != cell.emailLbl.text! })
			if chosenUserArray.count >= 1 {
				groupMembersLbl.text = chosenUserArray.joined(separator: ", ")
			} else {
				groupMembersLbl.text = "add people to your group"
				self.doneBtn.isHidden = true
			}
		}
	}
}

extension CreateGroupVC: UITextFieldDelegate {}
