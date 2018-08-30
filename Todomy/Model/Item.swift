//
//  Item.swift
//  Todomy
//
//  Created by Jason on 2018/8/8.
//  Copyright © 2018年 Jiaxin Li. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object
{
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    @objc dynamic var hasColor: String?
    
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
    //each item has a inverse relationship category
}
