import Foundation
import UIKit

class ActivityIndicatorViewController: NSObject {
    
    var activityView: UIActivityIndicatorView?
    var view: UIView?
    
    static let sharedInstance:ActivityIndicatorViewController = {
        let instance = ActivityIndicatorViewController ()
        return instance
    } ()
    
    override init() {
        view = UIView(frame: UIScreen.main.bounds)
        if #available(iOS 13.0, *) {
            activityView = UIActivityIndicatorView(style: .large)
        } else {
            // Fallback on earlier versions
            activityView = UIActivityIndicatorView(style: .whiteLarge)
        }
    }
    
    func startIndicator() {
        makeVisible()
        activityView?.startAnimating()
    }
    
    func stopIndicator() {
        DispatchQueue.main.async {
            self.view?.removeFromSuperview()
            self.activityView?.stopAnimating()
        }
    }
    
    func makeVisible() {
        let appDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
        if(view?.superview != nil){
            view?.removeFromSuperview()
            activityView?.stopAnimating()
        }
        activityView?.center = (view?.center)!
        view?.addSubview(activityView!)
        view?.backgroundColor = UIColor.black
        view?.alpha = 0.7
        if appDelegate?.window != nil {
            appDelegate?.window?.addSubview(view!)
        }
    }
    
}

