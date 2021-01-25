//
//  FullImageViewController.swift
//  RedditApp
//
//  Created by Maxim Tkachenko on 25.01.2021.
//

import Foundation
import UIKit
import WebKit

class FullImageViewController: UIViewController {
    
    var url: URL?
    
    @IBOutlet weak var webView: WKWebView!
    
    fileprivate let activityIndicatorView = UIActivityIndicatorView(style: .medium)

    override func viewDidLoad() {
        
        super.viewDidLoad()
        webView?.navigationDelegate = self
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.activityIndicatorView)
        self.activityIndicatorView.startAnimating()

        if let url = url {
        
            self.webView?.load(URLRequest(url: url))
        }
    }
}

extension FullImageViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.activityIndicatorView.stopAnimating()
    }
}
