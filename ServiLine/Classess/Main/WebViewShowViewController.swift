//
//  WebViewShowViewController.swift
//  ServiLine
//
//  Created by Rohit Singh Dhakad on 13/03/22.
//

import UIKit
import WebKit


class WebViewShowViewController: UIViewController {
    
    @IBOutlet var webVw: WKWebView!
    @IBOutlet var lblTitle: UILabel!
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    
    var strIsComingFrom = ""
    var strUrl = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webVw.navigationDelegate = self
        
        self.lblTitle.text = self.strIsComingFrom
        // Do any additional setup after loading the view.
        
        switch strIsComingFrom {
        case "Condition Of Use":
            self.loadUrl(strUrl: "https://ambitious.in.net/Arun/serviline/index.php/api/page/Conditions%20of%20use")
        case "Privacy Check":
            self.loadUrl(strUrl: "https://ambitious.in.net/Arun/serviline/index.php/api/page/Privacy%20Policy")
        case "Cookies Privacy":
            self.loadUrl(strUrl: "https://ambitious.in.net/Arun/serviline/index.php/api/page/Cookies%20Policy")
        case "About Us":
            self.loadUrl(strUrl: "https://ambitious.in.net/Arun/serviline/index.php/api/page/About%20Us")
        case "Document":
            self.loadUrl(strUrl: self.strUrl)
        default:
            self.loadUrl(strUrl: "https://ambitious.in.net/Arun/serviline/index.php/api/page/Contact%20and%20Suggestions")
        }
       
        
    }
    

    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
    
    func loadUrl(strUrl:String){
        let url = NSURL(string: strUrl)
        if url != nil{
            let request = NSURLRequest(url: url! as URL)
            self.webVw.load(request as URLRequest)
        }else{
            objAlert.showAlertSingleButtonCallBack(alertBtn: "OK", title: "Failed!", message: "Url not found", controller: self) {
                self.onBackPressed()
            }
        }
    }
    
    
    
    func showActivityIndicator(on parentView: UIView) {
       
        activityIndicator.startAnimating()
        activityIndicator.color = UIColor.black
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false

        parentView.addSubview(activityIndicator)

        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: parentView.centerYAnchor),
        ])
    }
    

}


extension WebViewShowViewController: WKNavigationDelegate{
    
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
        self.showActivityIndicator(on: self.webVw)
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
        
    }
}
