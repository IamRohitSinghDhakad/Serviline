//
//  PreguntasChatListTableViewCell.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 17/12/22.
//

import UIKit

class PreguntasChatListTableViewCell: UITableViewCell {
    
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblTimeAgo: UILabel!
    @IBOutlet var lblMsg: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
