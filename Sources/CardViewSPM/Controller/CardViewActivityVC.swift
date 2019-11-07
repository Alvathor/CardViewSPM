//
//  File.swift
//  
//
//  Created by Juliano Goncalves Alvarenga on 07/11/19.
//

import UIKit


// UIActivityViewController with the default behavior but with custom controller inside
public class CardViewActivityVC: UIActivityViewController {
    
    private var wrapperController: WrapperController?
    
    override init(activityItems: [Any], applicationActivities: [UIActivity]?) {
        super.init(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    
    public init(innerController: UIViewController) {
        super.init(activityItems: [], applicationActivities: nil)
        self.wrapperController = WrapperController(innerController: innerController)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.subviews.forEach({$0.removeFromSuperview()})
        view.backgroundColor = .white
        view.subviews.forEach({$0.removeFromSuperview()})
        guard let vc = wrapperController else { return }
        view.addSubview(vc.view)
    }
}

// Wrapper is neccessarie in order to have a navigation controller inside the UIActivityViewController
class WrapperController: UIViewController {
    
    var navController: UINavigationController?
    
    init(innerController: UIViewController) {
        super.init(nibName: nil, bundle: nil)
        self.navController = UINavigationController(rootViewController: innerController)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .white
        guard let vc = navController else { return }
        view.addSubview(vc.view)
        vc.view.fillSuperview()
    }
}
