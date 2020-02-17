//
//  File.swift
//  
//
//  Created by Juliano Goncalves Alvarenga on 07/11/19.
//

import UIKit


// UIActivityViewController with the default behavior but with custom controller inside
public final class CardViewActivityVC: UIActivityViewController {
    
    private var navController: UINavigationController?
    
    override init(activityItems: [Any], applicationActivities: [UIActivity]?) {
        super.init(activityItems: activityItems, applicationActivities: applicationActivities)
    }
    
    public init(innerController: UIViewController) {
        super.init(activityItems: [], applicationActivities: nil)
        self.navController = UINavigationController(rootViewController: innerController)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.subviews.forEach({$0.removeFromSuperview()})
        view.backgroundColor = .white
        view.subviews.forEach({$0.removeFromSuperview()})
        guard let vc = navController else { return }
        view.addSubview(vc.view)
        vc.view.fillSuperview()
    }
}
