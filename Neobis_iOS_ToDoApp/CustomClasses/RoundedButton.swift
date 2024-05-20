//
//  RoundedButton.swift
//  Neobis_iOS_ToDoApp
//
//  Created by Ai Hawok on 19/05/2024.
//

import UIKit

class RoundedButton: UIButton {
    
    @IBInspectable var imageName: String? {
        didSet {
            setupImage()
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    private func commonInit() {
        print("common init")
        setupImage()
        setupAppearance()
    }
    
    private func setupImage() {
        guard let imageName = imageName else { return }
        
        // Create UIImageView
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        addSubview(imageView)
        
        // Set image
        if let image = UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate) {
            imageView.image = image
            imageView.setImageColor(color: .white)
        }
        
        // Set image view constraints to center it inside the button
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            imageView.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(lessThanOrEqualTo: heightAnchor, multiplier: 0.5)
        ])
    }
    private func setupAppearance() {
        layer.cornerRadius = bounds.size.height / 2
        setTitleColor(.white, for: .normal) // Set the title color if there's any title
        clipsToBounds = true
    }
    
    func animateIn(completion: (() -> Void)? = nil) {
        self.isEnabled = true
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        }, completion: { _ in
            completion?()
        })
    }
    
    func animateOut(completion: (() -> Void)? = nil) {
        self.isEnabled = false
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }, completion: { _ in
            completion?()
        })
    }
}

