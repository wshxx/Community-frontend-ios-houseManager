//
//  LxGridViewFlowLayout.swift
//  LxGridViewDemo
//

import UIKit

let PRESS_TO_MOVE_MIN_DURATION = 0.1
let MIN_PRESS_TO_BEGIN_EDITING_DURATION = 0.6

@objc

protocol LxGridViewDataSource : UICollectionViewDataSource {

    @objc optional func collectionView(_ collectionView: LxGridView, itemAtIndexPath sourceIndexPath: IndexPath, willMoveToIndexPath destinationIndexPath: IndexPath)
    @objc optional func collectionView(_ collectionView: LxGridView, itemAtIndexPath sourceIndexPath: IndexPath, didMoveToIndexPath destinationIndexPath: IndexPath)
    
    @objc optional func collectionView(_ collectionView: LxGridView, canMoveItemAtIndexPath indexPath: IndexPath) -> Bool
    @objc optional func collectionView(_ collectionView: LxGridView, itemAtIndexPath sourceIndexPath: IndexPath, canMoveToIndexPath destinationIndexPath: IndexPath) -> Bool
}

@objc

protocol LxGridViewDelegateFlowLayout : UICollectionViewDelegateFlowLayout {

    @objc optional func collectionView(_ collectionView: LxGridView, layout gridViewLayout: LxGridViewFlowLayout, willBeginDraggingItemAtIndexPath indexPath: IndexPath)
    @objc optional func collectionView(_ collectionView: LxGridView, layout gridViewLayout: LxGridViewFlowLayout, didBeginDraggingItemAtIndexPath indexPath: IndexPath)
    @objc optional func collectionView(_ collectionView: LxGridView, layout gridViewLayout: LxGridViewFlowLayout, willEndDraggingItemAtIndexPath indexPath: IndexPath)
    @objc optional func collectionView(_ collectionView: LxGridView, layout gridViewLayout: LxGridViewFlowLayout, didEndDraggingItemAtIndexPath indexPath: IndexPath)
}

class LxGridViewFlowLayout: UICollectionViewFlowLayout, UIGestureRecognizerDelegate {
    
    var panGestureRecognizerEnable: Bool {
        
        get {
            return _panGestureRecognizer.isEnabled
        }
        set {
            _panGestureRecognizer.isEnabled = newValue
        }
    }
   
    var _panGestureRecognizer = UIPanGestureRecognizer()
    
    var _longPressGestureRecognizer = UILongPressGestureRecognizer()
    var _movingItemIndexPath: IndexPath?
    var _beingMovedPromptView: UIView?
    var _sourceItemCollectionViewCellCenter = CGPoint.zero
    
    var _displayLink: CADisplayLink?
    var _remainSecondsToBeginEditing = MIN_PRESS_TO_BEGIN_EDITING_DURATION
    
    
//  MARK:- setup
    deinit {
    
        _displayLink?.invalidate()
        
        removeGestureRecognizers()
        removeObserver(self, forKeyPath: "collectionView")
    }
    
    override init () {
        
        super.init()
        setup()
    }

