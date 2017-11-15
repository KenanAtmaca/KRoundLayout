//
//
//  Copyright © 2017 Kenan Atmaca. All rights reserved.
//  kenanatmaca.com
//
//

import UIKit

protocol KRoundLayoutDelegate: class {
    func getItem(item:(UIImage,Int))
}

fileprivate protocol RoundCollectionDelegate: class {
    func didSelect(index:Int)
}

class KRoundLayout: UIButton, RoundCollectionDelegate {
   
    fileprivate lazy var collection:RoundCollection = RoundCollection()
    private var rightConstraints = NSLayoutConstraint()
    
    var images:[UIImage] = []
    var titles:[String] = []
    var delegate:KRoundLayoutDelegate?
  
    var selectColor:UIColor? {
        didSet {
            collection.selectColor = selectColor
        }
    }
    
    var borderColors:UIColor? {
        didSet {
            collection.borderColor = borderColors
        }
    }
    
    var action:(()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collection.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        
        collection.images = images
        collection.titles = titles
        
        setupButton()
        
        self.superview?.addSubview(collection)
        self.superview?.bringSubview(toFront: collection)
        
        collection.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            collection.bottomAnchor.constraint(equalTo: self.topAnchor, constant: -10),
            collection.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40),
            collection.heightAnchor.constraint(equalToConstant: 60),
            collection.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        ])
    }
    
    private func setupButton() {
        
        self.setTitle("", for: .normal)
        self.layer.borderWidth = 5
        self.layer.borderColor = UIColor.white.withAlphaComponent(0.8).cgColor
        self.clipsToBounds = true
        self.layer.cornerRadius = frame.height / 2
        self.backgroundColor = UIColor.clear
    }
    
    func didSelect(index:Int) {
        delegate?.getItem(item: (images[index],index))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if action != nil {
            self.action!()
        }
    }
    
    func hide() {
        collection.collectionView.isHidden = true
    }
    
    func show() {
        collection.collectionView.isHidden = false
    }

}//

 fileprivate class RoundCollection: UIView, UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    fileprivate var delegate:RoundCollectionDelegate?
    private var selectCellRow:IndexPath!
    
    var selectFlag:Bool = false
    var images:[UIImage] = []
    var titles:[String] = []
    
    var selectColor:UIColor?
    var borderColor:UIColor?

    var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.backgroundColor = UIColor.clear
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(RoundCollectionCell.self, forCellWithReuseIdentifier: "cCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        addSubview(collectionView)
    }
    
    override func didMoveToSuperview() {
        
        self.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width - 40, height: 60))
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.frame.size = CGSize(width: self.frame.width / 2, height: 60)
        collectionView.isScrollEnabled = true
        
         NSLayoutConstraint.activate([
            collectionView.widthAnchor.constraint(equalToConstant: self.frame.width),
            collectionView.heightAnchor.constraint(equalToConstant: self.frame.height),
            collectionView.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            collectionView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
         ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cCell", for: indexPath) as! RoundCollectionCell
        
        if images.count == titles.count {
            
            if !cell.isSelected {
                cell.imgView.alpha = 1
                cell.imgView.layer.borderWidth = 0
                cell.textLabel.font = UIFont(name: "Avenir", size: 13)
            }
            
            cell.imgView.image = images[indexPath.row]
            cell.textLabel.text = titles[indexPath.row]
        } else {
            fatalError("@ Arrays should be equel items count.")
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 70, height: 60)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        delegate?.didSelect(index: indexPath.row)

        let cell = collectionView.cellForItem(at: indexPath) as! RoundCollectionCell
        cell.imgView.alpha = 0.7
        cell.imgView.layer.borderWidth = 2
        cell.imgView.layer.borderColor = selectColor?.cgColor ?? UIColor.black.cgColor
        cell.textLabel.font = UIFont.boldSystemFont(ofSize: 14)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}//

fileprivate class RoundCollectionCell: UICollectionViewCell {
    
    var imgView:UIImageView = {
        let view = UIImageView()
        view.frame = CGRect(origin: .zero, size: CGSize(width: 42, height: 42))
        view.layer.cornerRadius = view.frame.height / 2
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    var textLabel:UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = UIColor.white
        label.backgroundColor = UIColor.clear
        label.font = UIFont(name: "Avenir", size: 13)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(imgView)
        contentView.addSubview(textLabel)
        
        imgView.translatesAutoresizingMaskIntoConstraints = false
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imgView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            imgView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            imgView.widthAnchor.constraint(equalToConstant: 42),
            imgView.heightAnchor.constraint(equalToConstant: 42)
        ])
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: 2),
            textLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            textLabel.widthAnchor.constraint(equalToConstant: 70),
            textLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}//
