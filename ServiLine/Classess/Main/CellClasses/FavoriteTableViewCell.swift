//
//  FavoriteTableViewCell.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 27/03/22.
//

import UIKit

class FavoriteTableViewCell: UITableViewCell {
    
    @IBOutlet var imgVwUser: UIImageView!
    @IBOutlet var lblUserName: UILabel!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var btnRemove: UIButton!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
