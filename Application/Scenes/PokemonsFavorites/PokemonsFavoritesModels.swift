import Foundation
import Domain


enum PokemonFavorites {
    enum FetchPokemons {
        struct Request {
            var offset: Int = 20
        }
        struct Response {
            let pokemons: [Pokemon]?
        }
        
        struct ViewModel {
            let pokemons: [DisplayedPokemon]?
            
            struct DisplayedPokemon {
                let firstType: String
                let secType: String?
                let image: String
                let name: String
            }
            
            struct Reference {
                let name: String
                var value: String?
                let link: String
            }
        }
    }
}

