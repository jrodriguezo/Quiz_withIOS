//
//  QuizzesCell.swift
//  P5-Quiz
//
//  Created by JESUS on 19/11/2018.
//  Copyright © 2018 UPM. All rights reserved.
//

import UIKit

class QuizCell: UITableViewCell {

    @IBOutlet weak var autorLbl: UILabel!
    @IBOutlet weak var questionLbl: UILabel!
    
    @IBOutlet weak var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
