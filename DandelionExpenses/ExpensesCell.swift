//
//  ExpensesCell.swift
//  DandelionExpenses
//
//  Created by Oscar on 2021/12/12.
//

import UIKit

class ExpensesCell: UITableViewCell {
    
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblCategory: UILabel!
    @IBOutlet weak var lblUse: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    
    var name : String = ""
    var category: String = ""
    var use: String = ""
    var amount: Int = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblName.text = name
        lblCategory.text = category
        lblUse.text = use
        lblAmount.text = "\(amount)"
    }
  
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
