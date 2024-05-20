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
    
    override init(frame: CGRect){
        super.init(frame: frame)
        commonInit()
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
        //          layer.cornerRadius = 15 // Adjust corner radius as needed
        layer.cornerRadius = bounds.size.height / 2
        //backgroundColor = .systemBlue // Set your desired background color
        //tintColor = .white
        setTitleColor(.white, for: .normal) // Set the title color if there's any title
        clipsToBounds = true
    }
}

