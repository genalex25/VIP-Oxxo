//
//  WelcomeViewController.swift
//  Counters
//
//

import UIKit

protocol WelcomeViewControllerPresenter {
    var viewModel: WelcomeView.ViewModel { get }
}

class WelcomeViewController: UIViewController {
    
    private let imageView: UIImageView = {
        let imageView         = UIImageView(frame: CGRect(x:0, y:0, width :300, height: 150))
        imageView.image       = UIImage(named: "oxxo-logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    

   private lazy var innerView = WelcomeView()
    private let presenter: WelcomeViewControllerPresenter
    
    init(presenter: WelcomeViewControllerPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = innerView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        additionalSafeAreaInsets = Constants.additionalInsets
        //innerView.configure(with: presenter.viewModel)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        imageView.center = view.center
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.animate()
        })
    }
    
    private func animate(){
        UIView.animate(withDuration: 1.5, animations: {
            let size  = self.view.frame.size.width * 3
            let diffX = size - self.view.frame.size.width
            let diffY = self.view.frame.size.height - size
            
            self.imageView.frame = CGRect(
                x: -(diffX/2),
                y: diffY/2,
                width: size,
                height : size
            )
            
            UIView.animate(withDuration: 2, animations: {
                self.imageView.alpha = 0
            }, completion: { done in
                if done {
                    DispatchQueue.main.asyncAfter(deadline: .now()+0.3, execute: {
                        self.innerView.configure(with: self.presenter.viewModel)
                    })
                }
            })
            
            
        })
    }
}

private extension WelcomeViewController {
    enum Constants {
        static let additionalInsets = UIEdgeInsets(top: 26, left: 39, bottom: 20, right: 39)
    }
}


