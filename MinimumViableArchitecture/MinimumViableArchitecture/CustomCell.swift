//
//  CustomCell.swift
//  MinimumViableArchitecture
//
//  Created by Jon Bott on 2/16/17.
//  Copyright © 2017 Jon Bott. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var birthLabel: UILabel!

    var viewModel = CustomViewModel()
    
    func configure(person: PersonDao){
        
        let firstName = person.firstName ?? ""
        let lastName  = person.lastName  ?? ""
        
        nameLabel.text = "\(firstName) \(lastName)"
        birthLabel.text = person.birthDate?.string ?? ""
        
        guard let url = person.profileImage?.url else { return }
        
        viewModel.loadImage(urlString: url) { [weak self] image in
            self?.profileImageView.image = image
        }
    }
    
    override func prepareForReuse() {
        nameLabel.text  = ""
        birthLabel.text = ""
        profileImageView.image = nil
    }
}
