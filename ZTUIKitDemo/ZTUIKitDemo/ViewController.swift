//
//  ViewController.swift
//  ZTUIKitDemo
//
//  Created by trojan on 2024/6/4.
//

import UIKit
import SnapKit

func loginWidget() -> ZTWidgetProtocol {
    var nameLbl: UILabel?
    var pwdLbl: UILabel?
    var usrTextField: UITextField?
    var pwdTextField: UITextField?
    
    let stack = ZTVStackWidget {
        ZTWrapperWidget {
            ZTHStackWidget {
                UILabel().ref(&nameLbl).zt.text("User:").textColor(.black).subject
                ZTHSpacer(10)
                UITextField().ref(&usrTextField).zt.placeholder("字母数字下划线").backgroundColor(.gray).textColor(.black).subject.zt_makeConstraints { make in
                    make.width.equalTo(200)
                    make.height.equalTo(100)
                }
            }.zt.alignment(.leading).spacing(2).subject
            
            ZTHStackWidget {
                UILabel().ref(&pwdLbl).zt.text("Pwd:").textColor(.black).subject
                ZTHSpacer(13)
                UITextField().ref(&pwdTextField).zt.placeholder("字母数字符号组合").backgroundColor(.gray).textColor(.black).subject
            }.zt.alignment(.leading).spacing(2).subject
        }
    }.zt.alignment(.leading)
        .spacing(10)
        .subject
    
    _ = usrTextField!.zt.text("这里是输入的用户名")
    _ = pwdTextField!.zt.text("这里是输入的用户密码")
    
    return stack
}


func loginWidget2(_ bs:Bool) -> ZTWidgetProtocol {
    var nameLbl: UILabel?
    var usrTextField: UITextField?
    
    let container = ZTContainerWidget {
        if bs {
            ZTWrapperWidget {
                UILabel().ref(&nameLbl).zt.text("tips:").textColor(.black).subject
                UILabel().ref(&nameLbl).zt.text("tips:").textColor(.black).subject
                UILabel().ref(&nameLbl).zt.text("tips:").textColor(.black).subject
            }
        }
        if #available(iOS 17, *) {
            UILabel().ref(&nameLbl).zt.text("tips:").textColor(.black).subject
            UILabel().ref(&nameLbl).zt.text("tips:").textColor(.black).subject
            UILabel().ref(&nameLbl).zt.text("tips:").textColor(.black).subject
            UILabel().ref(&nameLbl).zt.text("tips:").textColor(.black).subject
        } else {
            for i in 0..<10 {
                UILabel().ref(&nameLbl).zt.text("tips:").textColor(.black).subject
            }
        }
        
        if bs {
            UILabel().ref(&nameLbl).zt.text("User:").textColor(.black).subject.zt_makeConstraints { make in
                make.left.top.equalTo(10)
                make.width.equalTo(80)
                make.height.equalTo(20)
            }
        } else {
            UILabel().ref(&nameLbl).zt.text("PWD:").textColor(.black).subject.zt_makeConstraints { make in
                make.left.top.equalTo(10)
                make.width.equalTo(80)
                make.height.equalTo(20)
            }
        }
        UITextField().ref(&usrTextField).zt.placeholder("字母数字下划线").backgroundColor(.gray).textColor(.black).subject.zt_makeConstraints { make in
            make.left.equalTo(nameLbl!.snp.right).offset(10)
            make.top.equalTo(nameLbl!)
            make.width.equalTo(200)
            make.height.equalTo(20)
        }
    }
    return container
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stack = loginWidget().view.addTo(self.view).zt.backgroundColor(.purple).subject.zt_makeConstraints { make in
            make.width.equalTo(300)
            make.center.equalTo(self.view)
        }
        stack.render()
        
        let container = loginWidget2(true).view.addTo(self.view).zt_makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalTo(stack.snp.bottom).offset(20)
        }
        container.render()
    }
}

