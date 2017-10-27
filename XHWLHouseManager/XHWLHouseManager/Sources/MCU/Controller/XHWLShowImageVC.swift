//
//  XHWLShowImageVC.swift
//  XHWLHouseManager
//
//  Created by gongairong on 2017/10/26.
//  Copyright © 2017年 XHWL. All rights reserved.
//

import UIKit

protocol XHWLShowImageVCDelegate:NSObjectProtocol {
    func onDeleteImage(_ image:UIImage)
}

class XHWLShowImageVC: XHWLBaseVC {

    weak var delegate:XHWLShowImageVCDelegate?
    var warningView:XHWLShowImageView!
    lazy fileprivate var downloadBtn:UIButton = {
        let jumpBtn = UIButton()
        let img:UIImage = UIImage(named:"CloudEyes_download")!
        jumpBtn.setImage(img, for: .normal)
        jumpBtn.addTarget(self, action: #selector(onDownload), for: .touchUpInside)
        jumpBtn.frame = CGRect(x:Screen_width-20-img.size.width, y:Screen_height-img.size.height-20, width:img.size.width, height:img.size.height)
        self.view.addSubview(jumpBtn)
        
        return jumpBtn
    }()
    var showImage:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "删除", style:.plain, target: self, action: #selector(onDelete))
        self.title = "云瞳监控"
        
        setupView()
    }
    
    func setupView() {
        
        warningView = XHWLShowImageView(frame:CGRect(x:Screen_width*3/32.0, y:Screen_height/6.0, width:Screen_width*13/16.0, height:Screen_height*2/3.0))
        warningView.showIV.image = showImage
        self.view.addSubview(warningView)
        
        self.view.addSubview(self.downloadBtn)
    }
    
    func onDownload() {
    
        UIImageWriteToSavedPhotosAlbum(showImage!, nil, nil, nil)
    }
    
    func onDelete() {
        self.delegate?.onDeleteImage(showImage)
        self.onBack()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
