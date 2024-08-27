//
//  CharacterInfoView.swift
//  DandelionExpenses
//
//  Created by OscarYen on 2021/12/17.
//

import UIKit

class CharacterInfoView: UIViewController,UITableViewDelegate,UITableViewDataSource {

   
    
    @IBOutlet weak var m_table: UITableView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAmount: UILabel!
    @IBOutlet weak var circleView: UIView!
    var m_oCreateView : CreateView!
    
    var characterInfo : [DeatilProfile] = []
    var allDetailInfo : [DeatilProfile] = []
    var nameValue: String = ""
    var amountValue: String = ""
    var debt: Float = 0.0
    var startValue = 0.0
    var endValue = 1200.0
   
    var displaylabel : UILabel?

    let animationDuration = 5.0

    var circleTimer: Timer?
    var elapsedTime = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rotateToPotrait()
        m_oCreateView = CreateView(nibName: Common.xib_CreateView, bundle: nil)
        m_table.register(UINib(nibName: Common.xib_ExpensesCell, bundle: nil), forCellReuseIdentifier: Common.xib_ExpensesCell)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        displaylabel?.text = ""
        elapsedTime = 0.0
        endValue = Double(amountValue) ?? 0
        circleAnimation()
        
        lblName.text = nameValue
        lblAmount.text = ""
        conversionData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return characterInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Common.xib_ExpensesCell, for: indexPath) as! ExpensesCell
        cell.selectionStyle = .none
        cell.lblName.text = characterInfo[indexPath.row].name
        cell.lblCategory.text = characterInfo[indexPath.row].category
        cell.lblUse.text = characterInfo[indexPath.row].use
        cell.lblAmount.text = "\(characterInfo[indexPath.row].amount)"
        
        if cell.lblUse.text == "支出" {
            cell.lblUse.textColor = UIColor.red
        } else if cell.lblUse.text == "公費" {
            cell.lblUse.textColor = UIColor.green
        } else if cell.lblUse.text == "領錢" {
            cell.lblUse.textColor = UIColor.blue
        } else {
            cell.lblUse.textColor = UIColor.red
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if let oView = m_oCreateView {
          
            oView.whos = characterInfo[indexPath.row].whos
            oView.nameValue = characterInfo[indexPath.row].name
            oView.categoryValue = characterInfo[indexPath.row].category
            oView.amountValue = String(characterInfo[indexPath.row].amount)
            oView.useValue = characterInfo[indexPath.row].use
            oView.userType = .infomation
            oView.userCodeValue  = characterInfo[indexPath.row].userCode
            oView.navigationItem.title = "詳細資料查詢"
            self.navigationItem.backButtonTitle = ""
            self.navigationController?.pushViewController(oView, animated: true)
        }
    }
    
    func circleAnimation() {
        let aDegree = CGFloat.pi / 180
        let lineWidth: CGFloat = 20
        let radius: CGFloat = 55
        let startDegree: CGFloat = 270
        let circlePath = UIBezierPath(ovalIn: CGRect(x: lineWidth , y: lineWidth , width: radius*2, height: radius*2))
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.strokeColor = UIColor.systemGray6.cgColor
        circleLayer.lineWidth = lineWidth
        circleLayer.fillColor = UIColor.clear.cgColor
        
        let percentage: CGFloat = CGFloat(debt) * 100
        let percentagePath = UIBezierPath(arcCenter: CGPoint(x: lineWidth  + radius, y: lineWidth  + radius), radius: radius, startAngle: aDegree * startDegree, endAngle: aDegree * (startDegree + 360 * percentage / 100), clockwise: true)
        let percentageLayer = CAShapeLayer()
        percentageLayer.path = percentagePath.cgPath
        percentageLayer.strokeColor  = UIColor.clear.cgColor
        percentageLayer.lineWidth = lineWidth
        percentageLayer.fillColor = UIColor.clear.cgColor
        
        displaylabel = UILabel(frame: CGRect(x: 0, y: 0, width: 2*(radius+lineWidth), height: 2*(radius+lineWidth)))
        displaylabel?.textAlignment = .center
        displaylabel?.textColor = UIColor.white
        displaylabel?.font = UIFont.boldSystemFont(ofSize:  30)
        displaylabel?.text = "0"
        
        lblAmount.layer.addSublayer(circleLayer)
        lblAmount.layer.addSublayer(percentageLayer)
        lblAmount.addSubview(displaylabel ?? UILabel())
        
        // Set up the appearance of the path.
        let newLayer = CAShapeLayer()
        newLayer.path = percentagePath.cgPath
        newLayer.strokeEnd = 0
        newLayer.lineWidth = 20
        newLayer.strokeColor = UIColor(red: CGFloat(40/255.0), green: CGFloat(50/255.0), blue: CGFloat(67/255.0), alpha: CGFloat(1.0)).cgColor
        newLayer.fillColor = UIColor.clear.cgColor
        lblAmount.layer.addSublayer(newLayer)
        
        // Create the infinity animation
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.toValue = 1
        animation.duration = 1
        animation.autoreverses = false
        animation.isRemovedOnCompletion = false
        animation.fillMode  = .forwards
        newLayer.add(animation, forKey: "line")
        circleTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(handleUpdate), userInfo: nil, repeats: true)
        
    }
    
    func conversionData() {
        characterInfo = []
        for i in allDetailInfo {
            for name in i.whos {
                if name == nameValue {
                    characterInfo.append(i)
                }
            }
        }
        m_table.reloadData()
    }
    
    @objc func handleUpdate() {
        elapsedTime += 0.5
        if elapsedTime > animationDuration {
            self.displaylabel?.text = "\(Int(endValue))"
            if let timer = circleTimer {
                timer.invalidate()
            }
            circleTimer = nil
            
        } else {
            let percentage = elapsedTime / animationDuration
            let value = startValue + percentage * (endValue - startValue)
            self.displaylabel?.text = "\(Int(value))"
        }
    }

}
