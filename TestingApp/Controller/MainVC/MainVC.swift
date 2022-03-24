//
//  ViewController.swift
//  TestingApp
//
//  Created by Adham Albanna on 24/03/2022.
//

import UIKit
import FSPagerView
import SDWebImage


enum userLogin {
    case login,not
}

class MainVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var fsPagerView: FSPagerView!
    @IBOutlet weak var isloginView: UIView!
    var dataObj : DataObj!
    var sliderArr = [AllCity]()
    var citiesArr = [AllCity]()
    var isLogin:userLogin = .not
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myOrdersRequest()
        initPagerView()
        initCollectionViews()
        let defaults = UserDefaults.standard
        let useTouchID = defaults.bool(forKey: "userLogin")
        if useTouchID {
            isloginView.isHidden = false
        } else {
            isloginView.isHidden = true
        }
        
        
    }

    
    @IBAction func btnLogin(_ sender: Any) {
        let vc = storyboard!.instantiateViewController(withIdentifier: "start")
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBOutlet weak var pagerView: FSPagerView! {
        didSet {
            self.pagerView.register(FSPagerViewCell.self, forCellWithReuseIdentifier: "cell")
            pagerView.transformer = FSPagerViewTransformer(type: .cubic)
        }
    }
    
    func myOrdersRequest(){
        API.home.startRequest(showIndicator: false) { (api, statusResult) in
            if statusResult.message == "Success" {
                let data = statusResult.data
                do{
                    let shpmentData = try JSONSerialization.data(withJSONObject: data, options: [])
                    print(shpmentData)
                    self.dataObj = try! JSONDecoder().decode(DataObj.self, from: shpmentData)
                    self.citiesArr = self.dataObj.allCities
                    self.sliderArr = self.dataObj.slider
                    self.collectionView.reloadData()
                    self.fsPagerView.reloadData()
                }
                catch{
                    print(statusResult.message)
                }
                
            }else{
                print(statusResult.errorMessege)
            }
        }
    }
    
}



extension MainVC : FSPagerViewDelegate,FSPagerViewDataSource {
    
    
    func initPagerView(){
        fsPagerView.dataSource = self
        fsPagerView.delegate = self
    }
    
    private var itemsCount: Int {min(8, sliderArr.count)}
    public func numberOfItems(in pagerView: FSPagerView) -> Int {
        return itemsCount
    }
    
    public func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "cell", at: index)
        let slid = sliderArr[sliderArr.count - index - 1]
        cell.imageView?.sd_setImage(with: URL(string: slid.imageURL), completed: nil)
        cell.textLabel?.text = slid.name
        return cell
    }

}


extension MainVC : UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {
    
    func initCollectionViews(){
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return citiesArr.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let newsCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CitiesCell", for: indexPath) as! CitiesCell
        
        let allCities = citiesArr[indexPath.row]
        newsCell.img.sd_setImage(with: URL(string: allCities.imageURL), completed: nil)
        newsCell.title.text = allCities.name
        return newsCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 206)
    }
    
}
