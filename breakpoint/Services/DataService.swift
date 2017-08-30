//
//  DataService.swift
//  breakpoint
//
//  Created by Roger on 28/08/17.
//  Copyright © 2017 Decodely. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage

let DB_BASE = Database.database().reference()
let STORAGE_BASE = Storage.storage().reference()

class DataService {
	static let instance = DataService()

	private var _REF_BASE = DB_BASE
	private var _REF_STORAGE_BASE = STORAGE_BASE
	private var _REF_USERS = DB_BASE.child("users")
	private var _REF_GROUPS = DB_BASE.child("groups")
	private var _REF_FEED = DB_BASE.child("feed")

	var REF_BASE: DatabaseReference {
		return _REF_BASE
	}

	var REF_STORAGE_BASE: StorageReference {
		return _REF_STORAGE_BASE
	}

	var REF_USERS: DatabaseReference {
		return _REF_USERS
	}

	var REF_GROUPS: DatabaseReference {
		return _REF_GROUPS
	}

	var REF_FEED: DatabaseReference {
		return _REF_FEED
	}

	func createDBUser(uid: String, userData: Dictionary<String, Any>) {
		REF_USERS.child(uid).updateChildValues(userData)
	}

	func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) -> ()){
		if groupKey != nil {
            REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(["content": message, "senderId": uid])
            sendComplete(true)
		} else {
			REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
			sendComplete(true)
		}
	}

	func getAllFeedMessages(handler: @escaping (_ messages: [Message]) -> ()){
		var messageArray = [Message]()
		REF_FEED.observeSingleEvent(of: .value) { (feedMessageSnapshot) in
			guard let feedMessageSnapshot = feedMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }

			for message in feedMessageSnapshot {
				let content = message.childSnapshot(forPath: "content").value as! String
				let senderId = message.childSnapshot(forPath: "senderId").value as! String
				let message = Message(content: content, senderId: senderId)

				messageArray.append(message)
			}
			handler(messageArray)
		}
	}
    
    func getAllMessages(forGroup desiredGroup: Group, handler: @escaping (_ messagesArray: [Message]) -> ()){
        var messageArray = [Message]()
        REF_GROUPS.child(desiredGroup.uid).child("messages").observeSingleEvent(of: .value) { (groupMessageSnapshot) in
            guard let groupMessageSnapshot = groupMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for groupMessages in groupMessageSnapshot {
                let content = groupMessages.childSnapshot(forPath: "content").value as! String
                let senderId = groupMessages.childSnapshot(forPath: "senderId").value as! String
                let message = Message(content: content, senderId: senderId)
                
                messageArray.append(message)
            }
            handler(messageArray)
        }
    }

	func getAllUsers(handler: @escaping (_ users: [User]) -> ()){
		var userArray = [User]()
		REF_USERS.observeSingleEvent(of: .value) { (usersSnapshot) in
			guard let usersSnapshot = usersSnapshot.children.allObjects as? [DataSnapshot] else { return }

			for user in usersSnapshot {
				let userId = user.key
				let userEmail = user.childSnapshot(forPath: "email").value as! String
				let profileImage = "defaultProfileImage"

				let user = User(userId: userId, email: userEmail, profileImage: profileImage)

				userArray.append(user)
			}
			handler(userArray)
		}
	}

	func getAllGroups(handler: @escaping (_ groupdsArray: [Group]) -> ()){
		var groupsArray = [Group]()
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for group in groupSnapshot {
                
                let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                if memberArray.contains((Auth.auth().currentUser?.uid)!){
                	let groupId = group.key
                    let title = group.childSnapshot(forPath: "title").value as! String
                    let description = group.childSnapshot(forPath: "description").value as! String
                    
                    let group = Group(title: title, description: description, uid: groupId, members: memberArray, memberCount: memberArray.count)
                    groupsArray.append(group)
                }
            }
            handler(groupsArray)
        }
	}

	func getEmail(forSearchQuery query: String, handler: @escaping (_ emailArray: [String]) ->()){
		var emailArray = [String]()
		REF_USERS.observeSingleEvent(of: .value) { (usersSnapshot) in
			guard let usersSnapshot = usersSnapshot.children.allObjects as? [DataSnapshot] else { return }

			for user in usersSnapshot {
				let userEmail = user.childSnapshot(forPath: "email").value as! String

				if userEmail.contains(query) == true && userEmail != Auth.auth().currentUser?.email {
					emailArray.append(userEmail)
				}
			}
			handler(emailArray)
		}
	}

	func getUsername(forUID uid: String, handler: @escaping (_ username: String) -> ()){
		REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
			guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }

			for user in userSnapshot {
				if user.key == uid {
					handler(user.childSnapshot(forPath: "email").value as! String)
				}
			}
		}
	}

	func getIds(forUsernames usernames: [String], handler: @escaping (_ uidArray: [String]) -> ()){
		REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
			var idArray = [String]()
			guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }

			for user in userSnapshot {
				let email = user.childSnapshot(forPath: "email").value as! String
				if usernames.contains(email) {
					idArray.append(user.key)
				}
			}
			handler(idArray)
		}
	}
    
    func getEmails(forGroup group: Group, handler: @escaping (_ emailArray: [String]) -> ()){
        var emailArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }

            for user in userSnapshot {
                if group.members.contains(user.key) {
                    let email = user.childSnapshot(forPath: "email").value as! String
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }

	func createGroup(withTitle title: String, andDescription description: String, forUsersIds ids: [String], handler: @escaping (_ completion: Bool) -> ()){
		REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members": ids])
		handler(true)
	}

}
