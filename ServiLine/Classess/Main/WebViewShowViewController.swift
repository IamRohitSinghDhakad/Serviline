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
    
    
    var strIsComingFrom = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lblTitle.text = self.strIsComingFrom
        // Do any additional setup after loading the view.
        
        switch strIsComingFrom {
        case "Condition Of Use":
            self.loadUrl(strUrl: "https://ambitious.in.net/Arun/serviline/index.php/api/page/Conditions%20of%20use")
        case "Privacy Check":
            self.loadUrl(strUrl: "https://ambitious.in.net/Arun/serviline/index.php/api/page/Privacy%20Policy")
        default:
            self.loadUrl(strUrl: "https://www.google.com")
        }
       
        
    }
    

    @IBAction func btnBackOnHeader(_ sender: Any) {
        onBackPressed()
    }
    
    
    func loadUrl(strUrl:String){
             let url = NSURL(string: strUrl)
             let request = NSURLRequest(url: url! as URL)
        self.webVw.load(request as URLRequest)
         }
      

}


extension WebViewShowViewController: WKNavigationDelegate{
    
    private func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        print(error.localizedDescription)
    }
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("Strat to load")
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("finish to load")
    }
}
