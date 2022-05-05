//
//  MessageCell.swift
//  Flash Chat iOS13
//
//  Created by JPL-ST-SPRING2022 on 5/4/22.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messsageBubble: UIView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var leftImageView: UIImageView!
    
    //    this will be called during creation of mesasge cell
    override func awakeFromNib() {
        super.awakeFromNib()
        messsageBubble.layer.cornerRadius = messsageBubble.frame.height / 5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
