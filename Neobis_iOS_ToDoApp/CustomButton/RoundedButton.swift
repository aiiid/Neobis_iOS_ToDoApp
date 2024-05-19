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
    
    override class func awakeFromNib() {
        super.awakeFromNib()
//        commonInit()
    }
    
    private func commonInit() {
            setupImage()
            setupAppearance()
        }
    
    private func setupImage() {
        if let imageName = imageName {
            setImage(UIImage(named: imageName), for: .normal)
            tintColor = .white // Adjust the icon color if needed
            imageView?.contentMode = .scaleAspectFit
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0) // Adjust as needed
        }
    }
    private func setupAppearance() {
            layer.cornerRadius = 15 // Adjust corner radius as needed
            backgroundColor = .systemBlue // Set your desired background color
            setTitleColor(.white, for: .normal) // Set the title color if there's any title
            clipsToBounds = true
        }
}
