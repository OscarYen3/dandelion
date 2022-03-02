//
//  CreateView.swift
//  DandelionExpenses
//
//  Created by Oscar on 2021/12/12.
//

import UIKit
import Foundation
import CoreData
import Firebase
import FirebaseFirestore

protocol CreateViewDelegate {
    func SaveDetail(detailProfile: DeatilProfile)
    func EditDetail(detailProfile: DeatilProfile)
}
enum UserType {
case create
case edit
case infomation
}

class CreateView: UIViewController,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,AddMemberDlgDlgDelegate, UICollectionViewDelegate,SelectedCollectionItemDelegate  {

    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtCategory: UITextField!
    @IBOutlet weak var txtAmount: UITextField!
    @IBOutlet weak var useSegment: UISegmentedControl!
    @IBOutlet weak var btnConfirm: UIButton!
    @IBOutlet weak var btnAdd: UIButton!
    
    @IBOutlet weak var btnAll: UIButton!
    @IBOutlet weak var btnAllCancel: UIButton!
    @IBOutlet weak var _viewblureffect: UIView!
    @IBOutlet weak var collectionView: UIView!
    
    @IBOutlet weak var maskView: UIView!
    @IBOutlet weak var viewButton: UIStackView!
    var _delegate:CreateViewDelegate?
    var SelectView = UIPickerView()
    let toolBar = UIToolbar()
    var nameValue: String = ""
    var categoryValue: String = ""
    var amountValue: String = ""
    var useValue:String = ""
    var m_DlgAddMember: AddMemberDlg!
    var whos:[String] = []
    var pickerNameList:[String] = []
    let db = Firestore.firestore()
    var userType:UserType = .create
    var userCodeValue: Int = 0
    var myCollectionView : UICollectionView?
    var nameList: [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rotateToPotrait()
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 5) // section與section之間的距離(如果只有一個section，可以想像成frame)
        layout.itemSize = CGSize(width: (self.view.frame.size.width - 30) / 5, height: 30) // cell的寬、高
        layout.minimumLineSpacing = CGFloat(integerLiteral: 5) // 滑動方向為「垂直」的話即「上下」的間距;滑動方向為「平行」則為「左右」的間距
        layout.minimumInteritemSpacing = CGFloat(integerLiteral: 5) // 滑動方向為「垂直」的話即「左右」的間距;滑動方向為「平行」則為「上下」的間距
        layout.scrollDirection = UICollectionView.ScrollDirection.vertical // 滑動方向預設為垂直。注意若設為垂直，則cell的加入方式為由左至右，滿了才會換行；若是水平則由上往下，滿了才會換列
        
        m_DlgAddMember = AddMemberDlg(nibName: Common.xib_AddMemberDlg, bundle: nil)
        
        btnConfirm.addTarget(self, action: #selector(save), for: .touchUpInside)
        txtName.delegate = self
        txtCategory.delegate = self
        txtAmount.delegate = self
        myCollectionView = UICollectionView(frame:CGRect(x:collectionView.frame.minX -  15, y:collectionView.frame.minY + 15 ,width:collectionView.frame.width, height:collectionView.frame.height * 0.7),collectionViewLayout:layout)
        myCollectionView?.dataSource = self
        myCollectionView?.delegate = self
        myCollectionView?.register(UINib(nibName: Common.xib_NameCell, bundle: nil), forCellWithReuseIdentifier: Common.xib_NameCell)
        self.view.addSubview(myCollectionView ?? UICollectionView())
        selectViewSet()
//        addShadow(btnConfirm)
        tetfiledDisplay(txtName)
        tetfiledDisplay(txtCategory)
        tetfiledDisplay(txtAmount)
        
        
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        useSegment.setTitleTextAttributes(titleTextAttributes, for:.normal)
        useSegment.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for:.selected)
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameList = defaults.array(forKey: "NameList") ?? []
        pickerNameList = nameList as? [String] ?? []
        pickerNameList.insert("公費", at: 0)
        txtName.text = nameValue
        txtCategory.text = categoryValue
        txtAmount.text = amountValue
        if useValue == "支出" {
            useSegment.selectedSegmentIndex = 0
        } else if useValue == "公費" {
            useSegment.selectedSegmentIndex = 1
        } else if useValue == "領錢" {
            useSegment.selectedSegmentIndex = 2
        } else {
            useSegment.selectedSegmentIndex = 0
        }
        myCollectionView?.reloadData()
       
