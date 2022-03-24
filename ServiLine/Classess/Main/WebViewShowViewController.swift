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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.loadUrl(strUrl: "https://www.google.com")
        
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
