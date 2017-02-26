//
//  FoldersTableViewCell.swift
//  MirrorNote
//
//  Created by Gleb Kalachev on 26.02.17.
//  Copyright © 2017 Gleb Kalachev. All rights reserved.
//

import UIKit

class FoldersTableViewCell: UITableViewCell {
   @IBOutlet weak var nameOfFolderLabel: UILabel!
   
   @IBOutlet weak var quantityOfElementsInFolderLabel: UILabel!
   
   override func awakeFromNib() {
      super.awakeFromNib()
      
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
      
      
   }
   
}
