//
//  ScheduleCell.swift
//  DandelionExpenses
//
//  Created by OscarYen on 2022/9/7.
//

import UIKit

class ScheduleCell: UITableViewCell {

    @IBOutlet weak var lblIndex: UILabel!
    @IBOutlet weak var lblEvent: UILabel!
    @IBOutlet weak var lblNote: UILabel!
    @IBOutlet weak var topline: UIView!
    @IBOutlet weak var bottomLine: UIView!
    
    var index = ""
    var event = ""
    var note = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblIndex.text = index
        lblEvent.text = event
        lblNote.text = note
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    
}
