//
//  File.swift
//  
//
//  Created by Juliano Goncalves Alvarenga on 22/10/19.
//

import UIKit
import UIViewExtensionsSPM

open class CardViewVC: UIViewController {
    
    public let cardView = CardView()
    public var bindableTransformValue = Bindable<CGFloat>()
    public var bindableDraggingValue = Bindable<UIGestureRecognizer>()
    public var bindableAction = Bindable<String>()
    public var isPresenting = false
    private var cardViewHeight = UIScreen.main.bounds.height
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .custom
        transitioningDelegate = self
//                forceLightMode()
//        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(panGesture))
//        cardView.addGestureRecognizer(gesture)
    }
    
   
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupCardView()
        setupTargets()
    }
    
    /// - Parameter sender: The gesture passed with closures using bindable function observer
    @objc fileprivate func handleGesture(_ sender: UIGestureRecognizer) {
        bindableAction.value = sender.name
    }
    
    
    //MARK: - Setup
    
    public func setupCardViewStyle(closeViewColor: UIColor, headerViewColor: UIColor, backgroundColor: UIColor, isHasHeader: Bool, height: CGFloat) {
        cardView.closeView.backgroundColor = closeViewColor
        cardView.headerView.backgroundColor = headerViewColor
        cardView.backgroundColor = backgroundColor
        cardView.setupCardViewContainer(itHasHeader: isHasHeader)
        setupHeight(for: height)
    }
    
    public func setupHeight(for size: CGFloat) {
        cardViewHeight = size
    }

    public func setupCardView() {
        view.backgroundColor = .clear
        view.addSubview(backdropView)
        backdropView.addGestureRecognizer(bodyTapGesture)
        view.addSubview(cardView)
        cardView.heightAnchor.constraint(equalToConstant: cardViewHeight).isActive = true
        cardView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
    }
    
    public func setupContainer(with thisView: UIView) {
        cardView.containerView.addSubview(thisView)
        thisView.fillSuperview()
    }
    
    
    fileprivate func setupTargets() {
        cardView.headerView.gestureRecognizers?.forEach({ (gesture) in
            gesture.addTarget(self, action: #selector(handleGesture(_:)))
        })
        bodyTapGesture.addTarget(self, action: #selector(handleGesture(_:)))
    }
    
//    @objc func panGesture(recognizer: UIPanGestureRecognizer) {
//        let translation = recognizer.translation(in: self.cardView)
//        let y = self.cardView.frame.minY
//        self.cardView.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: cardView.frame.height)
//        recognizer.setTranslation(.zero, in: self.cardView)
//    }
    
    var backdropView: UIView = {
        let bdView = UIView(frame: UIScreen.main.bounds)
        bdView.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        return bdView
    }()
    
    let bodyTapGesture: UITapGestureRecognizer = {
        let c = UITapGestureRecognizer()
        c.name = CardViewActions.dismiss.rawValue
        return c
    }()
    
    let navTapGesture: UITapGestureRecognizer = {
        let c = UITapGestureRecognizer()
        return c
    }()
    
    let bodyDarkerView: UIView = {
        let c = UIView()
        c.alpha = 0
        c.frame = .zero
        return c
    }()
    
    //MARK: - Keyboard Notification
    
    public var focustextField: UITextField?
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyBoardNotification()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        focustextField?.becomeFirstResponder()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            bindableTransformValue.value = keyboardHeight
        }
    }
    
    //Subscriptions
    fileprivate func keyBoardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
}

//MARK: - Custom Transition
extension CardViewVC: UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        guard let toVC = toViewController else { return }
        isPresenting = !isPresenting
        
        if isPresenting == true {
            containerView.addSubview(toVC.view)
            
            cardView.frame.origin.y += cardViewHeight
            backdropView.alpha = 0
            
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.cardView.frame.origin.y -= self.cardViewHeight
                self.backdropView.alpha = 1
            }, completion: { (_) in
                transitionContext.completeTransition(true)
            })
        } else {
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.cardView.frame.origin.y += self.cardViewHeight
                self.backdropView.alpha = 0
            }, completion: { (_) in
                transitionContext.completeTransition(true)
            })
        }
    }
}

public enum CardViewActions: String {
    
    case toLoginVC = "toLoginVC"
    case toMainVC = "toMainVC"
    case upLoad = "upLoad"
    case dismiss = "dismiss"
    case transform = "transform"
}
