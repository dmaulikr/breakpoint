//
//  Group.swift
//  breakpoint
//
//  Created by Roger on 29/08/17.
//  Copyright © 2017 Decodely. All rights reserved.
//

import Foundation

class Group {
    private var _uid: String
    private var _title: String
    private var _description: String
    private var _memberCount: Int
    private var _members: [String]
    
    
    var uid: String{
        return _uid
    }
    
    var title: String{
        return _title
    }
    
    var description: String{
        return _description
    }
    
    var memberCount: Int{
        return _memberCount
    }
    
    var members: [String]{
        return _members
    }
    
    init(title: String, description: String, uid: String, members: [String], memberCount: Int){
        self._uid = uid
        self._title = title
        self._description = description
        self._memberCount = memberCount
        self._members = members
    }
}
