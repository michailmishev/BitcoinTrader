//
//  ViewController.swift
//  BitcoinTrader
//
//  Created by Michail Mishev on 5/12/17.
//  Copyright © 2017 Michail Mishev. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var finalURL = ""
    let currencySymbolsArray = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var selectedCurrencySymbol = ""
    
    
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
    }


    
    
    //UIPickerView delegate methods:
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    
    
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        print(currencyArray[row])
        
        finalURL = baseURL + currencyArray[row]
        print(finalURL)
        
        selectedCurrencySymbol = currencySymbolsArray[row]
        
        getBitcoinData(url: finalURL)
        
    }
    
    
    
    
    //Networking:
    
    func getBitcoinData(url: String) {
        
        Alamofire.request(url, method: .get).responseJSON {
            response in
            if response.result.isSuccess {
                
                print("Sucess! Got the bitcoin data")
                let bitcoinJSON: JSON = JSON(response.result.value!)
                self.updateBitcoinData(json: bitcoinJSON)
                
            } else {
                
                print("Error: \(String(describing: response.result.error))")
                self.bitcoinPriceLabel.text = "Contection Issues"
                
            }
        }
        
    }
    
    
    
    func updateBitcoinData(json: JSON) {
        
        if let bitcoinResult = json["last"].double {
            
            bitcoinPriceLabel.text = "\(selectedCurrencySymbol) \(bitcoinResult)"
            
        } else {
            bitcoinPriceLabel.text = "Price Unavailable"
        }
        
    }
    


}

