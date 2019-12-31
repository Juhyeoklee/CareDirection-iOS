//
//  HomeVC.swift
//  CareDirection
//
//  Created by 안재은 on 26/12/2019.
//  Copyright © 2019 SwiftHelloWorld. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {
    
    // 제품 나타내는 collection view
    @IBOutlet weak var productCollectionView: UICollectionView!
    // 기능성 원료 나타내는 collection view
    @IBOutlet weak var functionalCollectionView: UICollectionView!
    
    @IBOutlet weak var functionalCollectionView2: UICollectionView!
    
    
    // 문제의 스크롤뷰..ㅎ
    @IBOutlet weak var scrollView: UIScrollView!
    
    // 상세 뷰로 이어지는 버튼들
    @IBOutlet weak var showDetailStandard: UIButton!
    @IBOutlet weak var showDetailFunction: UIButton!
    @IBOutlet weak var showSchedule: UIButton!
    
    // 유저 선택 전체적인 뷰
    @IBOutlet weak var userTableView: SelfSizedTableView!
    @IBOutlet weak var dropDownButton: UIButton!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var navigationBar: UIView!
    
    // 뷰의 전체적인 세 가지 뷰들.
    @IBOutlet weak var ingredientView: UIView!
    @IBOutlet weak var functionView: UIView!
    @IBOutlet weak var takingView: UIView!
    
    // 차트 나타내는 뷰
    @IBOutlet weak var chartView: ChartView!
    
    // 복용제품 등록하지 않았을 시 나타나는 뷰
    @IBOutlet weak var noRegistView: UIView!
    
    
    // 받아올 데이터 리스트들.
    //1. 유저 리스트
    //2. 등록한 제품들 리스트
    //3. 기능성 원료
    var userList : [User] = []
    var productList : [Product] = []
    var functionalIngredientList : [FunctionalIngredient] = []
    var functionalIngredientList2 : [FunctionalIngredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 유저 리스트 더미 데이터 생성
        setUserData()
        // 제품 리스트 더미 데이터 생성
        setProductData()
        setIngredient()
        
        // navigation bar 사용자 추가 isHidden 설정해주기!
        userTableView.isHidden = true
        blurView.isHidden = true
        
        
        // 전체적인 뷰 블록 나누기 효과
        ingredientView.dropShadow(color: UIColor.brownishGrey30, offSet: CGSize(width: 0, height: 1), opacity: 0.3, radius: 3)
        functionView.dropShadow(color: UIColor.brownishGrey30, offSet: CGSize(width: 0, height: 1), opacity: 0.3, radius: 3)
        takingView.dropShadow(color: UIColor.brownishGrey30, offSet: CGSize(width: 0, height: 1), opacity: 0.3, radius: 3)
        
        // 차트 뷰 나타내기
        ChartView.playAnimations()
        // table view customize
        userTableView.clipsToBounds = true
        userTableView.layer.cornerRadius = 20
        userTableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        userTableView.maxHeight = 300
        userTableView.reloadData()
        
        // collection view delegate, dataSource 설정
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        
        
        // button custom 하기
        showDetailStandard.makeRounded(cornerRadius: 13)
        showDetailFunction.makeRounded(cornerRadius: 13)
        showSchedule.makeRounded(cornerRadius: 13)
        showSchedule.setBorder(borderColor: UIColor.brownishGrey, borderWidth: 1)
        
        // 복용하는 제품이 없을 시 나타내는 뷰
        noRegistView.makeRounded(cornerRadius: 18)
        noRegistView.dropShadow(color: UIColor.brownishGrey30, offSet: CGSize(width: 0, height: 1), opacity: 0.4, radius: 4)
        
    }
    
    
    // 유저 변경 drop down button
    @IBAction func userDropDown(_ sender: Any) {
        if userTableView.isHidden {
            animate(toggle: true)
        } else {
            animate(toggle: false)
        }
    }
    
    func animate(toggle: Bool) {
        if toggle {
            UIView.animate(withDuration: 0.3) {
                self.userTableView.isHidden = false
                //self.blurView.isHidden = false
            }
            self.blurView.isHidden = false
        } else {
            UIView.animate(withDuration: 0.3) {
                self.userTableView.isHidden = true
                self.blurView.isHidden = true
            }
            
        }
    }
    
    @IBAction func settingButtonClick(_ sender: Any) {
        let standardStoryboard = UIStoryboard.init(name: "Setting", bundle: nil)
        
        guard let dvc = standardStoryboard.instantiateViewController(withIdentifier: "Setting") as? SettingVC else {
          return
        }
        present(dvc, animated: true)
    }
    
    
    // 필수 비타민 & 미네랄 상세보기 button action
    @IBAction func showStandardDetail(_ sender: Any) {
        
        let standardStoryboard = UIStoryboard.init(name: "StandardDetail", bundle: nil)
        guard let dvc = standardStoryboard.instantiateViewController(withIdentifier: "standard") as? StandardDetailVC else {
          return
        }
        present(dvc, animated: true)
        
    }
    
    // 기능성 원료 상세보기 button action
    @IBAction func showFunctionalDetail(_ sender: Any) {
        let functionStoryboard = UIStoryboard.init(name: "FunctionDetail", bundle: nil)
        guard let dvc = functionStoryboard.instantiateViewController(withIdentifier: "functionDetail") as? FunctionDetailVC else {
          return
        }
        present(dvc, animated: true)
    }
    
    // 복용관리 -> 스케쥴표 보기 button action
    @IBAction func showScheduleButtonClick(_ sender: Any) {
        let recordStoryboard = UIStoryboard.init(name: "TakingProductRegist", bundle: nil)
        guard let dvc = recordStoryboard.instantiateViewController(withIdentifier: "takingProduct") as? TakingProductRegistVC else {
          return
        }
        present(dvc, animated: true)
    }
}

