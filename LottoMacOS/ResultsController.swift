//
//  ResultsController.swift
//  LottoMacOS
//
//  Created by Michal Moskala on 26/10/2018.
//  Copyright © 2018 Michal Moskala. All rights reserved.
//

import Cocoa
import LottoAPI

final class ResultsController: NSObject {
    
    private let client = LottoAPI.makeClient(baseURL: URL(string: "http://serwis.mobilotto.pl")!)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func quitSelected(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func refreshSelected(_ sender: NSMenuItem) {
        print("fetching...")
        client.getNewestResults { response in
            switch response {
            case .error(_):
                print("failed!");
            case .value(_):
                print("fetched!")
            }
        }
    }
    
}
