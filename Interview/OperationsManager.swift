//
//  OperationsManager.swift
//  Interview
//
//  Created by Merch on 2018-01-20.
//  Copyright © 2018 Merch. All rights reserved.
//

import UIKit

// This class is used as a Facade so that all view controllers call methods on this class to perform all tasks.
class OperationsManager: NSObject {

    private var coreDataManager: CoreDataManager
    private var operationQueue: OperationQueue
    static let sharedInstance = OperationsManager()

    override init() {
        coreDataManager = CoreDataManager()
        operationQueue = OperationQueue()
        super.init()
    }

    func getEditingManagedObjectContext() -> NSManagedObjectContext {
        return coreDataManager.newBackgroundManagedObjectContext()
    }

    func getEditingGameManagedObjectContext(managedObjectContext: NSManagedObjectContext) -> Game {
        return NSEntityDescription.insertNewObject(forEntityName: "Game", into: managedObjectContext) as! Game
    }

    func games(completion: @escaping (Bool, [Game]?) -> Void) {
        let gamesOperation = GetGamesOperation(coreDataManager: coreDataManager)
        gamesOperation.completionBlock = {
            if gamesOperation.succeeded {
                let fetch: NSFetchRequest<Game> = Game.fetchRequest()
                if let list = try? self.coreDataManager.mainManagedObjectContext.fetch(fetch) {
                    completion(gamesOperation.succeeded, list)
                }
            } else {
                completion(gamesOperation.succeeded, nil)
            }
        }
        operationQueue.addOperation(gamesOperation)
    }

    func getImage(urlString: String?, completion: @escaping (Bool, UIImage?) -> Void) {
        guard let urlString = urlString else { completion(false, nil); return }
        URLSession.shared.downloadTask(with: URL(string: urlString)!) { (url:URL?, urlResponse:URLResponse?, error:Error?) in // This could be cached by putting downloads into the caches directory.
            guard error == nil else { completion(false, nil); return }
            guard let url = url else { completion(false, nil); return }
            if let data = try? Data(contentsOf: url, options: []) {
                let image = UIImage(data: data, scale: UIScreen.main.scale)
                completion(true, image)
            }
        }.resume()
    }

    func deleteGame(id: Int64, completion: @escaping (Bool) -> Void) {
        let deleteGameOperation = DeleteGameOperation(coreDataManager: coreDataManager, id: id)
        deleteGameOperation.completionBlock = {
            completion(deleteGameOperation.succeeded)
        }
        operationQueue.addOperation(deleteGameOperation)
    }

    func postGame(id: Int64, title: String?, developer: String?, year: String?, image: Data?, completion: @escaping (Bool) -> Void) {
        let postGameOperation = PostGameOperation(coreDataManager: coreDataManager, title: title, developer: developer, year: year, image: nil)
        postGameOperation.completionBlock = {
            completion(postGameOperation.succeeded)
        }
        operationQueue.addOperation(postGameOperation)
    }

}
