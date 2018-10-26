//
//  AppDelegate.swift
//  LottoMacOS
//
//  Created by Michal Moskala on 25/10/2018.
//  Copyright © 2018 Michal Moskala. All rights reserved.
//

import Cocoa
import LottoAPI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var menu: NSMenu!
    
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        statusItem.title = "Lotto"
        statusItem.menu = menu
        
        let url = URL(string: "http://serwis.mobilotto.pl")!
        let client = LottoAPI.makeClient(baseURL: url)
        client.getNewestResults { (response) in
            switch response {
            case .value(_):
                print("works")
            case .error(let error):
                print("error \(error)")
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    
    @IBAction func quitSelected(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
}

