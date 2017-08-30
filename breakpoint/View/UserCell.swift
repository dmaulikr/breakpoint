//
//  UsersCell.swift
//  breakpoint
//
//  Created by Roger on 29/08/17.
//  Copyright © 2017 Decodely. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

	@IBOutlet weak var profileImage: UIImageView!
	@IBOutlet weak var emailLbl: UILabel!
	@IBOutlet weak var checkMarkBtn: UIImageView!

	var isShowing = false

	override func awakeFromNib() {
		super.awakeFromNib()
	}

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

		if selected {
			self.checkMarkBtn.isHidden = false
		} else {
			self.checkMarkBtn.isHidden = true
		}
    }



	func configureCell(profileImage image: UIImage, email: String, isSelected: Bool ){
		self.profileImage.image = image
		self.emailLbl.text = email

		if isSelected {
			if isShowing == false {
				isShowing = true
				self.checkMarkBtn.isHidden = false
			}  else {
				isShowing = false
				self.checkMarkBtn.isHidden = true
			}
		}
	}
}
