//
//  ToDoTableViewCell.swift
//  ToDoList
//
//  Created by shubham Garg on 29/07/20.
//  Copyright © 2020 shubham Garg. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
    @IBOutlet weak var taskNameLbl: UILabel!
    
    @IBOutlet weak var taskTimeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
