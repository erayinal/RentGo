//
//  BasketProductsTableViewCell.swift
//  RentGo
//
//  Created by Eray İnal on 15.04.2025.
//

import UIKit

class BasketProductsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var productTitleLabel: UILabel!
    @IBOutlet weak var productDeliveryLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var productCountLabel: UILabel!
    @IBOutlet weak var weeklyButton: UIButton!
    @IBOutlet weak var monthlyButton: UIButton!
    
    
    
    var onDelete: (() -> Void)?
    var onCountChanged: ((Int) -> Void)?
    var onDeliveryChanged: ((BasketProduct.DeliveryType) -> Void)?
    
    private var count = 1
    
    func configure(with product: BasketProduct) {
        productTitleLabel.text = product.name
                productDeliveryLabel.text = "Estimated Delivery: 3 days"
                count = product.count
                productCountLabel.text = "\(count)"
                
                let unitPrice = product.deliveryType == .weekly ? product.weeklyPrice : product.monthlyPrice
                productPriceLabel.text = String(format: "$%.2f", unitPrice * Double(count))

                // 🖼️ Görsel yükleme — önce sıfırla
                productImageView.image = nil
                if let urlString = product.imageUrl {
                    productImageView.loadImage(from: urlString)
                } else {
                    productImageView.image = UIImage(named: product.imageName ?? "default_image")
                }

                // 🎛️ Buton konfigürasyonu
                if #available(iOS 15.0, *) {
                    var weeklyConfig = UIButton.Configuration.gray()
                    var monthlyConfig = UIButton.Configuration.gray()

                    if product.deliveryType == .weekly {
                        weeklyConfig = .filled()
                    } else {
                        monthlyConfig = .filled()
                    }

                    weeklyConfig.title = "Weekly"
                    monthlyConfig.title = "Monthly"

                    weeklyButton.configuration = weeklyConfig
                    monthlyButton.configuration = monthlyConfig
                }
        
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
        
        productImageView.layer.cornerRadius = 10
        productImageView.clipsToBounds = true
        
        /*
         layer.shadowColor = UIColor.black.cgColor
         layer.shadowOffset = CGSize(width: 0, height: 1)
         layer.shadowOpacity = 0.2
         layer.shadowRadius = 4
         layer.masksToBounds = false
         */
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        super.setSelected(false, animated: false)
    }
    
    @IBAction func decreaseCountTapped(_ sender: Any) {
        if count > 1 {
            count -= 1
            productCountLabel.text = "\(count)"
            onCountChanged?(count)
        }
    }
    
    @IBAction func increaseCountTapped(_ sender: Any) {
        count += 1
        productCountLabel.text = "\(count)"
        onCountChanged?(count)
    }
    
    
    @IBAction func weeklyTapped(_ sender: Any) {
        onDeliveryChanged?(.weekly)
    }
    
    @IBAction func monthlyTapped(_ sender: Any) {
        onDeliveryChanged?(.monthly)
    }
    
}
