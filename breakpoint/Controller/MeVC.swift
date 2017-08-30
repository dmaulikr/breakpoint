//
//  MeVC.swift
//  breakpoint
//
//  Created by Roger on 28/08/17.
//  Copyright © 2017 Decodely. All rights reserved.
//

import UIKit
import Firebase

class MeVC: UIViewController {

	@IBOutlet weak var profileImage: UIImageView!
	@IBOutlet weak var emailLbl: UILabel!
	@IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupView()
	}

	func setupView(){
		self.emailLbl.text = Auth.auth().currentUser?.email
	}


	@IBAction func signOutBtnPressed(_ sender: UIButton) {

		let logOutPopup = UIAlertController(title: "Logout?", message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
		let logoutAction = UIAlertAction(title: "Logout", style: .destructive, handler: { (buttonTapped) in
			AuthService.instance.signOut { (succcess) in
				if succcess{
					let authVC = self.storyboard?.instantiateViewController(withIdentifier: "authVC")
					self.present(authVC!, animated: true, completion: nil)
				} else {
					return
				}
			}
		})
		let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

		logOutPopup.addAction(logoutAction)
		logOutPopup.addAction(cancelAction)

		present(logOutPopup, animated: true, completion: nil)
	}
}
