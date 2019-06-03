//
//  BrowserViewController.swift
//  ExchangeRates
//
//  Created by Vladimir on 03.06.2019.
//  Copyright © 2019 Vladimir. All rights reserved.
//

import UIKit
import RealmSwift

class BrowserViewController: UITableViewController {
    let sCellName = "CurrencyCellView"
    
    var notificationToken: NotificationToken? = nil
    var results = try! Realm().objects(ExchangeRate.self)
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        ERManager.shared.update()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cellNib = UINib.init(nibName: sCellName, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: sCellName)
        

        // Observe Results Notifications
        notificationToken = results.observe { [weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            switch changes {
            case .initial:
                // Results are now populated and can be accessed without blocking the UI
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let modifications):
                // Query results have changed, so apply them to the UITableView
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}), with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }), with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
}

extension BrowserViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: sCellName, for: indexPath) as! CurrencyCellView
        
        let rate = self.results[indexPath.row]
        cell.priceLabel.text = "\(rate.nLastRate) \(rate.sCurrencySymbol)"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.results.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let viewController = ExchangerViewController.init()
        viewController.rate = results[indexPath.row]
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}
