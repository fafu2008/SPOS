//
//  RolesTableViewCell.swift
//  SPOS
//
//  Created by 许佳强 on 16/5/25.
//  Copyright © 2016年 张晓飞. All rights reserved.
//

import UIKit

class RolesTableViewCell: UITableViewCell {

    var role_item:AppRoleItem?
    
    lazy var roleName:UILabel = {
        let label = UILabel(frame: CGRect(x: 50, y: 10, width: 80, height: 30))
        return label
    }()
    lazy var checked:UISwitch = {
        let sw = UISwitch(frame: CGRect(x: SCREENWIDTH - 80, y: 15, width: 30, height: 20))
        return sw
    }()

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      
        roleName.textColor = UIColor.darkGrayColor()
        roleName.font = UIFont.systemFontOfSize(15)
        roleName.textAlignment = .Left
        self.contentView.addSubview(roleName)
        
        checked.onImage = UIImage(named: "0013")
        checked.offImage = UIImage(named: "0012")
        checked.addTarget(self, action: #selector(RolesTableViewCell.checkedSwitchClicked(_:)), forControlEvents:.ValueChanged)
        
        
        self.contentView.addSubview(checked)
        
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func checkedSwitchClicked(sender:UISwitch){
        TTGLog("checkedSwitchClicked \(sender.tag)")
        if (sender.on == true){
            role_item?.checked = "1"
        }else{
            role_item?.checked = "0"
        }
    }
    
}