        if userType == .infomation {
            btnConfirm.isHidden = true
            maskView.isHidden = false
            myCollectionView?.isUserInteractionEnabled = false
            viewButton.isHidden = true
            btnAdd.isHidden = true
        } else {
            btnConfirm.isHidden = false
            maskView.isHidden = true
            myCollectionView?.isUserInteractionEnabled = true
            viewButton.isHidden = false
            btnAdd.isHidden = false
        }
        
    }
    
    func tetfiledDisplay(_ uitex:UITextField) {
        uitex.layer.borderWidth = 1
        uitex.layer.borderColor = UIColor.darkGray.cgColor
        uitex.layer.cornerRadius = 8
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
           self.view.endEditing(true)
       }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
      }
    
    func selectViewSet() {
        SelectView = UIPickerView(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 200))
        SelectView.delegate = self
        SelectView.dataSource = self
        SelectView.backgroundColor = UIColor.white
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = .systemBlue
        toolBar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "完成", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.doneClick))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "取消", style: UIBarButtonItem.Style.plain, target: self, action:#selector(self.cancelClick))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        txtName.inputView = SelectView
        txtName.inputAccessoryView = toolBar
    
    }
    
    
    //================================================================================================
    // MARK: - SelectBeanType
    //================================================================================================
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return  1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return pickerNameList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return pickerNameList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        nameValue = pickerNameList[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int,
                    forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel = view as? UILabel
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 22)
        }
        pickerLabel?.numberOfLines = 0
        pickerLabel?.minimumScaleFactor = 0.6
        pickerLabel?.textAlignment = .center
        
        pickerLabel?.text = pickerNameList[row]
        return pickerLabel!
    }
   
    @IBAction func allClick(_ sender: Any) {
        whos = nameList as? [String] ?? []
        myCollectionView?.reloadData()
    }
    @IBAction func allCancel(_ sender: Any) {
        whos = []
        myCollectionView?.reloadData()
    }
    @objc func doneClick()  {
        if nameValue == "" {
            txtName.text = pickerNameList[0] as? String
        } else {
            txtName.text = nameValue
        }
        
        self.view.endEditing(true)
        toolBar.endEditing(true)
    }
    @objc func cancelClick() {
        self.view.endEditing(true)
        toolBar.endEditing(true)
    }
    
    
    @objc func save() {
        
        let sumValue = Int(txtAmount.text ?? "") ?? 0
        let unitValue = whos.count
        let data = DeatilProfile()
        data.name = txtName.text ?? ""
        data.category = txtCategory.text ?? ""
        
       
        if useSegment.selectedSegmentIndex == 0 {
            data.use = "支出"
//            data.amount = sumValue - (sumValue / unitValue)
            data.amount = sumValue
        } else if useSegment.selectedSegmentIndex == 1 {
            data.use = "公費"
            data.amount = sumValue
        } else if useSegment.selectedSegmentIndex == 2 {
            data.use = "領錢"
            data.amount = sumValue
        }
        data.date = Date()
        let timeInterval = data.date.timeIntervalSince1970
        
        data.whos = self.whos
        if txtName.text == "公費" {
            if (txtName.text == "" || txtCategory.text == "" ||  txtAmount.text == "" ) {
                //UIShowAddMember(true)
                let controller = UIAlertController(title: "提醒", message: "尚有資料沒有輸入 \n 人物勾選最少一人", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                controller.addAction(okAction)
                present(controller, animated: true, completion: nil)
            } else {
                if userType == .create {
                    data.userCode = Int(timeInterval)
                    self._delegate?.SaveDetail(detailProfile: data)
                } else if userType == .edit {
                    data.userCode = userCodeValue
                    self._delegate?.EditDetail(detailProfile: data)
                }
                
                navigationController?.popViewController(animated: true)
            }
        } else {
            if (txtName.text == "" || txtCategory.text == "" ||  txtAmount.text == "" || self.whos.count == 0 ) {
                //UIShowAddMember(true)
                let controller = UIAlertController(title: "提醒", message: "尚有資料沒有輸入 \n 人物勾選最少一人", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                controller.addAction(okAction)
                present(controller, animated: true, completion: nil)
            } else {
                if userType == .create {
                    data.userCode = Int(timeInterval)
                    self._delegate?.SaveDetail(detailProfile: data)
                } else if userType == .edit {
                    data.userCode = userCodeValue
                    self._delegate?.EditDetail(detailProfile: data)
                }
                
                navigationController?.popViewController(animated: true)
            }
        }
      
        
       
        
    }
    
    func addShadow(_ view:UIButton) {
        view.layer.masksToBounds = false
        view.layer.shadowRadius = 2
        view.layer.shadowOpacity = 0.2
        view.layer.shadowOffset = CGSize(width: 0, height: 5)
        view.layer.shadowColor = UIColor.black.cgColor
        
    }
    
    func UIShowAddMember(_ bShow: Bool) {
        if let oView = m_DlgAddMember {
            oView._delegate = self
            DialogShow(oView, bShow)
        }
    }
    @IBAction func addClick(_ sender: Any) {
        UIShowAddMember(true)
//        let controller = UIAlertController(title: "提示", message: "尚未提供此功能", preferredStyle: .alert)
//        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//        controller.addAction(okAction)
//        present(controller, animated: true, completion: nil)
    }
    
    func OnCancel() {
        UIShowAddMember(false)
    }
    func OnOK(_ name:String) {
        
        UIShowAddMember(false)
        navigationController?.popViewController(animated: true)
    }
    
    private func DialogShow(_ oView: UIViewController , _ bShow:Bool) {
        
        if(bShow) {
            oView.modalPresentationStyle = .fullScreen
            oView.modalPresentationStyle = .custom
            self.present(oView, animated: true, completion: nil)
//            self.view.(oView.view)
            oView.view.center = oView.view.center
            setMask(bShow)
            oView.view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            oView.view.alpha = 0
            
            UIView.animate(withDuration: 0.3) {
                oView.view.alpha = 1
                oView.view.transform = CGAffineTransform.identity
            }
        }
        else {
            UIView.animate(withDuration: 0.3, animations: {
                oView.view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
                oView.view.alpha = 0
            }) { (success:Bool) in
                oView.dismiss(animated: true)
                self.setMask(bShow)
            }
        }
        
    }
    func setMask(_ mask: Bool) {
        _viewblureffect.isHidden = !mask
        self.navigationItem.hidesBackButton = mask
    }
    
    func selectedCollectionItem(index: Int) {
           print("Selected item \(index)")
       }
    @IBAction func clickSegment(_ sender: Any) {
        if useSegment.selectedSegmentIndex == 0 {
            txtCategory.isEnabled = true
        } else if useSegment.selectedSegmentIndex == 1 {
            txtCategory.text = "公費"
            txtCategory.isEnabled = false
        } else if useSegment.selectedSegmentIndex == 2 {
            txtCategory.text = "領錢"
            txtCategory.isEnabled = false
        }
        
    }
}

extension CreateView: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nameList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Common.xib_NameCell, for: indexPath as IndexPath) as! NameCell
        cell.lblName.text = nameList[indexPath.row] as! String
        cell.inmgSelect.isHidden = !check(nameList[indexPath.row] as! String)
        cell.delegate = self
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        print("Selected Cell: \(indexPath.row)")
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        print("Selected Cell: \(nameList[indexPath.row])")
        var isremoved: Bool = false
        if whos.count != 0 {
            for (index,value) in whos.enumerated() {
                if nameList[indexPath.row] as! String == value {
                    whos.remove(at: index)
                    isremoved = true
                }
            }
        }
        if !isremoved {
            whos.append(nameList[indexPath.row] as! String)
        }
        collectionView.reloadData()
        return true
    }
    
    func check(_ target: String) -> Bool {
        var pass: Bool = false
        for i in whos {
            if target == i {
                pass = true
                break
            } else {
                pass = false
            }
        }
        return pass
    }

}
