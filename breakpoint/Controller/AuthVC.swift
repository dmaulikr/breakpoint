//
//  AuthVC.swift
//  breakpoint
//
//  Created by Roger on 28/08/17.
//  Copyright © 2017 Decodely. All rights reserved.
//

import UIKit
import Firebase

class AuthVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)

		if Auth.auth().currentUser != nil{
			dismiss(animated: true, completion: nil)
		}
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
	@IBAction func signInWithEmailBtnPressed(_ sender: UIButton) {
		let loginVC = storyboard?.instantiateViewController(withIdentifier: "loginVC")
		present(loginVC!, animated: true, completion: nil)
	}

	@IBAction func fbSignInBtnPressed(_ sender: UIButton) {
	}
	
	@IBAction func googleSignInBtnPressed(_ sender: UIButton) {
	}
}
