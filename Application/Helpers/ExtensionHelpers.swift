import Foundation
import UIKit

// MARK: - Int
extension Int {
    func toString() -> String {
        return String(self)
    }
}

// MARK: - View Controller
extension UIViewController {
    func showAlert(title: String, message: String, handler: (() -> Void)? = nil) {
        if message.isEmpty {
            return
        }
            
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(
            UIAlertAction(title: "Ok", style: .default, handler: { _ in
                handler?()
            })
        )
        
        present(alert, animated: true, completion: nil)
    }
}

struct ObjectHelper {
    static var object = """
    {
      "name": "ivysaur",
      "order": 2,
      "sprites": {
        "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/2.png",
        "other": {
          "dream_world": {
            "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/dream-world/2.svg",
            "front_female": null
          },
          "official-artwork": {
            "front_default": "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/2.png"
          }
        },
        
      },
      "types": [
        {
          "slot": 1,
          "type": {
            "name": "grass",
            "url": "https://pokeapi.co/api/v2/type/12/"
          }
        },
        {
          "slot": 2,
          "type": {
            "name": "poison",
            "url": "https://pokeapi.co/api/v2/type/4/"
          }
        }
      ],
      "weight": 130,
      "height": 130,
      "id": 130
    }
    """
}

