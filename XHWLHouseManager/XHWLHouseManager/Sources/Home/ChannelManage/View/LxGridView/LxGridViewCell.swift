//
//  LxGridViewCell.swift
//  LxGridViewDemo
//

import UIKit

let LxGridView_DELETE_RADIUS: CGFloat = 15
let ICON_CORNER_RADIUS: CGFloat = 15

let kVibrateAnimation = "kVibrateAnimation"
let VIBRATE_DURATION: CGFloat = 0.1
let VIBRATE_RADIAN = CGFloat(Double.pi/96)

protocol LxGridViewCellDelegate {

    func deleteButtonClickedInGridViewCell(gridViewCell: LxGridViewCell)
}

class LxGridViewCell: UICollectionViewCell {
    
    var delegate: LxGridViewCellDelegate?
    var iconImageView: UIImageView?
    
    private var _deleteButton: UIButton?
    private var _titleLabel: UILabel?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        setup()
        setupEvents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
        setup()
        setupEvents()
    }
    
    func setup() {
        self.backgroundColor = UIColor.red
        
        iconImageView = UIImageView()
        iconImageView?.contentMode = .scaleAspectFit
        iconImageView?.layer.cornerRadius = ICON_CORNER_RADIUS
        iconImageView?.layer.masksToBounds = true
        contentView.addSubview(iconImageView!)

        _deleteButton = UIButton(type: .custom)
        _deleteButton?.setImage(UIImage(named: "delete_collect_btn"), for: .normal)
        contentView.addSubview(_deleteButton!)
        _deleteButton?.isHidden = true
        
        _titleLabel = UILabel()
        _titleLabel?.text = "title"
        _titleLabel?.font = UIFont.systemFont(ofSize: 14)
        _titleLabel?.textColor = UIColor.black
        _titleLabel?.textAlignment = .center
        contentView.addSubview(_titleLabel!)
        
        iconImageView?.translatesAutoresizingMaskIntoConstraints = false
        _deleteButton?.translatesAutoresizingMaskIntoConstraints = false
        _titleLabel?.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let iconImageViewLeftConstraint = NSLayoutConstraint(item: iconImageView!, attribute: .left, relatedBy: .equal, toItem: contentView, attribute: .left, multiplier: 1, constant: 0)
        let iconImageViewRightConstraint = NSLayoutConstraint(item: iconImageView!, attribute: .right, relatedBy: .equal, toItem: contentView, attribute: .right, multiplier: 1, constant: 0)
        let iconImageViewTopConstraint = NSLayoutConstraint(item: iconImageView!, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: 0)
        let iconImageViewHeightConstraint = NSLayoutConstraint(item: iconImageView!, attribute: .width, relatedBy: .equal, toItem: iconImageView, attribute: .height, multiplier: 1, constant: 0)
        contentView.addConstraints([iconImageViewLeftConstraint, iconImageViewRightConstraint, iconImageViewTopConstraint, iconImageViewHeightConstraint])
        
        let deleteButtonTopConstraint = NSLayoutConstraint(item: _deleteButton!, attribute: .top, relatedBy: .equal, toItem: iconImageView, attribute: .top, multiplier: 1, constant: -_deleteButton!.currentImage!.size.height/2)
        let deleteButtonLeftConstraint = NSLayoutConstraint(item: _deleteButton!, attribute: .left, relatedBy: .equal, toItem: iconImageView, attribute: .left, multiplier: 1, constant: -_deleteButton!.currentImage!.size.width/2)
        let deleteButtonWidthConstraint = NSLayoutConstraint(item: _deleteButton!, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: _deleteButton!.currentImage!.size.width)
        let deleteButtonHeightConstraint = NSLayoutConstraint(item: _deleteButton!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: _deleteButton!.currentImage!.size.height)
        contentView.addConstraints([deleteButtonTopConstraint, deleteButtonLeftConstraint, deleteButtonWidthConstraint, deleteButtonHeightConstraint])
        
        let centerXConstraint = NSLayoutConstraint(item: _titleLabel!, attribute: .centerX, relatedBy: .equal, toItem: iconImageView, attribute: .centerX, multiplier: 1, constant: 0)
        let titleLabelTopConstraint = NSLayoutConstraint(item: _titleLabel!, attribute: .top, relatedBy: .equal, toItem: iconImageView, attribute: .bottom, multiplier: 1, constant: 5)
        let titleLabelWidthConstraint = NSLayoutConstraint(item: _titleLabel!, attribute: .width, relatedBy: .equal, toItem: iconImageView, attribute: .width, multiplier: 1, constant: 0)
        let titleLabelHeightConstraint = NSLayoutConstraint(item: _titleLabel!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 15)
        contentView.addConstraints([centerXConstraint, titleLabelTopConstraint, titleLabelWidthConstraint, titleLabelHeightConstraint])
    }
    
    func setupEvents() {
    
        _deleteButton?.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
        iconImageView?.isUserInteractionEnabled = true
    }
    
    func deleteButtonClicked(btn: UIButton) {
    
        self.delegate?.deleteButtonClickedInGridViewCell(gridViewCell: self)
    }
    
    private var vibrating: Bool {
    
        get {
            if let animationKeys = iconImageView?.layer.animationKeys() {
            
                return animationKeys.contains(kVibrateAnimation) // contains(animationKeys as! [String], kVibrateAnimation)
            }
            else {
                return false
            }
        }
        set {
            
            var _vibrating = false
        
            if let animationKeys = layer.animationKeys() {
                
                _vibrating = animationKeys.contains(kVibrateAnimation)
//                _vibrating = contains(animationKeys as! [String], kVibrateAnimation)
            }
            else {
                _vibrating = false
            }
            
            if _vibrating && !newValue {
            
                layer.removeAnimation(forKey: kVibrateAnimation)
            }
            else if !_vibrating && newValue {
            
                let vibrateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
                vibrateAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                vibrateAnimation.fromValue = -VIBRATE_RADIAN
                vibrateAnimation.toValue = VIBRATE_RADIAN
                vibrateAnimation.autoreverses = true
                vibrateAnimation.duration = CFTimeInterval(VIBRATE_DURATION)
                vibrateAnimation.repeatCount = Float(CGFloat.greatestFiniteMagnitude)
                layer.add(vibrateAnimation, forKey: kVibrateAnimation)
            }
        }
    }
    
    var editing: Bool {
        
        get {
            return vibrating
        }
        set {
            vibrating = newValue
            _deleteButton?.isHidden = !newValue
        }
    }
    
    var title: String? {
    
        get {
            return _titleLabel?.text
        }
        set {
            _titleLabel?.text = newValue
        }
    }
    
    func snapshotView() -> UIView {
        
        let snapshotView = UIView()
        
        let cellSnapshotView:UIView = self.contentView.snapshotView(afterScreenUpdates: false)!
        let deleteButtonSnapshotView = _deleteButton?.snapshotView(afterScreenUpdates: false)
        
        snapshotView.frame = CGRect(x: -deleteButtonSnapshotView!.frame.size.width / 2,
            y: -deleteButtonSnapshotView!.frame.size.height / 2,
            width: deleteButtonSnapshotView!.frame.size.width / 2 + cellSnapshotView.frame.size.width,
            height: deleteButtonSnapshotView!.frame.size.height / 2 + cellSnapshotView.frame.size.height)
        cellSnapshotView.frame = CGRect(x: deleteButtonSnapshotView!.frame.size.width / 2,
            y: deleteButtonSnapshotView!.frame.size.height / 2,
            width: cellSnapshotView.frame.size.width,
            height: cellSnapshotView.frame.size.height)
        deleteButtonSnapshotView?.frame = CGRect(x: 0, y: 0,
            width: deleteButtonSnapshotView!.frame.size.width,
            height: deleteButtonSnapshotView!.frame.size.height)
        
        snapshotView.addSubview(cellSnapshotView)
        snapshotView.addSubview(deleteButtonSnapshotView!)
        
        return snapshotView
    }
}
