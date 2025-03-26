//
//  Properties.swift
//  Mazaady
//
//  Created by Walid Ahmed on 26/03/2025.
//

struct PropertiesModel: Codable {
    var message: Message?
    var data: [FormCategory]?
}
struct Option: Codable {
    var id: Int?
    var name: String?
    var hasChild: Bool?

    enum CodingKeys: String, CodingKey {
        case id, name
        case hasChild = "has_child"
    }
}

