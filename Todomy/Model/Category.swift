//
//  Category.swift
//  Todomy
//
//  Created by Jason on 2018/8/8.
//  Copyright © 2018年 Jiaxin Li. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object
{
    @objc dynamic var name: String = ""
    
    let items = List<Item>()
    //each category has a one-to-many relationship with a list of items
}
