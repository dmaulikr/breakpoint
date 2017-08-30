//
//  FeedCell.swift
//  breakpoint
//
//  Created by Roger on 28/08/17.
//  Copyright © 2017 Decodely. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {

	@IBOutlet weak var profileImage: UIImageView!
	@IBOutlet weak var emailLbl: UILabel!
	@IBOutlet weak var contentLbl: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

	func configureCell(profileImage: UIImage, email: String, content: String){
		self.profileImage.image = profileImage
		self.emailLbl.text = email
		self.contentLbl.text = content
	}

}
