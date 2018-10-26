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
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

