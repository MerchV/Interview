//
//  EditGameViewController.swift
//  Interview
//
//  Created by Merch on 2018-01-26.
//  Copyright © 2018 Merch. All rights reserved.
//

import UIKit

enum EditGameViewControllerMode: Int {
    case new
    case edit
}

class EditGameViewController: UIViewController {

    var game: Game?
    var mode: EditGameViewControllerMode = .new
    @IBOutlet private weak var scrollView: UIScrollView?
    @IBOutlet private weak var nameTextField: UITextField?
    @IBOutlet private weak var developerTextField: UITextField?
    @IBOutlet private weak var yearTextField: UITextField?
    @IBOutlet private weak var chooseButton: UIButton?
    @IBOutlet private weak var deleteGameButton: UIButton?

    private var editingManagedObjectContext: NSManagedObjectContext
    private var editingGame: Game?
    
    // MARK: - NSObject
    
    deinit {
        print(#function)
    }
    
    required init?(coder aDecoder: NSCoder) {
        editingManagedObjectContext = OperationsManager.sharedInstance.getEditingManagedObjectContext()
        editingGame = OperationsManager.sharedInstance.getEditingGameManagedObjectContext(managedObjectContext: editingManagedObjectContext)
        super.init(coder: aDecoder)
        print(#function)
    }
    
    
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)

        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillShow, object: nil, queue: OperationQueue.main) { [weak self] (notification: Notification) -> Void in
            let endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            self?.scrollView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: endFrame?.size.height ?? 0, right: 0)
            self?.scrollView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: endFrame?.size.height ?? 0, right: 0)
        }

        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIKeyboardWillHide, object: nil, queue: OperationQueue.main) { [weak self] (notification: Notification) -> Void in
            self?.scrollView?.contentInset = .zero
            self?.scrollView?.scrollIndicatorInsets = .zero
        }

        if mode == .new {
            let closeButton = UIBarButtonItem(title: NSLocalizedString("Close", comment: ""), style: .done, target: self, action: #selector(closeButtonPressed(_:)))
            navigationItem.leftBarButtonItem = closeButton
        }
    }

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        reloadViews()
        reloadModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(#function)
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
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // MARK: - Actions

    @objc func closeButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func dismissButtonPressed(_ sender: UIBarButtonItem) {
//        dismiss(animated: true, completion: nil)
        performSegue(withIdentifier: "unwind1", sender: self)
    }

    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {

    }

    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: NSLocalizedString("Delete Game?", comment: ""), message: NSLocalizedString("This will really delete the game from the server.", comment: ""), preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("DELETE GAME", comment: ""), style: .destructive, handler: { [unowned self] (action:UIAlertAction) in
            guard let game = self.game else { return }
            OperationsManager.sharedInstance.deleteGame(id: game.id, completion: { [weak self] (succeeded:Bool) in
                if succeeded {
//                    self?.dismiss(animated: true, completion: nil)
                    self?.performSegue(withIdentifier: "UnwindToListAfterDeleteGame", sender: self)
                } else {

                }
            })
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Private Methods

    
	func reloadViews() {
        print("\(String(describing: self)) \(#function)")
        if mode == .edit && game != nil {
            nameTextField?.text = game?.name
            developerTextField?.text = game?.developer
            yearTextField?.text = game?.year
        }
        deleteGameButton?.isHidden = mode == .new
    }

	func reloadModel() {
        print("\(String(describing: self)) \(#function)")
    }
    

}
