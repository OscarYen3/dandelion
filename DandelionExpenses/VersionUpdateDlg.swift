//
//  VersionUpdateDlg.swift
//  DandelionExpenses
//
//  Created by Oscar Yen on 2022/8/9.
//

import UIKit

class VersionUpdateDlg: UIViewController {

    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var btnOk: UIButton!
    @IBOutlet weak var lblTitile: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnOk.addTarget(self, action: #selector(ok), for: .touchUpInside)
        btnOk.layer.cornerRadius = btnOk.frame.height / 2
        lblTitile.text = "update_app_apple_store"
        btnOk.setTitle("ok", for: .normal)
        lbltitle.text = "update_app"
    }
    
    @objc func ok() {

        let urlString = "https://apps.apple.com/tw/app/sandbox-smart/id1492957836"
        let url = NSURL(string: urlString)
        UIApplication.shared.openURL(url! as URL)
        
    }
}
