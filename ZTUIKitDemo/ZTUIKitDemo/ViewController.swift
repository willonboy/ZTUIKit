//
//  ViewController.swift
//  ZTUIKitDemo
//
//  Created by trojan on 2024/6/4.
//

import UIKit
import SnapKit
import ZTChain


@MainActor
func snpLoginWidget() -> some UIView {
    var nameLbl: UILabel?
    var pwdLbl: UILabel?
    var usrTextField: UITextField?
    var pwdTextField: UITextField?
    
    let stack = ZTVStack {
        ZTWrapperWidget {
            ZTHStack {
                UILabel("User:").zt.ref(&nameLbl).subject
                ZTSpacer(10, axis: .h)
                UITextField("字母数字下划线").zt.ref(&usrTextField).backgroundColor(.gray)
                    .makeSnapkit { make, _ in
                    make.width.equalTo(200)
                    make.height.equalTo(100)
                }.subject
            }.zt.alignment(.leading).spacing(2).subject
            
            ZTHStack {
                UILabel("Pwd:").zt.ref(&pwdLbl).subject
                ZTSpacer(13, axis: .h)
                UITextField("字母数字符号组合").zt.ref(&pwdTextField).backgroundColor(.gray).subject
            }.zt.alignment(.leading).spacing(2).subject
        }
    }.zt.alignment(.leading)
        .spacing(10)
        .subject
    
    _ = usrTextField!.zt.text("这里是输入的用户名")
    _ = pwdTextField!.zt.text("这里是输入的用户密码")
    
    return stack
}


@MainActor
func snpLoginWidget2(_ bs:Bool) -> some UIView {
    var nameLbl: UILabel?
    var usrTextField: UITextField?
    
    let container = UIView {
        
        if bs {
            UILabel("User:").zt.ref(&nameLbl).makeSnapkit { make, _ in
                make.left.top.equalTo(10)
                make.width.equalTo(80)
                make.height.equalTo(20)
            }.subject
        } else {
            UILabel("PWD:").zt.ref(&nameLbl).makeSnapkit { make, _ in
                make.left.top.equalTo(10)
                make.width.equalTo(80)
                make.height.equalTo(20)
            }.subject
        }
        UITextField("字母数字下划线").zt.ref(&usrTextField).backgroundColor(.gray).makeSnapkit { make, _ in
            make.left.equalTo(nameLbl!.snp.right).offset(10)
            make.top.equalTo(nameLbl!)
            make.width.equalTo(200)
            make.height.equalTo(20)
        }.subject
        
        ZTVStack {
            ZTSpacer(50)
            if bs {
                ZTVStack {
                    UILabel("if :")
                    ZTSpacer(10)
                    UILabel("ZTWrapperWidget:")
                    ZTSpacer(10)
                    UILabel("tips:")
                }
            }
            ZTSpacer(10)
            if #available(iOS 17, *) {
                ZTVStack {
                    UILabel("if #available")
                    ZTSpacer(10)
                    UILabel("if #available")
                    ZTSpacer(10)
                    UILabel("if #available").zt.textColor(.red).build()
                }
            } else {
                for _ in 0..<10 {
                    ZTWrapperWidget {
                        ZTSpacer(10)
                        UILabel("for in")
                    }
                }
            }
        }
    }
    return container
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stack = snpLoginWidget().zt.addTo(self.view).backgroundColor(.purple).makeSnapkit { make, _ in
            make.width.equalTo(300)
            make.center.equalTo(self.view)
        }.render()
        
        snpLoginWidget2(true).zt.addTo(self.view).makeSnapkit { make, _ in
            make.width.equalTo(300)
            make.height.equalTo(40)
            make.centerX.equalToSuperview()
            make.top.equalTo(stack.snp.bottom).offset(20)
        }.render()
    }
}

