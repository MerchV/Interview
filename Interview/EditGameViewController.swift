//
//  EditGameViewController.swift
//  Interview
//
//  Created by Merch on 2018-01-26.
//  Copyright © 2018 Merch. All rights reserved.
//

import UIKit
import AVFoundation // for camera access

enum EditGameViewControllerMode: Int {
    case new
    case edit
}

class EditGameViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var game: Game?
    var mode: EditGameViewControllerMode = .new
    @IBOutlet private weak var scrollView: UIScrollView?
    @IBOutlet private weak var nameTextField: UITextField?
    @IBOutlet private weak var developerTextField: UITextField?
    @IBOutlet private weak var yearTextField: UITextField?
    @IBOutlet private weak var boxArtImageView: UIImageView?
    @IBOutlet private weak var chooseButton: UIButton?
    @IBOutlet private weak var deleteGameButton: UIButton?

    private var editingManagedObjectContext: NSManagedObjectContext
    private var editingGame: Game?

    private var imagePicker: UIImagePickerController?
    
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

    @IBAction func chooseImageButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Camera", comment: ""), style: .default, handler: { [weak self] (action:UIAlertAction) in
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted:Bool) in
                DispatchQueue.main.async {
                    if granted {
                        if UIImagePickerController.isSourceTypeAvailable(.camera) == true {
                            self?.imagePicker = UIImagePickerController()
                            self?.imagePicker!.sourceType = .camera
                            self?.imagePicker!.allowsEditing = false
                            self?.imagePicker!.delegate = self
                            self?.imagePicker!.showsCameraControls = true
                            self?.present((self?.imagePicker)!, animated: true, completion: nil)
                        } else {
                            print("Camera Not Available")
                        }
                    } else {
                        let alert = UIAlertController(title: NSLocalizedString("Camera Access Denied", comment: ""), message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Library", comment: ""), style: .default, handler: { [weak self] (action:UIAlertAction) in
            DispatchQueue.main.async {
                if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == true {
                    self?.imagePicker = UIImagePickerController()
                    self?.imagePicker!.sourceType = .photoLibrary
                    self?.imagePicker!.allowsEditing = false
                    self?.imagePicker!.delegate = self
                    self?.present((self?.imagePicker)!, animated: true, completion: nil)
                } else {
                    print("Photo Library Not Available")
                }
            }
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: { (action:UIAlertAction) in

        }))
        present(alert, animated: true, completion: nil)

    }
    
    // MARK: - Private Methods

    
	func reloadViews() {
        print("\(String(describing: self)) \(#function)")
        if mode == .edit && game != nil {
            nameTextField?.text = game?.title
            developerTextField?.text = game?.developer
            yearTextField?.text = game?.year
            OperationsManager.sharedInstance.getImage(urlString: game!.image, completion: { [weak self] (succeeded:Bool, image:UIImage?) in
                DispatchQueue.main.async {
                    if succeeded {
                        self?.boxArtImageView?.image = image
                    } else {

                    }
                }
            })
        }
        deleteGameButton?.isHidden = mode == .new

    }

	func reloadModel() {
        print("\(String(describing: self)) \(#function)")
    }


    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(#function)
        dismiss(animated: true) { [weak self] in
            if var image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                if picker.sourceType == .camera {
                }
                if let data = UIImageJPEGRepresentation(image, 0.8) {
                    self?.boxArtImageView?.image = image
//                    self?.currentCell?.fileActivityIndicatorView?.startAnimating()
//                    (UIApplication.shared.delegate as! AppDelegate).operationsManager.postFilePrivate(fileData: data, filename: "CredentialPhoto.jpeg", completion: { [weak self] (succeeded:Bool, fileId:String?, cancelled:Bool, timedOut:Bool, networkingError:Error?, frErrors:[FRError]?, coreDataError:Error?) in
//                        DispatchQueue.main.async {
//                            self?.currentCell?.fileActivityIndicatorView?.stopAnimating()
//                            if succeeded && fileId != nil {
//                                self?.currentCell?.editingCertification?.fileId = fileId!
//                                self?.currentCell?.fileSetButton?.isHidden = false
//                                self?.currentCell?.fileUnsetButton?.isHidden = true
//                            } else {
//                                self?.handleErrors(title: NSLocalizedString("FILE UPLOAD", comment: ""), succeeded: succeeded, cancelled: cancelled, timedOut: timedOut, networkingError: networkingError, frErrors: frErrors, coreDataError: coreDataError, fields: nil, showsAlert: true, errorLabel: nil, jsonErrorFile: nil)
//                            }
//                        }
//                    })
                }
            }
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        picker.dismiss(animated: true, completion: nil)
    }

}
