//
//  ResultView.swift
//  LottoMacOS
//
//  Created by Michal Moskala on 27/10/2018.
//  Copyright © 2018 Michal Moskala. All rights reserved.
//

import Cocoa

class ResultView: NSView {

    class func makeNew() -> ResultView {
        var array: NSArray? = NSArray()
        Bundle.main.loadNibNamed("ResultView", owner: nil, topLevelObjects: &array)
        return array!.first { $0 is ResultView } as! ResultView
    }
    
    @IBOutlet weak var imageView: NSImageView!
    @IBOutlet weak var resultsLabel: NSTextField!
    @IBOutlet weak var dateLabel: NSTextField!
}
