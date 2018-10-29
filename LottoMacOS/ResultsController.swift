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
            DispatchQueue.main.async {
                switch response {
                case .error(let error):
                    self?.display(error: error)
                case .value(let results):
                    self?.display(results: results)
                }
            }
        }
    }
    
    private func display(results: LotteriesResults) {
        let views = results.displayableResults.map { makeResultView(icon: $0, result: $1) }
        let stackView = NSStackView(frame: NSRect(x: 0, y: 0, width: 300, height: 10))
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.orientation = .vertical
        stackView.alignment = .left
        stackView.layout()
        views.forEach { stackView.addArrangedSubview($0) }
        resultsItem.view = stackView
    }
    
    private func makeResultView(icon: NSImage, result: LotteryResult) -> ResultView {
        let view = ResultView.makeNew()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.resultsLabel.stringValue = result.resultsText
        view.dateLabel.stringValue = dateFormatter.string(from: result.date)
        view.imageView.image = icon
        return view
    }
    
    private func display(error: Error) {
        resultsItem.title = "Error fetching data :("
    }
}

extension LotteryResult {
    
    var resultsText: String {
        return numbers.map { String($0) }.joined(separator: ", ")
    }
}

extension LotteriesResults {
    
    var displayableResults: [(icon: NSImage, result: LotteryResult)] {
        let mapping = [(NSImage(named: "lotto")!, lotto),
                       (NSImage(named: "plus")!, lottoPlus),
                       (NSImage(named: "mini")!, mini)]
        return mapping.compactMap {
            guard let result = $1 else { return nil }
            return ($0, result)
        }
    }
}
