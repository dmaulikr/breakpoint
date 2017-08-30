//
//  User.swift
//  breakpoint
//
//  Created by Roger on 29/08/17.
//  Copyright © 2017 Decodely. All rights reserved.
//

import Foundation

class User{
	private var _userId: String
	private var _email: String
	private var _profileImage: String

	var userId: String{
		return _userId
	}

	var email: String{
		return _email
	}

	var profileImage: String{
		return _profileImage
	}

	init(userId: String, email: String, profileImage: String){
		self._userId = userId
		self._email = email
		self._profileImage = profileImage
	}
}
