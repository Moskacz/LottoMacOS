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
    
    @IBOutlet private weak var menu: NSMenu!
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private let client = LottoAPI.makeClient(baseURL: URL(string: "http://serwis.mobilotto.pl")!)
    
    private var fetchingTask: URLSessionDataTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        statusItem.menu = menu
        let icon = NSImage(named: "status_icon")
        statusItem.image = icon
    }
    
    @IBAction func quitSelected(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    @IBAction func refreshSelected(_ sender: NSMenuItem) {
        fetchingTask?.cancel()
        print("fetching...")
        fetchingTask = client.getNewestResults { response in
            switch response {
            case .error(_):
                print("failed!");
            case .value(_):
                print("fetched!")
            }
        }
    }
    
}
