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

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
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


}

