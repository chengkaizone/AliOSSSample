//
//  AdviseImageViewCell.swift
//  AliOSSSample
//
//  Created by tony on 2017/1/11.
//  Copyright © 2017年 chengkaizone. All rights reserved.
//

import UIKit

protocol AdviseImageViewCellDelegate: NSObjectProtocol {
    
    func cellDelete(cell: AdviseImageViewCell)
    
}

class AdviseImageViewCell: UICollectionViewCell {
    
    weak var delegate: AdviseImageViewCellDelegate?
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var btDel: UIButton!
    
    override func awakeFromNib() {
        
    }
    
    @IBAction func cellDeleteAction(_ sender: AnyObject) {
        
        self.delegate?.cellDelete(cell: self)
    }
    
}
