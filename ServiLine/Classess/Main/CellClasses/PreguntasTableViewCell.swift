//
//  PreguntasTableViewCell.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 14/12/22.
//

import UIKit

class PreguntasTableViewCell: UITableViewCell {
    
    @IBOutlet var imgVw: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var lblTimeAgo: UILabel!
    @IBOutlet var lblHeading: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
