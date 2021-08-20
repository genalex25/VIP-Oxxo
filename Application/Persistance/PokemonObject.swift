
import Foundation
import RealmSwift

final class PokemonObject: Object {
    @objc dynamic var uuid = UUID().uuidString
    @objc dynamic var favorited = false
    @objc dynamic var height: Int = 0
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var order: Int = 0
    @objc dynamic var weight: Int = 0
    @objc dynamic var frontDefault: String = ""
    
}
