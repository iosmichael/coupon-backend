//
//  PostCouponViewController.swift
//  Backend
//
//  Created by Michael Liu on 3/7/17.
//  Copyright © 2017 Coupon. All rights reserved.
//

import UIKit
import ImagePicker
import Lightbox

class PostCouponViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ImagePickerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let imageCollectionIdentifier = "images"
    let imageLimits = 2
    let imageCollectionCellHeight:CGFloat = 100

    var store:Store?
    
    enum cellType{
        case LL
        case LI
    }
    var couponTitle: UITextField?
    var hours: UITextField?
    var couponDetail: String = ""
    var images: [UIImage] = []

    let detailIndex = 2
    let customListCellHeight:CGFloat = 44
    
    var list = [(cellType.LI, "Title", "e.g "),
                (cellType.LI, "Hours", "e.g 30"),
                (cellType.LL, "Detail", "Required")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        list.append((cellType.LL, "Store", (store?.name)!))
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "ListCell")
        self.tableView.register(ImagesTableViewCell.self, forCellReuseIdentifier: "ImageCell")
        setupNav()
        addPhotoBtn()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.section == 0 ? imageCollectionCellHeight : customListCellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell:ImagesTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ImageCell", for: indexPath) as! ImagesTableViewCell
            return cell
        }else{
            let cell:CustomTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as! CustomTableViewCell
            let (type,L1,L2) = list[indexPath.row]
            fill(cell: cell,type: type,L1: L1,L2: L2)
            if indexPath.row == 0{
                couponTitle = cell.rightInput
            }else if indexPath.row == 1{
                hours = cell.rightInput
            }
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.isKind(of: ImagesTableViewCell.self){
            let imageCell = cell as! ImagesTableViewCell
            imageCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, indexPath: indexPath as NSIndexPath)
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else{
            return list.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == detailIndex && indexPath.section == 1{
            //push detail controller
            let detailController = CouponDetailController()
            detailController.parentC = self
            navigationController?.pushViewController(detailController, animated: true)
        }
    }
    
    func setupNav(){
        navigationController?.navigationBar.barTintColor = UIColor.init(hex: "525659")
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.white,NSFontAttributeName:UIFont.italicSystemFont(ofSize: 17)]
        let navRightBtn = UIBarButtonItem.init(image: UIImage.init(named:"check"),style:.plain, target: self, action: #selector(submit))
        navigationItem.rightBarButtonItem = navRightBtn
        navigationItem.rightBarButtonItem?.tintColor = UIColor.white
    }
    
    func submit(){
        if !validate(){
            print("fields input incorrect!")
            return
        }
        
        let coupon = Coupon()
        if images.count > 1 {
            let bannerImage = images[0]
            coupon.postData(name: (couponTitle?.text)!, detail: couponDetail, store: store!, bannerImage:bannerImage, hours:Double((self.hours?.text)!)!)
        }else{
            coupon.postData(name: (couponTitle?.text)!, detail: couponDetail, store: store!, hours:Double((self.hours?.text)!)!)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func validate()->Bool{
        //validate
        if couponDetail == "" || (couponTitle?.text?.isEmpty)! || store == nil || (self.hours?.text?.isEmpty)!{
            return false
        }
        if Double((self.hours?.text)!) == nil{
            return false
        }
        return true
    }
    
    func fill(cell:CustomTableViewCell,type:cellType, L1:String, L2:String){
        switch type {
        case .LL:
            cell.fillLL(labelStr: L1, inputStr: L2)
            break;
        case .LI:
            cell.fillLI(labelStr: L1, inputStr: L2)
            break;
        }
    }
    
    func fillDetail(detail:String){
        list[detailIndex] = (cellType.LL,"Detail",detail)
        self.couponDetail = detail
        self.tableView.reloadData()
    }
    
    func presentImagePicker(){
        let imagePickerController = ImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.imageLimit = imageLimits-images.count
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        imagePicker.dismiss(animated: true, completion: nil)
        for image in images{
            let screen:CGRect = UIScreen.main.bounds
            let img = UIImage.cropToBounds(image: image, width: Double(screen.width), height: Double(screen.height))
            self.images.insert(img, at: 0)
        }
        self.tableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCollectionIdentifier, for: indexPath)
        let imageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: 90, height: 90))
        imageView.image = images[indexPath.item]
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        
        cell.contentView.addSubview(imageView)
        if indexPath.item != images.count-1{
            let deleteBtn = UIButton.init(frame: CGRect.init(x: 65, y: 3, width: 22, height: 22))
            deleteBtn.setImage(UIImage.init(named: "cancel"), for: .normal)
            deleteBtn.tag = indexPath.item
            deleteBtn.addTarget(self, action: #selector(deleteImage), for: .touchUpInside)
            cell.contentView.addSubview(deleteBtn)
        }
        return cell
    }
    
    func deleteImage(sender: UIButton){
        images.remove(at: sender.tag)
        sender.removeFromSuperview()
        tableView.reloadData()
    }
    
    func addPhotoBtn(){
        images.insert(UIImage.init(named: "photo")!, at: images.count)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //show image picker
        if indexPath.item == images.count - 1 {
            presentImagePicker()
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}


class CouponDetailController:UIViewController{
    
    var detail: String?
    var textView: UITextView?
    weak var parentC: PostCouponViewController?
    let leftMargin:CGFloat = 20
    let topMargin:CGFloat = 10
    
    override func viewDidLoad() {
        let contentView:CGRect = self.view.frame
        textView = UITextView.init(frame:CGRect.init(x: leftMargin, y: topMargin, width: contentView.width-2*leftMargin, height: contentView.height-2*topMargin))
        textView?.layer.borderWidth = 0
        textView?.backgroundColor = UIColor.white
        textView?.font = UIFont.init(name: "HelveticaNeue", size: 18)
        self.view.backgroundColor = UIColor.groupTableViewBackground
        self.view.addSubview(textView!)
        setupNav()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupNav(){
        let navLeftBtn = UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(dismissCurrent))
        navigationItem.leftBarButtonItem = navLeftBtn
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white
        navigationItem.title = "Description"
    }
    
    func dismissCurrent(){
        parentC?.fillDetail(detail: (textView?.text)!)
        self.navigationController?.popViewController(animated: true)
    }
    
}
