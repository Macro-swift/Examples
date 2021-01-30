//
//  Model.swift
//  Noze.io / mod_swift / MacroExpress
//
//  Created by Helge Heß on 6/3/16.
//  Copyright © 2016-2021 ZeeZide GmbH. All rights reserved.
//

struct Todo: Encodable {
  // Note: Decodable doesn't work for partial objects and has little to no
  //       value for the Todo-Backend API.
  
  var id        : Int
  var title     : String
  var completed : Bool
  var order     : Int
  
  var url       : String { return "\(ourAPI)todos/\(id)" }
  
  
  // Codable is a train wreck. We need all this boilerplate just to emit the
  // extra `url`.
  
  enum CodingKeys: String, CodingKey {
    case id, title, completed, order, url
  }
  func encode(to encoder: Encoder) throws {
    var values = encoder.container(keyedBy: CodingKeys.self)
    try values.encode(url,       forKey: .url)
    try values.encode(id,        forKey: .id)
    try values.encode(title,     forKey: .title)
    try values.encode(completed, forKey: .completed)
    try values.encode(order,     forKey: .order)
  }
}
