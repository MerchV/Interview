//
//  BaseOperation.swift
//  Interview
//
//  Created by Merch on 2018-01-21.
//  Copyright © 2018 Merch. All rights reserved.
//

import UIKit

class BaseOperation: Operation {

    override var isAsynchronous: Bool {
        return true
    }

    private var _executing : Bool = false
    override var isExecuting : Bool {
        get { return _executing }
        set {
            guard _executing != newValue else { return }
            willChangeValue(forKey: "isExecuting")
            _executing = newValue
            didChangeValue(forKey: "isExecuting")
        }
    }


    private var _cancelled : Bool = false
    override var isCancelled : Bool {
        get { return _cancelled }
        set {
            guard _cancelled != newValue else { return }
            willChangeValue(forKey: "isCancelled")
            _cancelled = newValue
            didChangeValue(forKey: "isCancelled")
        }
    }

    private var _finished : Bool = false
    override var isFinished : Bool {
        get { return _finished }
        set {
            guard _finished != newValue else { return }
            willChangeValue(forKey: "isFinished")
            _finished = newValue
            didChangeValue(forKey: "isFinished")
            willChangeValue(forKey: "isExecuting")
            _executing = false
            didChangeValue(forKey: "isExecuting")
        }
    }

    var baseUrl: URL
    var succeeded = false
    var coreDataManager: CoreDataManager?

    override init() {
        let endpointsUrl = Bundle.main.url(forResource: "Endpoints", withExtension: "plist")
        let endpointsDictionary = NSDictionary(contentsOf: endpointsUrl!)
        let protocolString = endpointsDictionary!["protocol"]!
        let hostString = endpointsDictionary!["host"]!
        let portString = endpointsDictionary!["port"]!
        let pathString = endpointsDictionary!["path"]!
        let baseUrlString = "\(protocolString)\(hostString):\(portString)\(pathString)"
        baseUrl = URL(string: baseUrlString)!
        super.init()
    }

}
