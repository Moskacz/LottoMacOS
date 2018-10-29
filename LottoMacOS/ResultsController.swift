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
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
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
        fetchingTask = client.getNewestResults { [weak self] response in
            switch response {
            case .error(_):
                break
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
            let view = ResultView.makeNew()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.resultsLabel.stringValue = [labeledResult.0, result.textDescription].joined(separator: ": ")
            view.dateLabel.stringValue = self.dateFormatter.string(from: result.date)
            view.layout()
            return view
        }
        
        let stackView = NSStackView(frame: NSRect(x: 0, y: 0, width: 300, height: 10))
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.orientation = .vertical
        stackView.alignment = .left
        views.forEach { stackView.addArrangedSubview($0) }
        resultsItem.view = stackView
    }
}

extension LotteryResult {
    
    var textDescription: String {
        return numbers.map { String($0) }.joined(separator: ", ")
    }
}
