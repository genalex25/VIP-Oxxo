import Foundation
import Domain
import RealmSwift


protocol PokemonDetailBusinessLogic {
    func fetchPokemonDetail(request: PokemonDetail.PokemonDetail.Request)
    func fetchPokemonAbout(request: PokemonDetail.About.Request)
    func fetchFavoritePokemon(request: PokemonDetail.FavoritePokemon.Request)
}

protocol PokemonDetailDataStore {
    var pokemon: Pokemon! { get set }
}

class PokemonDetailInteractor: PokemonDetailDataStore {
    var pokemon: Pokemon!
    var presenter: PokemonDetailPresentationLogic?
    
    // MARK: Use cases
    let remoteFavorite: FavoritePokemon
    let localFavorite: LocalFavoritePokemon
    
    init(remoteFavorite: FavoritePokemon, localFavorite: LocalFavoritePokemon) {
        self.remoteFavorite = remoteFavorite
        self.localFavorite = localFavorite
    }
}

extension PokemonDetailInteractor: PokemonDetailBusinessLogic {

    func fetchPokemonDetail(request: PokemonDetail.PokemonDetail.Request) {
        self.pokemon.favorited = self.localFavorite.isFavorited(pokemon: pokemon)
        presenter?.presentPokemonDetail(response: PokemonDetail.PokemonDetail.Response(pokemon: pokemon))
    }
    
    func fetchPokemonAbout(request: PokemonDetail.About.Request) {
        presenter?.presentPokemonAbout(response: PokemonDetail.About.Response(pokemon: pokemon))
    }
    
    func fetchFavoritePokemon(request: PokemonDetail.FavoritePokemon.Request) {
        
        let object = PokemonObject()
        object.favorited = pokemon.favorited
        object.height  = pokemon.height
        object.id = pokemon.id
        object.name = pokemon.name
        object.order = pokemon.order
        object.weight = pokemon.weight
        object.frontDefault = pokemon.sprites.other.officialArtwork.frontDefault
         
        // Get the default Realm
        let realm = try! Realm()
        try! realm.write {
            realm.add(object)
        }
        
        let favorite = self.localFavorite.isFavorited(pokemon: self.pokemon)
        self.pokemon.favorited = !favorite
        self.localFavorite.setFavorite(pokemon: self.pokemon)
        self.presenter?.presentFavoritePokemon(response: PokemonDetail.FavoritePokemon.Response(pokemon: self.pokemon))
        
    }
}

