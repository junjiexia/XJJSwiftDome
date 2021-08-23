//
//  XJJDrawingToolView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/8/12.
//

import UIKit

class XJJDrawingToolView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var brushView: XJJDrawingTypeView!
    private var settingView: XJJDrawingSettingView!
    
    private func initUI() {
        
    }
    
    private func initBrush() {
        self.brushView = XJJDrawingTypeView()
    }
    
}

//MARK: - 工具设置
fileprivate class XJJDrawingSettingView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var imageView: UIImageView!
    private var colorButton: UIButton!
    private var sizeTextField: UITextField!
    private var redSliderView: XJJSliderView!
    private var greenSliderView: XJJSliderView!
    private var blueSliderView: XJJSliderView!
    private var opacitySliderView: XJJSliderView!
    private var sizeSliderView: XJJSliderView!
    
    private func initUI() {
        self.initImage()
        self.initColorBtn()
        self.initSize()
        self.initSlider()
    }
    
    private func initImage() {
        self.imageView = UIImageView()
        self.addSubview(imageView)
    }
    
    private func initColorBtn() {
        self.colorButton = UIButton(type: .custom)
        self.addSubview(colorButton)
        
        self.colorButton.backgroundColor = UIColor.white
        self.colorButton.addTarget(self, action: #selector(colorAction), for: .touchUpInside)
    }
    
    @objc private func colorAction(_ btn: UIButton) {
        
    }
    
    private func initSize() {
        self.sizeTextField = UITextField()
        self.addSubview(sizeTextField)
        
        self.sizeTextField.setText(XJJText("", alignment: .center))
        self.sizeTextField.addTarget(self, action: #selector(sizeAction), for: .editingChanged)
    }
    
    @objc private func sizeAction(_ tf: UITextField) {
        
    }
    
    private func initSlider() {
        self.redSliderView = XJJSliderView()
        self.addSubview(redSliderView)
        
        self.redSliderView.maxValue = 255
        
        self.greenSliderView = XJJSliderView()
        self.addSubview(greenSliderView)
        
        self.greenSliderView.maxValue = 255
        
        self.blueSliderView = XJJSliderView()
        self.addSubview(blueSliderView)
        
        self.blueSliderView.maxValue = 255
        
        self.opacitySliderView = XJJSliderView()
        self.addSubview(opacitySliderView)
        
        self.opacitySliderView.maxValue = 1
        self.opacitySliderView.decimals = 1
        
        self.sizeSliderView = XJJSliderView()
        self.addSubview(sizeSliderView)
        
        self.sizeSliderView.minValue = 1
        self.sizeSliderView.maxValue = 20
    }
}

//MARK: - 工具类型
fileprivate class XJJDrawingTypeView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var titleLabel: UILabel!
    private var collection: UICollectionView!
    private var dataSource: [XJJText] = [XJJText("铅笔"), XJJText("橡皮擦")]
    
    private func initUI() {
        self.backgroundColor = UIColor.white
    }
    
    private func initTitle() {
        self.titleLabel = UILabel()
        self.addSubview(titleLabel)
        
        self.titleLabel.setText(XJJText("工具类型"))
    }
    
    private func initCollection() {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        
        self.collection.delegate = self
        self.collection.dataSource = self
        self.collection.backgroundColor = UIColor.clear
        self.collection.alwaysBounceVertical = false
        self.collection.showsVerticalScrollIndicator = false
        self.collection.showsHorizontalScrollIndicator = false
        self.collection.register(XJJDrawingTypeCell.self, forCellWithReuseIdentifier: XJJDrawingTypeCell.identity)
    }
}

extension XJJDrawingTypeView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: XJJDrawingTypeCell.identity, for: indexPath) as! XJJDrawingTypeCell
        
        cell.text = dataSource[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

//MARK: - 工具类型单元格
fileprivate class XJJDrawingTypeCell: UICollectionViewCell {
    
    static let identity = "XJJDrawingTypeCell"
    
    var text: XJJText? {
        didSet {
            guard let _text = text else {return}
            self.setupText(_text)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var textLabel: UILabel!
    
    private func initUI() {
        self.setupUI()
        self.initText()
    }
    
    private func setupUI() {
        self.backgroundColor = UIColor.white
        self.clipsToBounds = true
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor(white: 0, alpha: 0.1).cgColor
    }
    
    private func initText() {
        self.textLabel = UILabel()
        self.addSubview(textLabel)
    }
    
    private func setupText(_ text: XJJText) {
        self.textLabel.setText(text)
        
        self.textLabel.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
    }
}
