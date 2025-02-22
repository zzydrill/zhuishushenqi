//
//  QSCatalogViewController.swift
//  zhuishushenqi
//
//  Created yung on 2017/4/21.
//  Copyright © 2017年 QS. All rights reserved.
//
//  Template generated by Juanpe Catalán @JuanpeCMiOS
//

typealias ZSVoicePlayerCatelogHandler = ()->Void

class ZSVoicePlayerCatelogHeaderView: UITableViewHeaderFooterView {
    
    var backhandler:ZSVoicePlayerCatelogHandler?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backButton.frame = CGRect(x: 15, y: bounds.height/2 - 24/2, width: 24, height: 24)
        titleLabel.frame = CGRect(x: 50, y: bounds.height/2 - 30/2, width: bounds.width - 100, height: 30)
        totalLabel.frame = CGRect(x: bounds.width - 100 - 15, y: bounds.height/2 - 30/2, width: 100, height: 30)
        separatorLine.frame = CGRect(x: 0, y: bounds.height - 0.5, width: bounds.width, height: 0.5)
    }
    
    func bind(title:String, total:String) {
        titleLabel.text = title
        totalLabel.text = total
    }
    
    @objc
    private func backAction() {
        backhandler?()
    }
    
    private func setupSubviews() {
        contentView.backgroundColor = UIColor.white
        backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "discover_icon_back_24_24"), for: .normal)
        backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        contentView.addSubview(backButton)
        
        titleLabel = UILabel(frame: CGRect.zero)
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 24)
        titleLabel.textColor = UIColor.black
        contentView.addSubview(titleLabel)
        
        totalLabel = UILabel(frame: CGRect.zero)
        totalLabel.textAlignment = .right
        totalLabel.font = UIFont.systemFont(ofSize: 13)
        totalLabel.textColor = UIColor.gray
        contentView.addSubview(totalLabel)
        
        separatorLine = UIView(frame: CGRect.zero)
        separatorLine.backgroundColor = UIColor.gray
        separatorLine.alpha = 0.3
        contentView.addSubview(separatorLine)
    }
    
    fileprivate var backButton:UIButton!
    fileprivate var titleLabel:UILabel!
    fileprivate var totalLabel:UILabel!
    fileprivate var separatorLine:UIView!
}