// 유저 등록 table view datasource & delegate
extension HomeVC : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = userTableView.dequeueReusableCell(withIdentifier: "UserCell") as! UserCell
        
        let user = userList[indexPath.row]
        
        
        if indexPath.row == userList.count - 2 {
            //cell.layer.backgroundColor = UIColor.tealBlue.cgColor
            cell.userName.textColor = UIColor.white
            cell.userName.backgroundColor = UIColor.tealBlue
            cell.deleteButton.isHidden = true
        }
        
        if indexPath.row == userList.count - 1 {
            cell.userName.font = UIFont(name: "Apple SD Gothic Neo", size: 12)
            cell.userName.textColor = UIColor.darkGray
            cell.userName.backgroundColor = UIColor.white
            cell.userName.setBorder(borderColor: UIColor.white, borderWidth: 0)
            cell.deleteButton.isHidden = true
            cell.selectionStyle = .none
        }
        
        cell.userName.text = user.userName
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // drop down button 의 타이틀 바꿔주기
        if indexPath.row == userList.count - 2 {
            dropDownButton.setTitle(dropDownButton.titleLabel?.text, for: .normal)
            animate(toggle: false)
            let alert = UIAlertController(title: "추가하시겠습니까?", message: "새로운 데이터 추가를 위해\n설문 조사부터 다시 시작합니다.", preferredStyle: UIAlertController.Style.alert)
            let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
            let cancel = UIAlertAction(title: "취소", style: .destructive, handler: nil)
            
            alert.addAction(cancel)
            alert.view.tintColor = UIColor.tealBlue
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
            
        } else {
            dropDownButton.setTitle(userList[indexPath.row].userName, for: .normal)
            animate(toggle: false)
        }
    }
}

// 복용하고 있는 제품들 collection view datasource
extension HomeVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.productCollectionView {
        return productList.count
        } else if collectionView == self.functionalCollectionView{
            return functionalIngredientList.count
        } else {
            return functionalIngredientList2.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.productCollectionView {
        let cell = productCollectionView.dequeueReusableCell(withReuseIdentifier: "productCell", for: indexPath) as! ProductCell
        
        let product = productList[indexPath.row]
        
        cell.productName.text = product.productName
        cell.productImage.image = product.productImage
        cell.productCheckImage.image = product.checkImage
        
        return cell
    } else {
            let cell = functionalCollectionView.dequeueReusableCell(withReuseIdentifier: "ingredientCell", for: indexPath) as! FunctionalIngredientCell
            
            let ingredient = functionalIngredientList[indexPath.row]
            
            cell.imageView.image = ingredient.ingredientImage
            cell.label.text = ingredient.ingredientName
            
            return cell
    }
    
    }
}

// collection view delegate
extension HomeVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let recordStoryboard = UIStoryboard.init(name: "TakingProductPopUp", bundle: nil)
        
        guard let dvc = recordStoryboard.instantiateViewController(withIdentifier: "TakingProductPopUp") as? TakingProductPopUpVC else {
            return
        }
        
        present(dvc, animated: true)
    }
}

// 제품리스트 더미 데이터 세팅
extension HomeVC {
    
    // 유저 table view 에 넣을 데이터 세팅
    func setUserData() {
        let user1 = User(name: "박진오")
        let user2 = User(name: "엄마")
        let user3 = User(name: "안재은")
        let setting = User(name: "+ 사용자 추가하기")
        let info = User(name: "사랑하는 가족의 데이터를 추가하고,\n케어 파트너와 함께 해보세요!")
        
        userList = [user1, user2, user3] + [setting] + [info]
    }
    // 제품 collection view에 넣을 데이터 세팅
    func setProductData() {
        let product1 = Product(productImg: "test1", name: "얼라이브", checkImg: "uncheckCircleIc")
        let product2 = Product(productImg: "test1", name: "얼라이브", checkImg: "uncheckCircleIc")
        let product3 = Product(productImg: "test1", name: "얼라이브", checkImg: "checkCircleIc")
        let product4 = Product(productImg: "test1", name: "얼라이브", checkImg: "uncheckCircleIc")
        let product5 = Product(productImg: "test1", name: "얼라이브", checkImg: "checkCircleIc")
        
        productList = [product1, product2, product3, product4, product5]
    }
    
    func setIngredient() {
        let ingredient1 = FunctionalIngredient(image: "liver60", name: "간건강")
        let ingredient2 = FunctionalIngredient(image: "liver60", name: "면역력")
        let ingredient3 = FunctionalIngredient(image: "liver60", name: "피로회복")
        
        functionalIngredientList = [ingredient1, ingredient2, ingredient3]
        
        functionalIngredientList2 = [ingredient1, ingredient2]
    }
    
}
