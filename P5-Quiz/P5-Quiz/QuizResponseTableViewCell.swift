//
//  QuizResponseTableViewCell.swift
//  P5-Quiz
//
//  Created by JESUS on 19/11/2018.
//  Copyright © 2018 UPM. All rights reserved.
//

import UIKit

class QuizResponseTableViewCell: UITableViewCell {

    @IBOutlet weak var preguntaLbl: UILabel!
    @IBOutlet weak var respondeTxt: UITextField!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var confirmButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
