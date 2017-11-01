//
//  RoomTableViewController.swift
//  chatroom
//
//  Created by Neo Ighodaro on 27/10/2017.
//  Copyright © 2017 CreativityKills Co. All rights reserved.
//

import UIKit
import PusherChatkit

class RoomTableViewController: UITableViewController, PCRoomDelegate {
    
    var room: PCRoom!
    var messages = [PCMessage]()
    var messageField: UITextField!
    var currentUser: PCCurrentUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = room.name
        
        currentUser.subscribeToRoom(room: room, roomDelegate: self)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addMessage))
    }
    
    @objc func addMessage() -> Void {
        let alertCtrl = UIAlertController(title: "Add Message", message: "What would you like to say?", preferredStyle: .alert)
        alertCtrl.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertCtrl.addAction(UIAlertAction(title: "Add", style: .default, handler: { action in
            guard let room = self.room else { return }
            guard let message = self.messageField.text else { return }
            guard message.count > 0 else { return }
            
            self.currentUser?.addMessage(text: message, to: room, completionHandler: { (messsage, error) in
                guard error == nil else { return }
                print("Message added successfully!")
            })
        }))
        alertCtrl.addTextField { text in
            text.placeholder = "Enter message..."
            self.messageField = text
        }
        present(alertCtrl, animated: true)
    }
 
    // MARK: PCRoomDelegate overrides

    public func newMessage(message: PCMessage) {
        let count = self.messages.count
        let indexPath = IndexPath(row: count, section: 0)
        let rowAnimation: UITableViewRowAnimation = .top
        let scrollPosition: UITableViewScrollPosition = .top
        
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            self.messages.insert(message, at: self.messages.count)
            self.tableView.insertRows(at: [indexPath], with: rowAnimation)
            self.tableView.endUpdates()

            self.tableView.scrollToRow(at: indexPath, at: scrollPosition, animated: true)
            self.tableView.reloadRows(at: [indexPath], with: .automatic)
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView {
            let message = messages[(indexPath as NSIndexPath).row]
            
            if message.text.count == 0 {
                return 0
            }
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineBreakMode = .byWordWrapping
            paragraphStyle.alignment = .left
            
            let pointSize = MessageTableViewCell.defaultFontSize()
            
            let attributes = [
                NSAttributedStringKey.font: UIFont.systemFont(ofSize: pointSize),
                NSAttributedStringKey.paragraphStyle: paragraphStyle
            ]
            
            var width = tableView.frame.width - MessageTableViewCell.kMessageTableViewCellAvatarHeight
            width -= 25.0
            
            let titleBounds = (message.sender.displayName as NSString!).boundingRect(
                with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                options: .usesLineFragmentOrigin,
                attributes: attributes,
                context: nil
            )
            
            let bodyBounds = (message.text as NSString!).boundingRect(
                with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
                options: .usesLineFragmentOrigin,
                attributes: attributes,
                context: nil
            )
            
            var height = titleBounds.height
            height += bodyBounds.height
            height += 40
            
            if height < MessageTableViewCell.kMessageTableViewCellMinimumHeight {
                height = MessageTableViewCell.kMessageTableViewCellMinimumHeight
            }
            
            return height
        }
        
        return MessageTableViewCell.kMessageTableViewCellMinimumHeight
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let message = messages[(indexPath as NSIndexPath).row]

        let cell = tableView.dequeueReusableCell(withIdentifier: MessageTableViewCell.CellIdentifier) as! MessageTableViewCell
        
        cell.bodyLabel().text = message.text
        cell.titleLabel().text = message.sender.displayName
        
        cell.usedForMessage = true
        cell.indexPath = indexPath
        cell.transform = self.tableView.transform
        
        return cell
    }
}
