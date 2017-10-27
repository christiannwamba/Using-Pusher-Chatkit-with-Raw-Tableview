//
//  MessageTableViewCell.swift
//  chatroom
//
//  Created by Neo Ighodaro on 27/10/2017.
//  Copyright © 2017 CreativityKills Co. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    static let kMessageTableViewCellMinimumHeight: CGFloat = 50.0;
    static let kMessageTableViewCellAvatarHeight: CGFloat = 30.0;
    
    static let CellIdentifier: String = "MessageCell";
    
    var _bodyLabel: UILabel?
    var _titleLabel: UILabel?
    var _thumbnailView: UIImageView?
    
    var indexPath: IndexPath?
    var usedForMessage: Bool?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    func setup() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.white
        
        configureSubviews()
    }
    
    func configureSubviews() {
        contentView.addSubview(thumbnailView())
        contentView.addSubview(titleLabel())
        contentView.addSubview(bodyLabel())
        
        let views: [String:Any] = [
            "thumbnailView": thumbnailView(),
            "titleLabel": titleLabel(),
            "bodyLabel": bodyLabel()
        ]
        
        let metrics = [
            "tumbSize": MessageTableViewCell.kMessageTableViewCellAvatarHeight,
            "padding": 15,
            "right": 10,
            "left": 5
        ]
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-left-[thumbnailView(tumbSize)]-right-[titleLabel(>=0)]-right-|",
            options: [],
            metrics: metrics,
            views: views
        ))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-left-[thumbnailView(tumbSize)]-right-[bodyLabel(>=0)]-right-|",
            options: [],
            metrics: metrics,
            views: views
        ))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|-right-[thumbnailView(tumbSize)]-(>=0)-|",
            options: [],
            metrics: metrics,
            views: views
        ))
        
        if (reuseIdentifier == MessageTableViewCell.CellIdentifier) {
            contentView.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-right-[titleLabel(20)]-left-[bodyLabel(>=0@999)]-left-|",
                options: [],
                metrics: metrics,
                views: views
            ))
        }
        else {
            contentView.addConstraints(NSLayoutConstraint.constraints(
                withVisualFormat: "V:|[titleLabel]|",
                options: [],
                metrics: metrics,
                views: views
            ))
        }
    }
    
    // MARK: Getters
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        selectionStyle = .none
        
        let pointSize: CGFloat = MessageTableViewCell.defaultFontSize()
        
        titleLabel().font = UIFont.boldSystemFont(ofSize: pointSize)
        bodyLabel().font = UIFont.systemFont(ofSize: pointSize)
        titleLabel().text = ""
        bodyLabel().text = ""
    }
    
    func titleLabel() -> UILabel {
        if _titleLabel == nil {
            _titleLabel = UILabel()
            _titleLabel?.translatesAutoresizingMaskIntoConstraints = false
            _titleLabel?.backgroundColor = UIColor.clear
            _titleLabel?.isUserInteractionEnabled = false
            _titleLabel?.numberOfLines = 0
            _titleLabel?.textColor = UIColor.gray
            _titleLabel?.font = UIFont.boldSystemFont(ofSize: MessageTableViewCell.defaultFontSize())
        }
        
        return _titleLabel!
    }
    
    func bodyLabel() -> UILabel {
        if _bodyLabel == nil {
            _bodyLabel = UILabel()
            _bodyLabel?.translatesAutoresizingMaskIntoConstraints = false
            _bodyLabel?.backgroundColor = UIColor.clear
            _bodyLabel?.isUserInteractionEnabled = false
            _bodyLabel?.numberOfLines = 0
            _bodyLabel?.textColor = UIColor.darkGray
            _bodyLabel?.font = UIFont.systemFont(ofSize: MessageTableViewCell.defaultFontSize())
        }
        
        return _bodyLabel!
    }
    
    func thumbnailView() -> UIImageView {
        if _thumbnailView == nil {
            _thumbnailView = UIImageView()
            _thumbnailView?.translatesAutoresizingMaskIntoConstraints = false
            _thumbnailView?.isUserInteractionEnabled = false
            _thumbnailView?.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
            _thumbnailView?.layer.cornerRadius = MessageTableViewCell.kMessageTableViewCellAvatarHeight / 2.0
            _thumbnailView?.layer.masksToBounds = true
        }
        
        return _thumbnailView!
    }
    
    class func defaultFontSize() -> CGFloat {
        return 16.0
    }
}
