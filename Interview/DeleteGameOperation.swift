//
//  DeleteGameOperation.swift
//  Interview
//
//  Created by Merch on 2018-01-29.
//  Copyright © 2018 Merch. All rights reserved.
//

import UIKit

class DeleteGameOperation: BaseOperation {

    private var id: Int64

    init(coreDataManager: CoreDataManager, id: Int64) {
        self.id = id
        super.init()
        self.coreDataManager = coreDataManager
    }

    override func start() {
        baseUrl.appendPathComponent("Games")
        baseUrl.appendPathComponent("\(id)")

        let backgroundManagedObjectContext = coreDataManager!.newBackgroundManagedObjectContext()

        var request = URLRequest(url: baseUrl)
        request.httpMethod = "DELETE"
        URLSession.shared.dataTask(with: request) { [weak self] (data:Data?, response:URLResponse?, error:Error?) in
            guard error == nil else { self?.succeeded = false; self?.isFinished = true; return }
            guard (response as! HTTPURLResponse).statusCode == 200 else { self?.succeeded = false; self?.isFinished = true; return }

            let fetch: NSFetchRequest<Game> = Game.fetchRequest()
            if let results = try? backgroundManagedObjectContext.fetch(fetch) {
                if results.count == 1 {
                    backgroundManagedObjectContext.delete(results.first!)
                    try? backgroundManagedObjectContext.save()
                }
            }
            self?.succeeded = true
            self?.isFinished = true
        }.resume()
    }

}
