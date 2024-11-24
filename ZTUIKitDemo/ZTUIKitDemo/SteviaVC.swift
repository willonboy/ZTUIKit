//
//  SteviaVC.swift
//  ZTUIKitDemo
//
//  Created by trojan
//


import UIKit
import Stevia
import ZTUIKitExt


@MainActor
func steivaLoginWidget() -> some UIView {
    var nameLbl: UILabel?
    var pwdLbl: UILabel?
    var usrTextField: UITextField?
    var pwdTextField: UITextField?
    
    let stack = ZTVStack {
        ZTWrapperWidget {
            ZTHStack {
                UILabel("User:").zt.ref(&nameLbl).subject
                ZTSpacer(axis: .h)
                UITextField("字母数字下划线").zt.ref(&usrTextField).backgroundColor(.gray)
                    .makeStevia { v, dom in
                        v.width(200).height(100)
                    }.subject
            }.zt.alignment(.fill).spacing(2).makeStevia { v, dom in
                |v|
            }.subject
            
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
func steivaLoginWidget2(_ bs:Bool) -> some UIView {
    var nameLbl: UILabel?
    var usrTextField: UITextField?
    
    let container = UIView {
        if bs {
            UILabel("User:").zt.ref(&nameLbl).makeStevia { v, dom in
                v.left(10).top(10).width(80).height(20)
            }.subject
        } else {
            UILabel("PWD:").zt.ref(&nameLbl).makeStevia { v, dom in
                v.left(10).top(10).width(80).height(20)
            }.subject
        }
        UITextField("字母数字下划线").zt.ref(&usrTextField).backgroundColor(.gray).makeStevia { v, dom in
            v.Left == nameLbl!.Right + 10
            v.Top == nameLbl!.Top
            v.width(200).height(20)
        }.subject
        
        ZTVStack {
            ZTSpacer(50)
            if bs {
                ZTVStack {
                    UILabel("if :")
                    ZTSpacer(10)
                    UILabel("ZTWrapperWidget:kkkk")
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


class SteviaVC: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.add {
            steivaLoginWidget().zt.domId("#v1").backgroundColor(.purple).makeStevia { v, dom in
                v.width(300).centerInContainer()
            }.build()
            
            steivaLoginWidget2(true).zt.makeStevia { v, dom in
                v.width(300).height(40).centerHorizontally()
                v.Top == dom("#v1")!.Bottom + 20
            }.build()
        }.render()
    }
}



