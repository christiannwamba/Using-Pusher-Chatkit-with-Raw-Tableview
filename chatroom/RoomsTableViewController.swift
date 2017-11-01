//
//  RoomsTableViewController.swift
//  chatroom
//
//  Created by Neo Ighodaro on 27/10/2017.
//  Copyright © 2017 CreativityKills Co. All rights reserved.
//

import UIKit
import PusherChatkit

class RoomsTableViewController: UITableViewController, PCChatManagerDelegate {

    var username: String!
    var rooms = [PCRoom]()
    var selectedRoom: PCRoom!
    var currentUser: PCCurrentUser!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Rooms"
        
        initPusherChatkitManager { user in
            self.currentUser = user
            
            user.getAllRooms() { (rooms, error) in
                guard error == nil else { return }
                self.rooms = rooms!
                
                rooms?.forEach { room in
                    user.joinRoom(room) { room, error in
                        guard error == nil else { return }
                    }
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            self.tableView.reloadData()
        }
    }
    
    private func initPusherChatkitManager(completion: @escaping (_ success: PCCurrentUser) -> Void) {
        let chatkit = ChatManager(
            instanceLocator: AppConstants.INSTANCE_LOCATOR,
            tokenProvider: PCTokenProvider(url: AppConstants.ENDPOINT+"/authenticate", userId: username)
        )
        
        chatkit.connect(delegate: self) { (user, error) in
            guard error == nil else { return }
            guard let user = user else { return }

            DispatchQueue.main.async {
                completion(user)
            }
        }
    }

    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath)

        cell.textLabel?.text = rooms[indexPath.row].name
        cell.detailTextLabel?.text = rooms[indexPath.row].isPrivate ? "Private" : "Public"

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRoom = rooms[indexPath.row]
        performSegue(withIdentifier: "loadRoomTableViewController", sender: self)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "loadRoomTableViewController" {
            let ctrl = segue.destination as! RoomTableViewController
            ctrl.room = selectedRoom
            ctrl.currentUser = currentUser
        }
    }
}
