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
    @IBOutlet weak var resultsItem: NSMenuItem!
    
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
        fetchingTask = client.getNewestResults { [weak self] response in
            switch response {
            case .error(_):
                print("failed!");
            case .value(let results):
                DispatchQueue.main.async {
                    self?.display(results: results)
                }
            }
        }
    }
    
    private func display(results: LotteriesResults) {
        let labeledResults = [("lotto", results.lotto), ("plus", results.lottoPlus), ("mini", results.mini)]
        let views = labeledResults.compactMap { labeledResult -> NSView? in
            guard let result = labeledResult.1 else { return nil }
            let field = NSTextField()
            field.stringValue = [labeledResult.0, result.textDescription].joined(separator: ": ")
            field.isBezeled = false
            field.isEditable = false
            return field
        }
        
        let stackView = NSStackView(frame: NSRect(x: 0, y: 0, width: 100, height: 100))
        stackView.orientation = .vertical
        views.forEach { stackView.addArrangedSubview($0) }
        resultsItem.view = stackView
    }
}

extension LotteryResult {
    
    var textDescription: String {
        return numbers.map { String($0) }.joined(separator: ", ")
    }
}
