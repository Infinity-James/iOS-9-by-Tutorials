/*
* Copyright (c) 2015 Razeware LLC
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

import ContactsUI
import UIKit

class FriendsViewController: UITableViewController {
  
  var friendsList = Friend.defaultContacts()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.titleView = UIImageView(image: UIImage(named: "RWConnectTitle")!)
    tableView?.rowHeight = UITableViewAutomaticDimension
    tableView?.estimatedRowHeight = 60
  }
  
    @IBAction func addFriends(sender: UIBarButtonItem) {
        let contactPicker = CNContactPickerViewController()
        contactPicker.delegate = self
        contactPicker.predicateForEnablingContact = NSPredicate(format: "emailAddresses.@count > 0")
        presentViewController(contactPicker, animated: true, completion: nil)
    }
}

//MARK: UITableViewDataSource
extension FriendsViewController {
  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return friendsList.count
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("FriendCell", forIndexPath:indexPath)
    
    if let cell = cell as? FriendCell {
      let friend = friendsList[indexPath.row]
      cell.friend = friend
    }
    
    return cell
  }
  
  override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {}
  
}

extension FriendsViewController {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let friend = friendsList[indexPath.row]
        let contact = friend.contactValue
        
        let contactViewController = CNContactViewController(forUnknownContact: contact)
        contactViewController.navigationItem.title = "Profile"
        contactViewController.hidesBottomBarWhenPushed = true
        contactViewController.allowsEditing = false
        contactViewController.allowsActions = false
        
        navigationController?.pushViewController(contactViewController, animated: true)
    }
    
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let createContact = UITableViewRowAction(style: .Normal, title: "Create Contact") { rowAction, indexPath in
            tableView.setEditing(false, animated: true)
            let contactStore = CNContactStore()
            contactStore.requestAccessForEntityType(CNEntityType.Contacts) { userGrantedAccess, _ in
                guard userGrantedAccess else {
                    NSOperationQueue.mainQueue().addOperationWithBlock { self.presentPermissionErrorAlert() }
                    return
                }
                
                let friend = self.friendsList[indexPath.row]
                NSOperationQueue.mainQueue().addOperationWithBlock { self.saveFriendToContacts(friend) }
            }
        }
        createContact.backgroundColor = BlueColor
        
        return [createContact]
    }
    
    private func presentPermissionErrorAlert() {
        let alert = UIAlertController(title: "Could Not Save Contact", message: "I can't add the contact without permission!", preferredStyle: .Alert)
        let openSettingsAction = UIAlertAction(title: "Settings", style: .Default) { action in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }
        let dismissAction = UIAlertAction(title: "Fine", style: .Cancel, handler: nil)
        alert.addAction(openSettingsAction)
        alert.addAction(dismissAction)
        presentViewController(alert, animated: true, completion: nil)
    }
    
    private func saveFriendToContacts(friend: Friend) {
        let contactName = CNContactFormatter().stringFromContact(friend.contactValue)!
        let predicateForMatchingName = CNContact.predicateForContactsMatchingName(contactName)
        let matchingContacts = try! CNContactStore().unifiedContactsMatchingPredicate(predicateForMatchingName, keysToFetch: [])
        guard matchingContacts.isEmpty else {
            let alert = UIAlertController(title: "Contact Already Exists", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Nice", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
            return
        }
        
        let contact = friend.contactValue.mutableCopy() as! CNMutableContact
        let saveRequest = CNSaveRequest()
        saveRequest.addContact(contact, toContainerWithIdentifier: nil)
        do {
            try CNContactStore().executeSaveRequest(saveRequest)
            let alert = UIAlertController(title: "Contact Saved", message: nil, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Cool", style: .Cancel, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        } catch {
            
        }
    }
}

extension FriendsViewController: CNContactPickerDelegate {
    func contactPicker(picker: CNContactPickerViewController, didSelectContacts contacts: [CNContact]) {
        let newFriends = contacts.map { Friend(contact: $0) }
        friendsList.appendContentsOf(newFriends.filter { !friendsList.contains($0) })
        tableView.reloadData()
    }
}