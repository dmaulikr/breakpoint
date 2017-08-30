//
//  PostVC.swift
//  breakpoint
//
//  Created by Roger on 28/08/17.
//  Copyright © 2017 Decodely. All rights reserved.
//

import UIKit
import Firebase

class CreatePostVC: UIViewController {

	@IBOutlet weak var profileImage: UIImageView!
	@IBOutlet weak var emailLbl: UILabel!
	@IBOutlet weak var textView: UITextView!
	@IBOutlet weak var sendBtn: UIButton!

	override func viewDidLoad() {
        super.viewDidLoad()

        textView.delegate = self
		sendBtn.bindToKeyboard()
    }

	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		setupView()
	}
	
	func setupView(){
		self.emailLbl.text = Auth.auth().currentUser?.email
	}

	@IBAction func sendPostBtnPressed(_ sender: UIButton) {
		if textView.text != nil && textView.text != "say something here" {
			sendBtn.isEnabled = false
			DataService.instance.uploadPost(withMessage: textView.text!, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: nil, sendComplete: { (isComplete) in
				if isComplete{
					self.sendBtn.isEnabled = true
					self.dismiss(animated: true, completion: nil)
				} else {
					self.sendBtn.isEnabled = true
					print("There was an error while posting!")
				}
			})
		}
	}

	@IBAction func closeBtnPressed(_ sender: UIButton) {
		dismiss(animated: true, completion: nil)
	}
}

extension CreatePostVC: UITextViewDelegate {
	func textViewDidBeginEditing(_ textView: UITextView) {
		textView.text = ""
	}
}
