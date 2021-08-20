import Foundation
import Domain
import RealmSwift

protocol PokemonFavoritesBusinessLogic {
    func fetchPokemons(request: PokemonFavorites.FetchPokemons.Request)
}

protocol PokemonFavoritesDataStore {
    var pokemons: [Pokemon] { get }
}

class PokemonFavoritesInteractor: PokemonFavoritesDataStore {
    var presenter: PokemonFavoritesPresentationLogic?
    var pokemons: [Pokemon]
    
    // MARK: - Use Cases
    let fetchPokemons: FetchPokemons
    
    init(fetchPokemons: FetchPokemons, pokemons: [Pokemon] = []) {
        self.fetchPokemons = fetchPokemons
        self.pokemons = pokemons
    }
}


// MARK: - UnlockBusinessLogic
extension PokemonFavoritesInteractor: PokemonFavoritesBusinessLogic {
    func fetchPokemons(request: PokemonFavorites.FetchPokemons.Request) {
        
        let decoder = JSONDecoder()
        var pokemon = try! decoder.decode(Pokemon.self, from: Data(ObjectHelper.object.utf8))
        var pokemons : [Pokemon] = []
        let realm = try! Realm()
        let favorites = realm.objects(PokemonObject.self)
        for fav in favorites {
              pokemon.favorited = fav.favorited
              pokemon.height  = fav.height
              pokemon.id = fav.id
              pokemon.name = fav.name
              pokemon.order = fav.order
              pokemon.weight = fav.weight
              pokemon.sprites.frontDefault = fav.frontDefault
              pokemons.append(pokemon)
        }
        
        self.presenter?.presentFetchPokemons(response: PokemonFavorites.FetchPokemons.Response(pokemons: pokemons))
        
    }
}

