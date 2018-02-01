//
//  GamesOperation.swift
//  Interview
//
//  Created by Merch on 2018-01-25.
//  Copyright © 2018 Merch. All rights reserved.
//

import UIKit

class GetGamesOperation: BaseOperation {

    var games: [Game]?

    init(coreDataManager: CoreDataManager) {
        super.init()
        self.coreDataManager = coreDataManager
    }

    override func start() {
        baseUrl.appendPathComponent("Games")
        let backgroundManagedObjectContext = coreDataManager!.newBackgroundManagedObjectContext() // temporary managed object context to do work in a background thread
        URLSession.shared.dataTask(with: baseUrl) { [weak self] (data:Data?, response:URLResponse?, error:Error?) in
            guard error == nil else { self?.succeeded = false; self?.isFinished = true; return }
            guard (response as! HTTPURLResponse).statusCode == 200 else { self?.succeeded = false; self?.isFinished = true; return }
            guard let data = data else { self?.succeeded = false; self?.isFinished = true; return }
            if let root = try? JSONSerialization.jsonObject(with: data, options: []) as! [String:Any?] {
                if let games = root["games"] as? [[String:Any?]] {
                    self?.succeeded = true

                    let existingGamesFetch: NSFetchRequest<Game> = Game.fetchRequest()
                    var existingGames = try? backgroundManagedObjectContext.fetch(existingGamesFetch)

                    for game in games {
                        guard let id = game["id"] as? Int32 else { continue }
                        let matchingGames:[Game]? = existingGames?.filter({ (game:Game) -> Bool in
                            return game.id == id
                        })
                        var gameManagedObject: Game!
                        if matchingGames?.count ?? 0 > 0 {
                            gameManagedObject = matchingGames?.first
                            if let index = existingGames!.index(of: gameManagedObject) {
                                existingGames!.remove(at: index)
                            }
                        } else {
                            gameManagedObject = NSEntityDescription.insertNewObject(forEntityName: "Game", into: backgroundManagedObjectContext) as! Game
                            gameManagedObject.id = id
                        }
                        gameManagedObject.deserialize(jsonObject: game) // the managed object is responsible for its own JSON parsing
                    }

                    for existingGame in existingGames! {
                        backgroundManagedObjectContext.delete(existingGame) // our local game wasn't on the server, so let's delete it
                    }
                }
            }
            try? backgroundManagedObjectContext.save() // merge temporary managed object context with persistent store
            self?.isFinished = true
        }.resume() 
    }

}
