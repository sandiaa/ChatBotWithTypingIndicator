//
//  ChatController.swift
//  ChatOnboarding
//
//  Created by Manoj Kumar on 18/01/19.
//  Copyright © 2019 Sandiaa. All rights reserved.
//

import UIKit
import WebKit
import SafariServices
import AVFoundation

class ChatController: UIViewController , SFSafariViewControllerDelegate{

   
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var datePickerView: UIView!
    @IBOutlet weak var restartButton: UIButton!
    @IBOutlet weak var chatCollectionView: UICollectionView!
    @IBOutlet weak var txtField: UITextField!
    @IBOutlet weak var textFieldBaseView: UIView!
    @IBOutlet weak var lcCollectionViewBottomSpace: NSLayoutConstraint!

    @IBOutlet weak var lcNumberDoneButtonWidth: NSLayoutConstraint!
    @IBOutlet weak var lcDatePickerBottomSpace: NSLayoutConstraint!
    var dataSource = [ChatType]()
    var currentSuggestion = [ChatType]()
    
    var player: AVAudioPlayer?
    var shouldShowTypingCell = false
    var currentUserChatType = ChatType.none
    var didRestart = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpView()
        dataSource.append(ChatType.hi)
        setupColletionView()
        processLastChat()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }

    func setUpView() {
        textFieldBaseView.backgroundColor = .white
        textFieldBaseView.addShadowWith(shadowPath: UIBezierPath(rect: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)).cgPath, shadowColor: UIColor.black.withAlphaComponent(0.6).cgColor, shadowOpacity: 0.5, shadowRadius: 10.0, shadowOffset: CGSize.zero)
        datePickerView.addShadowWith(shadowPath: UIBezierPath(rect: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)).cgPath, shadowColor: UIColor.black.withAlphaComponent(0.6).cgColor, shadowOpacity: 0.5, shadowRadius: 10.0, shadowOffset: CGSize.zero)
        
        txtField.delegate = self
        
        self.lcDatePickerBottomSpace.constant = -300
        view.layoutIfNeeded()
    }
    func setupColletionView() {
        
        chatCollectionView.delegate = self
        chatCollectionView.dataSource = self
        
        chatCollectionView.register(UINib(nibName:"UserCell", bundle: nil), forCellWithReuseIdentifier: "UserCell")
        chatCollectionView.register(UINib(nibName:"BotCell", bundle: nil), forCellWithReuseIdentifier: "BotCell")
        chatCollectionView.register(UINib(nibName:"AllSuggestionsCell", bundle: nil), forCellWithReuseIdentifier: "AllSuggestionsCell")
        chatCollectionView.register(UINib(nibName: "AvatarCell", bundle: nil), forCellWithReuseIdentifier: "AvatarCell")
        chatCollectionView.register(UINib(nibName: "TypingCell", bundle: nil), forCellWithReuseIdentifier: "TypingCell")
        
        let springLayout = SpringyFlowLayout()
        springLayout.scrollDirection = .vertical
        springLayout.minimumLineSpacing = 10
        springLayout.minimumInteritemSpacing = 10
        springLayout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        chatCollectionView.setCollectionViewLayout(springLayout, animated: false)
        springLayout.invalidateLayout()
        chatCollectionView.reloadData()
    }
    
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        let endFrame = ((notification as NSNotification).userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        if endFrame.origin.y == UIScreen.main.bounds.height {//Keyboard is hidden
            lcCollectionViewBottomSpace.constant = 0
        }
        else {//Keyboard is visible
            lcCollectionViewBottomSpace.constant = endFrame.height + 60
        }
        view.layoutIfNeeded()
        chatCollectionView.scrollToItem(at: IndexPath(row: dataSource.count-1, section: 0), at: .bottom, animated: true)
    }
    
    @objc func processLastChat() {
        guard let chatType = dataSource.last else {return}
        currentSuggestion.removeAll()
        if chatType.getOriginType() == .bot {
           playSound(chatType: .bot)
            if chatType.getUserInputType() == .suggestion  {
                currentSuggestion = chatType.getSuggestions()
                if chatType != dataSource.first {
                    insertSuggestionCell()
                }
            }
            else if chatType.getUserInputType() == .picker {
                txtField.isHidden = true
                textFieldBaseView.isHidden = true
                datePicker.datePickerMode = .date
                datePicker.maximumDate = Calendar.current.date(byAdding: .year, value: -15, to: Date())
                datePicker.isHidden = false
                datePickerView.isHidden = false
                UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseOut, animations: {
                    self.lcCollectionViewBottomSpace.constant = 250
                    self.lcDatePickerBottomSpace.constant = 0
                    self.view.layoutIfNeeded()
                }, completion: nil)
                datePickerView.superview?.bringSubviewToFront(datePickerView)
                 chatCollectionView.scrollToItem(at: IndexPath(row: dataSource.count-1, section: 0), at: .bottom, animated: true)
            }
            else if chatType.getUserInputType() == .textField{
                if chatType == .mobile {
                    txtField.keyboardType = chatType.getKeyboardType()
                    txtField.becomeFirstResponder()
                    lcNumberDoneButtonWidth.constant = 100
                    view.layoutIfNeeded()
                }
                txtField.keyboardType = chatType.getKeyboardType()
                txtField.placeholder = chatType.getPlaceholderText()
                txtField.isSecureTextEntry = chatType.isTextFieldSecure()
                txtField.returnKeyType = .done
                
                if chatType == .wrongSignInEmail || chatType == .signinEmojiPassword || chatType == .signinInvalidPassword ||
                    chatType == .wrongSignupName || chatType == .wrongSignupEmail || chatType == .signupEmojiPassword ||
                    chatType == .signupInvalidPassword || chatType == .confirmPassword || chatType == .wrongConfirmPassword ||
                    chatType == .signupWrongDob || chatType == .wrongMobile || chatType == .declineSelected || chatType == .okay
                {
                    var indexPathsToInsert = [IndexPath]()
                    var indexPathsToDelete = [IndexPath]()
                    
                    let userResponseIndexpath = IndexPath(row: dataSource.count-1, section: 0)
                    indexPathsToInsert.append(userResponseIndexpath)
                    if dataSource[dataSource.count-2].getSuggestions().count > 0 {
                        indexPathsToDelete.append(userResponseIndexpath)
                    }
                    
                    (self.chatCollectionView.collectionViewLayout as! SpringyFlowLayout).dynamicAnimator = nil
                    chatCollectionView.performBatchUpdates({
                        self.chatCollectionView.deleteItems(at: indexPathsToDelete)
                        self.chatCollectionView.insertItems(at: indexPathsToInsert)
                    }) { (finished) in
                        self.txtField.becomeFirstResponder()
                    }
                }

                else {
                    txtField.becomeFirstResponder()
                }
        }
            else if chatType.getUserInputType() == .image{
              
            }
        }
        else {
            playSound(chatType: .user)
            var indexPathsToInsert = [IndexPath]()
            var indexPathsToDelete = [IndexPath]()
            
            let userResponseIndexpath = IndexPath(row: dataSource.count-1, section: 0)
            indexPathsToInsert.append(userResponseIndexpath)
            if dataSource[dataSource.count-2].getSuggestions().count > 0 {
                indexPathsToDelete.append(userResponseIndexpath)
            }
            
            let botResponse = chatType.getBotResponse()
            if botResponse != .none && botResponse.getTimeDelay() > 0.0 {
                let typingCellIndexPath = IndexPath(row: dataSource.count, section: 0)
                indexPathsToInsert.append(typingCellIndexPath)
                self.shouldShowTypingCell = true
            }
            else {
                self.dataSource.append(botResponse)
                let botResponseIndexpath = IndexPath(row: self.dataSource.count-1, section: 0)
                indexPathsToInsert.append(botResponseIndexpath)
            }
            
            (self.chatCollectionView.collectionViewLayout as! SpringyFlowLayout).dynamicAnimator = nil
            chatCollectionView.performBatchUpdates({
                self.chatCollectionView.deleteItems(at: indexPathsToDelete)
                self.chatCollectionView.insertItems(at: indexPathsToInsert)
            }) { (finished) in
                if botResponse != .none && botResponse.getTimeDelay() > 0.0 {
                    self.currentUserChatType = chatType
                    self.perform(#selector(self.hideTypingCellAndShowBotResponse), with: nil, afterDelay: botResponse.getTimeDelay())
                }
                else {
                    self.processLastChat()
                }
            }
        }
    }
    
    func getRandomTimeDelay()->Double {
        let randomDouble = Double.random(in: 1.0...5.0)
        return randomDouble
    }
    
    @objc func hideTypingCellAndShowBotResponse() {
        if didRestart {
            didRestart  = false
            return
        }
        self.shouldShowTypingCell = false
        let typingCellIndexPath = IndexPath(row: dataSource.count, section: 0)
        
        (self.chatCollectionView.collectionViewLayout as! SpringyFlowLayout).dynamicAnimator = nil
        chatCollectionView.performBatchUpdates({
            self.chatCollectionView.deleteItems(at: [typingCellIndexPath])
        }) {(finished) in
            DispatchQueue.main.async {
                let botResponse = self.currentUserChatType.getBotResponse()
                self.dataSource.append(botResponse)
                let botResponseIndexpath = IndexPath(row: self.dataSource.count-1, section: 0)
                (self.chatCollectionView.collectionViewLayout as! SpringyFlowLayout).dynamicAnimator = nil
                self.chatCollectionView.performBatchUpdates({
                    self.chatCollectionView.insertItems(at: [botResponseIndexpath])
                }, completion: { (finished) in
                    self.processLastChat()
                })
            }
        }
    }
    
    func insertSuggestionCell() {
        if currentSuggestion.count > 0 {
            let suggestionIndexPath = IndexPath(row: dataSource.count, section: 0)
            (self.chatCollectionView.collectionViewLayout as! SpringyFlowLayout).dynamicAnimator = nil
            chatCollectionView.performBatchUpdates({
                self.chatCollectionView.insertItems(at: [suggestionIndexPath])
            }) { (finished) in
                if self.chatCollectionView.contentSize.height > self.chatCollectionView.frame.height {
                    self.chatCollectionView.setContentOffset(CGPoint(x: 0, y: self.chatCollectionView.contentSize.height - (self.chatCollectionView.frame.height - 30)), animated: false)
                }
            }
        }
    }
    func setupWebView() {
        guard let url = URL(string: "https://apple.com") else {
            return
        }
        
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true, completion: nil)
        safariVC.delegate = self

    }

    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    @IBAction func restartButton(_ sender: UIButton) {
   //     fullImageView.removeFromSuperview()
        let alert = UIAlertController(title: "Alert", message: "Would you like to Restart", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.didRestart = true
            self.txtField.text = ""
            self.txtField.resignFirstResponder()
            self.datePickerView.isHidden = true
            self.shouldShowTypingCell = false
            self.perform(#selector(self.resetCollectionView), with: nil, afterDelay: 0.0)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    
    }
    
    @objc func resetCollectionView() {
        dataSource.removeAll()
        dataSource.append(ChatType.hi)
        (self.chatCollectionView.collectionViewLayout as! SpringyFlowLayout).dynamicAnimator = nil
        chatCollectionView.reloadData()
        processLastChat()
    }
    
    @IBAction func doneButtonPressed(_ sender: UIButton) {
       textFieldBaseView.isHidden = false
       txtField.isHidden = false
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.lcCollectionViewBottomSpace.constant = 0
            self.lcDatePickerBottomSpace.constant = -250
            self.view.layoutIfNeeded()
        }, completion: nil)
        let selectedDate = datePicker.date
        let registerDate = getDateInChatFormat(date: selectedDate)
        UserDefaults.standard.set((registerDate), forKey: REGISTERED_SIGNUP_DOB)
        dataSource.append(.signupRegisteredDob)
        processLastChat()

        
    }
    
    @IBAction func numberDoneButton(_ sender: UIButton) {
        view.endEditing(true)
        txtField.resignFirstResponder()
        if (txtField.text ?? "").count < 10 {
            dataSource.append(.wrongMobile)
            processLastChat()
        }
        else {
            txtField.isHidden = false
            textFieldBaseView.isHidden = false
            lcNumberDoneButtonWidth.constant = 0
            view.layoutIfNeeded()
            UserDefaults.standard.set((txtField.text ?? ""), forKey: REGISTERED_MOBILE)
            dataSource.append(.registeredMobile)
            txtField.text = ""
            processLastChat()
        }
    }
    func playSound(chatType : OriginType){
    
       var tone : String = ""
       if chatType == .bot
       {
            tone = "BotTone"
        }
        else if chatType == .user{
            tone = "UserTone"
        }
        let path = Bundle.main.path(forResource: tone, ofType: "mp3")!
        let url = URL(fileURLWithPath: path)
     
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player!.play()
        } catch {
            print("couldn't load the file")
        }
    }
   
}
