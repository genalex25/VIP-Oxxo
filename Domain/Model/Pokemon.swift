import Foundation
import RealmSwift

public struct Pokemon: Model, Equatable {
    public let uuid = UUID()
    public var favorited = false
    public var height: Int
    public var id: Int
    public var name: String
    public var order: Int
    public var sprites: Sprites
    public var types: [TypeElement]
    public var weight: Int
    
    enum CodingKeys: String, CodingKey {
        case  height, id, name, order, sprites, types, weight
    }
    
    public static func == (lhs: Pokemon, rhs: Pokemon) -> Bool {
        return lhs.id == rhs.id
    }
    
   
    
    
}





