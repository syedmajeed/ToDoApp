//
//  Item.swift
//  ToDo
//
//  Created by ABDUL MAJEED SYED on 3/7/18.
//  Copyright © 2018 ABDUL MAJEED SYED. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    
    @objc dynamic var done: Bool = false
   
    var parentCategory = LinkingObjects(fromType: Category.self, property: "item")
    
    @objc dynamic var dateCreated = Date()
}
