//
//  GamesTableViewController.swift
//  Interview
//
//  Created by Merch on 2018-01-25.
//  Copyright © 2018 Merch. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {
    @IBOutlet weak var gameImageView: UIImageView?
    @IBOutlet weak var nameLabel: UILabel?
    @IBOutlet weak var developerLabel: UILabel?
    @IBOutlet weak var dateLabel: UILabel?
}

class GamesTableViewController: UITableViewController, UINavigationControllerDelegate {

    private var tableArray: [Game]?

    // MARK: - NSObject
    
    deinit {
        print(#function)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        print(#function)
    }
    
    
    // MARK: - UIViewController
    
    override func decodeRestorableState(with coder: NSCoder) {
        print(#function)
        super.decodeRestorableState(with: coder)
    }
    
    override func encodeRestorableState(with coder: NSCoder) {
        print(#function)
        super.encodeRestorableState(with: coder)
    }
    
    override func applicationFinishedRestoringState() {
        print(#function)
        super.applicationFinishedRestoringState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        navigationController?.delegate = self
        reloadModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
        if let selected = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selected, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#function)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print(#function)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(#function)
        if segue.identifier == "AddGameSegue" {
            let nc = segue.destination as! UINavigationController
            let editGameViewController = nc.topViewController as! EditGameViewController
            editGameViewController.mode = .new
        } else if segue.identifier == "EditGameSegue" {
            let editGameViewController = segue.destination as! EditGameViewController
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell)
            let game = tableArray?[indexPath!.row]
            editGameViewController.game = game
            editGameViewController.mode = .edit
        }
    }

    // MARK: - Actions

    @IBAction func gamesTableViewControllerUnwind1(_ segue: UIStoryboardSegue) {
        reloadModel()
        dismiss(animated: true, completion: nil)
    }

    
    
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfRows = 0
        numberOfRows = tableArray?.count ?? 0
        return numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GameTableViewCell
        let game = tableArray![indexPath.row]
        cell.nameLabel?.text = game.title
        cell.developerLabel?.text = game.developer
        cell.dateLabel?.text = game.year
        cell.gameImageView?.image = nil // to avoid the 'cell reuse problem,' first we need to clear the image
        if let imageUrlString = game.image {
            OperationsManager.sharedInstance.getImage(urlString: imageUrlString, completion: { [weak self] (succeeded:Bool, image:UIImage?) in // 'weak self' is used because the view controller could be released before the operation completes and if we held strong references to the view controller it wouldn't get released resulting in a memory leak
                DispatchQueue.main.async { // put it back on the main thread to update the image views
                    if succeeded && image != nil {
                        if let visibleCell = tableView.cellForRow(at: indexPath) { // if the indexPath we were requesting for has already scrolled off the screen by the time the operation returns, we don't want to set the image on the cell because the cell would have been reused for a different indexPath
                            (visibleCell as! GameTableViewCell).gameImageView?.image = image
                        }
                    } else {
                        cell.gameImageView?.backgroundColor = .darkGray
                    }
                }
            })
        }
        return cell
    }

    // MARK: - Private Methods

    private func reloadModel() {
        OperationsManager.sharedInstance.games { [weak self] (succeeded:Bool, games:[Game]?) in // the 'weak self' is used to use weak references to the view controller in case the view controller is released before the network call is completed
            DispatchQueue.main.async { // put it back on the main thread to update the UI
                if succeeded {
                    self?.tableArray = games
                    self?.tableView.reloadData()
                } else {
                    let alert = UIAlertController(title: NSLocalizedString("Games Loading Error", comment: ""), message: NSLocalizedString("Unable to get games.", comment: ""), preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
                    self?.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    // MARK: - UINavigationControllerDelegate

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let bounceAnimator = SlideAnimator()
        bounceAnimator.presenting = operation == .push
        return bounceAnimator
    }

}