    required init(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)!
        setup()
    }
    
    func setup() {
    
        self.addObserver(self, forKeyPath: "collectionView", options: .new, context: nil)
    }
    
    func addGestureRecognizers() {
    
        collectionView?.isUserInteractionEnabled = true
        
//        _longPressGestureRecognizer.addTarget(self, action: #selector(longPressGestureRecognizerTriggerd))
//        _longPressGestureRecognizer.cancelsTouchesInView = false
//        _longPressGestureRecognizer.minimumPressDuration = PRESS_TO_MOVE_MIN_DURATION
//        _longPressGestureRecognizer.delegate = self
        
        if let cV = collectionView {
        
            for gestureRecognizer in cV.gestureRecognizers! {
                
                if gestureRecognizer is UILongPressGestureRecognizer {
                    
                    gestureRecognizer.require(toFail: _longPressGestureRecognizer)
                }
            }
        }
        
        collectionView?.addGestureRecognizer(_longPressGestureRecognizer)
        
        _panGestureRecognizer.addTarget(self, action: #selector(panGestureRecognizerTriggerd))
        _panGestureRecognizer.delegate = self
        collectionView?.addGestureRecognizer(_panGestureRecognizer)
        
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
    }
    
    func removeGestureRecognizers() {
    
        _longPressGestureRecognizer.view?.removeGestureRecognizer(_longPressGestureRecognizer)
        _longPressGestureRecognizer.delegate = nil
        
        _panGestureRecognizer.view?.removeGestureRecognizer(_panGestureRecognizer)
        _panGestureRecognizer.delegate = nil
        
        NotificationCenter.default.removeObserver(self, forKeyPath: NSNotification.Name.UIApplicationWillResignActive.rawValue)
    }
    
//  MARK:- getter and setter implementation
    var dataSource: LxGridViewDataSource? {
        
        return collectionView?.dataSource as? LxGridViewDataSource
    }
    
    var delegate: LxGridViewDelegateFlowLayout? {
    
        return collectionView?.delegate as? LxGridViewDelegateFlowLayout
    }
    
    var editing: Bool {
    
        set {
            assert(collectionView is LxGridView || collectionView == nil, "LxGridViewFlowLayout: Must use LxGridView as your collectionView class!")
            
            if let gridView = collectionView as? LxGridView {
            
                gridView.editing = newValue
            }
        }
        get {
            assert(collectionView is LxGridView || collectionView == nil, "LxGridViewFlowLayout: Must use LxGridView as your collectionView class!")
            
            if let gridView = collectionView as? LxGridView {
                
                return gridView.editing
            }
            else {
                return false
            }
        }
    }

//  MARK:- override UICollectionViewLayout methods
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
    
        let layoutAttributesForElementsInRect = super.layoutAttributesForElements(in: rect)
        
        if let lxfeir = layoutAttributesForElementsInRect {
        
            for layoutAttributes in lxfeir {
                
                if let las = layoutAttributes as? UICollectionViewLayoutAttributes {
                    
                    if las.representedElementCategory == .cell {
                        
                        las.isHidden = las.indexPath == _movingItemIndexPath
                    }
                }
            }
        }
        
        return layoutAttributesForElementsInRect
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes! {
        
        let layoutAttributes = super.layoutAttributesForItem(at: indexPath)
        
        if layoutAttributes?.representedElementCategory == .cell {
            
            layoutAttributes?.isHidden = layoutAttributes?.indexPath == _movingItemIndexPath
        }
        
        return layoutAttributes
    }

//  MARK:-  长按 gesture
    func longPressGestureRecognizerTriggerd(longPress:UILongPressGestureRecognizer) {
    
        switch longPress.state {
        
        case .began:
            if _displayLink == nil {
                _displayLink = CADisplayLink(target: self, selector: #selector(displayLinkTriggered))
                _displayLink?.frameInterval = 6
                _displayLink?.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
            
                _remainSecondsToBeginEditing = MIN_PRESS_TO_BEGIN_EDITING_DURATION
            }
            print("\(editing)")
            if editing == false {
            
                return
            }
            
            _movingItemIndexPath = collectionView?.indexPathForItem(at: longPress.location(in: collectionView)) as? IndexPath
            
            if dataSource?.collectionView?(collectionView as! LxGridView, canMoveItemAtIndexPath: _movingItemIndexPath! as IndexPath) == false {
            
                _movingItemIndexPath = nil
                return
            }
            
            delegate?.collectionView?(collectionView as! LxGridView, layout: self, willBeginDraggingItemAtIndexPath: _movingItemIndexPath!)
            
            if _movingItemIndexPath == nil {
            
                return
            }
            
            let sourceCollectionViewCell = collectionView?.cellForItem(at: _movingItemIndexPath! as IndexPath)
            
            if sourceCollectionViewCell is LxOtherGridViewCell || sourceCollectionViewCell == nil {
                return
            }
            assert(sourceCollectionViewCell is LxGridViewCell || sourceCollectionViewCell == nil, "LxGridViewFlowLayout: Must use LxGridViewCell as your collectionViewCell class!")
                
            let sourceGridViewCell = sourceCollectionViewCell as! LxGridViewCell
            
//            CGRectOffset(x: , y: )
            
            
            _beingMovedPromptView = UIView(frame: CGRect.init(origin: (sourceCollectionViewCell?.frame.origin)!, size: CGSize(width: -LxGridView_DELETE_RADIUS, height: -LxGridView_DELETE_RADIUS)))
            
            sourceGridViewCell.isHighlighted = true
            let highlightedSnapshotView = sourceGridViewCell.snapshotView()
            highlightedSnapshotView.frame = sourceGridViewCell.bounds
            highlightedSnapshotView.alpha = 1
            
            sourceGridViewCell.isHighlighted = false
            let snapshotView = sourceGridViewCell.snapshotView()
            snapshotView.frame = sourceGridViewCell.bounds
            snapshotView.alpha = 0
            
            _beingMovedPromptView?.addSubview(snapshotView)
            _beingMovedPromptView?.addSubview(highlightedSnapshotView)
            collectionView?.addSubview(_beingMovedPromptView!)
            
            let kVibrateAnimation = "kVibrateAnimation"
            let VIBRATE_DURATION: CGFloat = 0.1
            let VIBRATE_RADIAN = CGFloat(Double.pi/96)
            
            let vibrateAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            vibrateAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            vibrateAnimation.fromValue = -VIBRATE_RADIAN
            vibrateAnimation.toValue = VIBRATE_RADIAN
            vibrateAnimation.autoreverses = true
            vibrateAnimation.duration = CFTimeInterval(VIBRATE_DURATION)
            vibrateAnimation.repeatCount = Float(CGFloat.greatestFiniteMagnitude)
            _beingMovedPromptView?.layer.add(vibrateAnimation, forKey: kVibrateAnimation)
            
            _sourceItemCollectionViewCellCenter = sourceGridViewCell.center
            
            UIView.animate(withDuration: 0, delay: 0, options: .beginFromCurrentState, animations: { () -> Void in
                
                highlightedSnapshotView.alpha = 0
                snapshotView.alpha = 1
                
            }, completion: { [unowned self] (finished) -> Void in
                
                highlightedSnapshotView.removeFromSuperview()
                
                self.delegate?.collectionView?(self.collectionView as! LxGridView, layout: self, didBeginDraggingItemAtIndexPath: self._movingItemIndexPath!)
            })
            
            invalidateLayout()
            
        case .ended:
            fallthrough
        case .cancelled:
            _displayLink?.invalidate()
            _displayLink = nil
            
            if let movingItemIndexPath = _movingItemIndexPath {
            
                delegate?.collectionView?(collectionView as! LxGridView, layout: self, willEndDraggingItemAtIndexPath: movingItemIndexPath)
                
                _movingItemIndexPath = nil
                _sourceItemCollectionViewCellCenter = CGPoint.zero
                
                let movingItemCollectionViewLayoutAttributes = layoutAttributesForItem(at: movingItemIndexPath as IndexPath)
                
                _longPressGestureRecognizer.isEnabled = false
                
                UIView.animate(withDuration:0, delay: 0, options: .beginFromCurrentState, animations: { [unowned self] () -> Void in
                    
                    self._beingMovedPromptView!.center = (movingItemCollectionViewLayoutAttributes?.center)!
                }, completion: { [unowned self] (finished) -> Void in
                    
                    self._longPressGestureRecognizer.isEnabled = true
                    self._beingMovedPromptView?.removeFromSuperview()
                    self._beingMovedPromptView = nil
                    self.invalidateLayout()
                    self.delegate?.collectionView?(self.collectionView as! LxGridView, layout: self, didEndDraggingItemAtIndexPath: movingItemIndexPath)
                })
            }
        default:
            break
        }
    }
    
    func panGestureRecognizerTriggerd(pan: UIPanGestureRecognizer) {
    
        switch pan.state {
        
        case .began:
            fallthrough
        case .changed:
            let panTranslation = pan.translation(in: collectionView!)
            print("\(panTranslation)")
            _beingMovedPromptView?.center = _sourceItemCollectionViewCellCenter + panTranslation
            let sourceIndexPath = _movingItemIndexPath
            if _beingMovedPromptView == nil {
                return
            }
            print("\(_beingMovedPromptView)")
            let destinationIndexPath = collectionView?.indexPathForItem(at: (_beingMovedPromptView?.center)!)
            
            if destinationIndexPath == nil || destinationIndexPath == sourceIndexPath {
                return
            }
            
            if dataSource?.collectionView?(collectionView as! LxGridView, itemAtIndexPath: sourceIndexPath!, canMoveToIndexPath: destinationIndexPath!) == false {
                return
            }
            
            dataSource?.collectionView?(collectionView as! LxGridView, itemAtIndexPath: sourceIndexPath!, willMoveToIndexPath: destinationIndexPath!)
            
            
            _movingItemIndexPath = destinationIndexPath
            collectionView?.performBatchUpdates({ [unowned self] () -> Void in
                self.collectionView?.deleteItems(at: [sourceIndexPath!])
                self.collectionView?.insertItems(at: [destinationIndexPath!])
            }, completion: { [unowned self] (finished) -> Void in

                if (self.dataSource != nil) && (self.dataSource?.responds(to: #selector(LxGridViewDataSource.collectionView(_:itemAtIndexPath:didMoveToIndexPath:))))! {
                    self.dataSource?.collectionView!(self.collectionView as! LxGridView, itemAtIndexPath: sourceIndexPath!, didMoveToIndexPath:  destinationIndexPath!)
                }
            })
            
        default:
            break
        }
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if _panGestureRecognizer == gestureRecognizer && editing {
            
            return _movingItemIndexPath != nil
        }
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if _longPressGestureRecognizer == gestureRecognizer {
            return _panGestureRecognizer == otherGestureRecognizer
        }
        if _panGestureRecognizer == gestureRecognizer {
            return _longPressGestureRecognizer == otherGestureRecognizer
        }
        return false
    }
    
//  MARK:- displayLink
    
    func displayLinkTriggered(displayLink: CADisplayLink) {
    
//        if _remainSecondsToBeginEditing <= 0 {
//
//            editing = true
//            _displayLink?.invalidate()
//            _displayLink = nil
//        }
//
//        _remainSecondsToBeginEditing = _remainSecondsToBeginEditing - 0.1
    }
    
//  MARK:- KVO and notification
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "collectionView" {
        
            if collectionView != nil {
            
                addGestureRecognizers()
            }
            else {
            
                removeGestureRecognizers()
            }
        }
    }
    
    func applicationWillResignActive(notificaiton: NSNotification) {
    
        _panGestureRecognizer.isEnabled = false
        _panGestureRecognizer.isEnabled = true
    }
}

private func == (left: NSIndexPath, right: NSIndexPath) -> Bool {

    return left.section == right.section && left.item == right.item
}

func + (point: CGPoint, offset: CGPoint) -> CGPoint {
    
    return CGPoint(x: point.x + offset.x, y: point.y + offset.y)
}
