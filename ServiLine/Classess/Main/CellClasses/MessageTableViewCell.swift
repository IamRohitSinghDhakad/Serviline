//
//  MessageTableViewCell.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 12/03/22.
//

import UIKit

class MessageTableViewCell: UITableViewCell {

    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblMsg: UILabel!
    @IBOutlet var lblTimeAgo: UILabel!
    @IBOutlet var imgVwCheckUncheck: UIImageView!
    @IBOutlet var vwCheckUncheck: UIView!
    @IBOutlet var lblMsgCount: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblMsgCount.layer.cornerRadius = self.lblMsgCount.frame.width/2
        self.lblMsgCount.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


