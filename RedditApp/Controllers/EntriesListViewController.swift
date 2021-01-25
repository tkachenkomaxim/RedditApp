//
//  EntriesListViewController.swift
//  RedditApp
//
//  Created by Maxim Tkachenko on 24.01.2021.
//

import Foundation
import UIKit

class EntriesListViewController: UITableViewController {

    static let showImageSegueIdentifier = "showImageSegue"
    let viewModel = EntriesListViewModel(withClient: RedditProvider())
    fileprivate var activityIndicator: LoadMoreActivityIndicator!
    
    let loadingView = UIView()
    let spinner = UIActivityIndicatorView()
    let loadingLabel = UILabel()

    let errorLabel = UILabel()
    let tableFooterView = UIView()
    let moreButton = UIButton(type: .system)
    var urlToDisplay: URL?

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.configureViews()
        self.loadEntries()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animate(alongsideTransition: { [weak self] (context) in
            
            self?.configureErrorLabelFrame()
            
        }, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        super.prepare(for: segue, sender: sender)
        
        if segue.identifier == EntriesListViewController.showImageSegueIdentifier {
            
            if let urlViewController = segue.destination as? FullImageViewController {
                
                urlViewController.url = self.urlToDisplay
            }
        }
    }

    @objc func retryFromErrorToolbar() {
        
        self.loadEntries()
        self.dismissErrorToolbar()
    }
    
    @objc func dismissErrorToolbar() {
        
        self.navigationController?.setToolbarHidden(true, animated: true)
    }
    
    private func loadEntries() {

        setLoadingScreen()
        self.viewModel.loadEntries {
            
            self.entriesReloaded()
        }
    }
    
    private func configureViews() {
        self.view.backgroundColor = UIColor(hexString: "EEEEEE")
        self.tableView.backgroundColor = UIColor(hexString: "EEEEEE")
        configureTableView()
        configureToolbar()
    }
    
    func configureTableView() {
        activityIndicator = LoadMoreActivityIndicator(scrollView: tableView, spacingFromLastCell: 10, spacingFromLastCellWhenLoadMoreActionStart: 35)
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "EnrtyTableViewCell", bundle: nil), forCellReuseIdentifier: EntryTableViewCell.cellId)
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 110.0
        
        self.tableFooterView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 80)
    }
    
    func configureToolbar() {
        
        self.configureErrorLabelFrame()
        
        let errorItem = UIBarButtonItem(customView: self.errorLabel)
        let flexSpaceItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let retryItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(EntriesListViewController.retryFromErrorToolbar))
        let fixedSpaceItem = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        let closeItem = UIBarButtonItem(image: UIImage(named: "close-button"), style: .plain, target: self, action: #selector(EntriesListViewController.dismissErrorToolbar))
        
        fixedSpaceItem.width = 12
        
        self.toolbarItems = [errorItem, flexSpaceItem, retryItem, fixedSpaceItem, closeItem]
    }
    
    private func configureErrorLabelFrame() {
        
        self.errorLabel.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width - 92, height: 22)
    }
    
    private func entriesReloaded() {
        
        self.activityIndicator.stop()
        removeLoadingScreen()
        self.tableView.reloadData()
        
        self.tableView.tableFooterView = self.tableFooterView
        self.moreButton.isEnabled = true
        
        if self.viewModel.hasError {

            self.errorLabel.text = self.viewModel.errorMessage
            self.navigationController?.setToolbarHidden(false, animated: true)
        }
    }
    
    private func setLoadingScreen() {
          let width: CGFloat = 120
          let height: CGFloat = 30
          let x = (tableView.frame.width / 2) - (width / 2)
          let y = (tableView.frame.height / 2) - (height / 2) - (navigationController?.navigationBar.frame.height)!
          loadingView.frame = CGRect(x: x, y: y, width: width, height: height)

          loadingLabel.textColor = .gray
          loadingLabel.textAlignment = .center
          loadingLabel.text = "Loading..."
          loadingLabel.frame = CGRect(x: 0, y: 0, width: 140, height: 30)

          spinner.style = .medium
          spinner.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
          spinner.startAnimating()

          loadingView.addSubview(spinner)
          loadingView.addSubview(loadingLabel)

          tableView.addSubview(loadingView)
      }
    
    private func removeLoadingScreen() {
        spinner.stopAnimating()
        spinner.isHidden = true
        loadingLabel.isHidden = true
        
    }
}

extension EntriesListViewController { // UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.viewModel.entries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let entryTableViewCell = tableView.dequeueReusableCell(withIdentifier: EntryTableViewCell.cellId, for: indexPath as IndexPath) as! EntryTableViewCell
        
        entryTableViewCell.entry = self.viewModel.entries[indexPath.row]
        entryTableViewCell.delegate = self
        
        return entryTableViewCell
    }
}

extension EntriesListViewController: EntryTableViewCellDelegate {
 
    func presentImage(withURL url: URL) {
        
        self.urlToDisplay = url
        self.performSegue(withIdentifier: EntriesListViewController.showImageSegueIdentifier, sender: self)
    }
}

extension EntriesListViewController {
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        activityIndicator.start {
            self.viewModel.loadEntries {
                DispatchQueue.main.async { [weak self] in
                    self?.activityIndicator.stop()
                    self?.entriesReloaded()
                }
            }
            
        }
    }
}
