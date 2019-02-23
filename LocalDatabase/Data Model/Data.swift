//
//  Data.swift
//  LocalDatabase
//
//  Created by Harpalsingh Bachher on 22/02/19.
//  Copyright © 2019 softaidcomputers. All rights reserved.
//

import Foundation
import RealmSwift

class Data : Object{
    @objc dynamic var name: String = ""
    @objc dynamic var age: Int = 0
}
