//
//  Recipe.swift
//  Lauzhack18
//
//  Created by Lionel Pellier on 24/11/2018.
//  Copyright © 2018 Lionel Pellier. All rights reserved.
//

import Foundation

struct Ingredient: Codable{
    var ingredient: String
    var quantity: Int?
}

struct Recipe: Codable{
    var title: String
    var ingredients: [Ingredient]
}
