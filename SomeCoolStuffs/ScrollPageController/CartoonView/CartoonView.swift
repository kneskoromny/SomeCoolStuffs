//
//  CartoonView.swift
//  SomeCoolStuffs
//
//  Created by Кирилл Нескоромный on 11.06.2022.
//

import UIKit

class CartoonView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet private var cartoonImageView: UIImageView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(String(describing: Self.self), owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    func configure(withImage image: UIImage) {
        cartoonImageView?.image = image
    }
}
