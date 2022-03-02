//
//  NameCell.swift
//  DandelionExpenses
//
//  Created by OscarYen on 2021/12/18.
//

import UIKit

protocol SelectedCollectionItemDelegate {
    func selectedCollectionItem(index: Int)
}

class NameCell: UICollectionViewCell, UICollectionViewDelegate {
    var delegate: SelectedCollectionItemDelegate?
    
    @IBOutlet weak var inmgSelect: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var backView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.isUserInteractionEnabled = true
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            //print(indexPath.row)
            let itemNum = indexPath.row
            self.delegate?.selectedCollectionItem(index: itemNum)

        }
}
