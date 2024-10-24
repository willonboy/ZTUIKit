//
//  ViewController.swift
//  ZTUIKitDemo
//
//  Created by trojan on 2024/6/4.
//

import UIKit
import SnapKit

func loginWidget() -> some UIView {
    var nameLbl: UILabel?
    var pwdLbl: UILabel?
    var usrTextField: UITextField?
    var pwdTextField: UITextField?
    
    let stack = ZTVStackWidget {
        ZTWrapperWidget {
            ZTHStackWidget {
                UILabel().zt.ref(&nameLbl).text("User:").textColor(.black).subject
                ZTHSpacer(10)
                UITextField().zt.ref(&usrTextField).placeholder("字母数字下划线").backgroundColor(.gray).textColor(.black).makeConstraints { make in
                    make.width.equalTo(200)
                    make.height.equalTo(100)
                }.subject
            }.zt.alignment(.leading).spacing(2).subject
            
            ZTHStackWidget {
                UILabel().zt.ref(&pwdLbl).text("Pwd:").textColor(.black).subject
                ZTHSpacer(13)
                UITextField().zt.ref(&pwdTextField).placeholder("字母数字符号组合").backgroundColor(.gray).textColor(.black).subject
            }.zt.alignment(.leading).spacing(2).subject
        }
    }.zt.alignment(.leading)
        .spacing(10)
        .subject
    
    _ = usrTextField!.zt.text("这里是输入的用户名")
    _ = pwdTextField!.zt.text("这里是输入的用户密码")
    
    return stack
}


func loginWidget2(_ bs:Bool) -> some UIView {
    var nameLbl: UILabel?
    var usrTextField: UITextField?
    
    let container = ZTContainerWidget {
        if bs {
            ZTWrapperWidget {
                UILabel().zt.ref(&nameLbl).text("tips:").textColor(.black).subject
                UILabel().zt.ref(&nameLbl).text("tips:").textColor(.black).subject
                UILabel().zt.ref(&nameLbl).text("tips:").textColor(.black).subject
            }
        }
        if #available(iOS 17, *) {
            UILabel().zt.ref(&nameLbl).text("tips:").textColor(.black).subject
            UILabel().zt.ref(&nameLbl).text("tips:").textColor(.black).subject
            UILabel().zt.ref(&nameLbl).text("tips:").textColor(.black).subject
            UILabel().zt.ref(&nameLbl).text("tips:").textColor(.black).subject
        } else {
            for _ in 0..<10 {
                UILabel().zt.ref(&nameLbl).text("tips:").textColor(.black).subject
            }
        }
        
        if bs {
            UILabel().zt.ref(&nameLbl).text("User:").textColor(.black).makeConstraints { make in
                make.left.top.equalTo(10)
                make.width.equalTo(80)
                make.height.equalTo(20)
            }.subject
        } else {
            UILabel().zt.ref(&nameLbl).text("PWD:").textColor(.black).makeConstraints { make in
                make.left.top.equalTo(10)
                make.width.equalTo(80)
                make.height.equalTo(20)
            }.subject
        }
        UITextField().zt.ref(&usrTextField).placeholder("字母数字下划线").backgroundColor(.gray).textColor(.black).makeConstraints { make in
            make.left.equalTo(nameLbl!.snp.right).offset(10)
            make.top.equalTo(nameLbl!)
            make.width.equalTo(200)
            make.height.equalTo(20)
        }.subject
    }
    return container
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stack = loginWidget().zt.addTo(self.view).backgroundColor(.purple).makeConstraints { make in
            make.width.equalTo(300)
            make.center.equalTo(self.view)
        }.subject
        stack.render()
        
        loginWidget2(true).zt.addTo(self.view).makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalTo(stack.snp.bottom).offset(20)
        }.build().render()
    }
}

