//
//  ExchangerViewController.swift
//  ExchangeRates
//
//  Created by Vladimir on 03.06.2019.
//  Copyright © 2019 Vladimir. All rights reserved.
//

import UIKit

class ExchangerViewController: UIViewController {

    @IBOutlet weak var tfBitcoin: UITextField!
    @IBOutlet weak var tfExchange: UITextField!

    var rate:ExchangeRate?
    var factor:Float = 0.0
    
    let sNibName = "ExchangerView"
    
    init() {
        super.init(nibName: sNibName, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        guard let rate = self.rate else { return }
        
        title = "Exchange Result for " + rate.sCurrencyCode
        
        factor = rate.nLastRate
        tfBitcoin.text = "1"
        tfExchange.text = "\(rate.nLastRate)"
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(closeKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(bitcoinDidChange(_:)), name: UITextField.textDidChangeNotification, object: tfBitcoin)
        NotificationCenter.default.addObserver(self, selector: #selector(currencyDidChange(_:)), name: UITextField.textDidChangeNotification, object: tfExchange)
    }
    
    
}

extension ExchangerViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func closeKeyboard(){
        self.view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool { // return NO to not change text
        
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            return true
        case ".":
            guard let text = textField.text else { return true }
            let array = Array(text)
            var decimalCount = 0
            for character in array {
                if character == "." {
                    decimalCount += 1
                }
            }
            
            if decimalCount == 1 {
                return false
            } else {
                return true
            }
        default:
            let array = Array(string)
            if array.count == 0 {
                return true
            }
            return false
        }
    }
    
    @objc private func bitcoinDidChange(_ notification: Notification) {
        let bit = Float(tfBitcoin.text ?? "") ?? 0.0
        let update = bit * factor
        var updateString = update < 1 ? "\(update)" :String(format: "%.2f", update)
        if update == 0.0 { updateString = "" }
        tfExchange.text = updateString
    }
    @objc private func currencyDidChange(_ notification: Notification) {
        let cur = Float(tfExchange.text ?? "") ?? 0.0
        let update = cur / factor
        var updateString = update < 1 ? "\(update)" :String(format: "%.2f", update)
        if update == 0.0 { updateString = "" }
        tfBitcoin.text = updateString
    }
    
}
