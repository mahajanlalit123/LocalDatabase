//
//  Category.swift
//  LocalDatabase
//
//  Created by Harpalsingh Bachher on 22/02/19.
//  Copyright © 2019 softaidcomputers. All rights reserved.
//

import Foundation
import RealmSwift

class Category : Object{
    @objc dynamic var name :String = ""
    let items = List<Item>()
}
