//
//  Category.swift
//  ToDo
//
//  Created by ABDUL MAJEED SYED on 3/7/18.
//  Copyright © 2018 ABDUL MAJEED SYED. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    
    let item = List<Item>()
}
