
import UIKit
import UIViewExtensionsSPM

public class CardView: UIView {
    
    let headerView: UIView = {
        let c = UIView()
        return c
    }()
    
    let closeView: UIView = {
        let c = UIView()
        c.layer.cornerRadius = 2
        c.clipsToBounds = true
        return c
    }()
    
    let tapGesture: UITapGestureRecognizer = {
        let c = UITapGestureRecognizer()
        c.name = "dismiss"
        return c
    }()
    
    let panGesture: UIPanGestureRecognizer = {
        let c = UIPanGestureRecognizer()
        c.name = "pan"
        return c
    }()
    
    public let containerView: UIView = {
        let c = UIView()
        return c
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //VIEW
        layer.cornerRadius = 12
        clipsToBounds = true
                                
    }
    
    public func setupCardViewContainer(itHasHeader: Bool) {        
        //Container
        addSubview(containerView)
        
        if itHasHeader {
            //HEADER
            addSubview(headerView)
            headerView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, size: .init(width: 0, height: 40))
            headerView.addSubview(closeView)
            closeView.centerInSuperview(size: .init(width: 60, height: 4))
            headerView.addGestureRecognizer(tapGesture)
            headerView.addGestureRecognizer(panGesture)
            
            containerView.anchor(top: headerView.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        } else {
            containerView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        }
       }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    
}

