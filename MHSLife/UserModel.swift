//
//  UserModel.swift
//  MHSLife
//
//  Created by admin on 7/28/16.
//  Copyright © 2016 admin. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

struct User{
    static var UID: String = ""
    static var favorites: [String] = []
    static var favoriteEvents: [Event] = []
    
    static func toggleSubscription(groupName: String) {
        let ref = FIRDatabase.database().reference()
        if User.isFavorited(groupName){
            ref.child("users/" + User.UID + "/" + groupName).removeValueWithCompletionBlock({
                (error, ref) in
                
                if(error != nil){
                    print("Problem Connecting to Database")
                    print(error!.localizedDescription)
                }else{
                    print(groupName + " removed from favorites")
                    FIRMessaging.messaging().unsubscribeFromTopic("/topics/" + groupName)
                }
                print(User.favorites)
            })
        }else{
            User.favorites.append(groupName)
            FIRMessaging.messaging().subscribeToTopic("/topics/" + groupName)
            ref.child("users/" + User.UID).updateChildValues([groupName : true], withCompletionBlock: {
                (error, ref) in
                
                if(error != nil){
                    print("Problem Connecting to Database")
                    print(error!.localizedDescription)
                }else{
                    print(groupName + " added to favorites")
                    FIRMessaging.messaging().subscribeToTopic("/topics/" + groupName)
                }
                print(User.favorites)
            })
        }
    }
    
    static func isFavorited(groupName: String) -> Bool {
        return User.favorites.contains(groupName)
    }
    
    static func removeDefault() -> [String] {
        var modifiedFavorites = User.favorites
        if let index = modifiedFavorites.indexOf("mcclintock") {
            modifiedFavorites.removeAtIndex(index)
        }
        return modifiedFavorites
    }
    
}