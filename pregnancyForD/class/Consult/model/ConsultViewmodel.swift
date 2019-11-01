//
//  HC_consultViewmodel.swift
//  aileyun
//
//  Created by huchuang on 2017/8/25.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class ConsultViewmodel: NSObject {
    var headIVF : CGRect?
    var timeF : CGRect?
    
    var nameF : CGRect?
    
    var statusF : CGRect?
    
    var wordsF : CGRect?
    var picF : CGRect?
    var voiceF : CGRect?
    
    var contVF : CGRect?
    
    var cellHeight : CGFloat?
    
    var model : ConsultPickModel? {
        didSet{
            
            let cellHor : CGFloat = 20
            let cellV : CGFloat = 10
            
            let spaceToHead : CGFloat = 10
            let spaceToContV : CGFloat = 3
            let headWidth : CGFloat = 40
            
            let wordMaxW = SCREEN_WIDTH - headWidth - 100
            
            let timeMargin : CGFloat = 15
            let timeH : CGFloat = 15
            
            let imgW = (wordMaxW - 20) / 3
            let imgMargin : CGFloat = 10
            
            let voiceW : CGFloat = 120
            let voiceH : CGFloat = 30
            
            
            if model?.isPati == "1"{
                if model?.type == TypeText{
                    let tempWordSize = HCGetSize(content: model?.content as! NSString, maxWidth: wordMaxW, font: UIFont.init(name: kReguleFont, size: 18)!)
                    let tempTimeSize = HCGetSize(content: model?.createT as! NSString, maxWidth: wordMaxW, font: UIFont.systemFont(ofSize: 14))
                    var width : CGFloat
                    if tempTimeSize.width > tempWordSize.width{
                        width = tempTimeSize.width
                    }else{
                        width = tempWordSize.width
                    }
                    headIVF = CGRect.init(x: cellHor, y: cellV, width: headWidth, height: headWidth)
                    timeF = CGRect.init(x: cellHor + headWidth + spaceToHead, y: cellV, width: tempTimeSize.width + 5, height: timeH)
                    wordsF = CGRect.init(x: cellHor + headWidth + spaceToHead, y: cellV + timeH + timeMargin, width: width + 2, height: tempWordSize.height + 2)
                    contVF = CGRect.init(x: cellHor + headWidth + spaceToHead - spaceToContV, y: cellV + timeH + timeMargin - spaceToContV, width: width + 2 + spaceToContV * 2, height: tempWordSize.height + 2 + spaceToContV * 2)
                    cellHeight = (wordsF?.maxY)! + cellV
                }else if model?.type == TypeMix{
                    guard var c = model?.imageList?.count else{return}
                    let imgConW = CGFloat(c) * (imgW + imgMargin) - imgMargin
                    let tempWordSize = HCGetSize(content: model?.content as! NSString, maxWidth: wordMaxW, font: UIFont.init(name: kReguleFont, size: 18)!)
                    let tempTimeSize = HCGetSize(content: model?.createT as! NSString, maxWidth: wordMaxW, font: UIFont.systemFont(ofSize: 14))
                    var width : CGFloat
                    if tempTimeSize.width > tempWordSize.width{
                        width = tempTimeSize.width
                    }else{
                        width = tempWordSize.width
                    }
                    headIVF = CGRect.init(x: cellHor, y: cellV, width: headWidth, height: headWidth)
                    timeF = CGRect.init(x: cellHor + headWidth + spaceToHead, y: cellV, width: tempTimeSize.width, height: timeH)
                    wordsF = CGRect.init(x: cellHor + headWidth + spaceToHead , y: cellV + timeH + timeMargin, width: width, height: tempWordSize.height + 2)
                    picF = CGRect.init(x: cellHor + headWidth + spaceToHead, y: cellV + timeH + timeMargin + tempWordSize.height + imgMargin, width: imgConW, height: imgW)
                    var totalW : CGFloat
                    if width > imgConW{
                        totalW = width
                    }else{
                        totalW = imgConW
                    }
                    contVF = CGRect.init(x: cellHor + headWidth + spaceToHead - spaceToContV, y: cellV + timeH + timeMargin - spaceToContV, width: totalW + spaceToContV * 2, height: tempWordSize.height + 2 + imgMargin + imgW + spaceToContV * 2)
                    cellHeight = (picF?.maxY)! + cellV
                }
                //共同的
                let tempStatusSize = HCGetSize(content: model?.status as! NSString, maxWidth: 100, font: UIFont.init(name: kReguleFont, size: 14)!)
                statusF = CGRect.init(x: SCREEN_WIDTH - cellHor - tempStatusSize.width - 6, y: cellV, width: tempStatusSize.width + 6, height: tempStatusSize.height + 6)
            }else{//来自医生的消息
                let headX = SCREEN_WIDTH - cellHor - headWidth
                if model?.type == TypeText {
                    let tempWordSize = HCGetSize(content: model?.content as! NSString, maxWidth: wordMaxW, font: UIFont.init(name: kReguleFont, size: 18)!)
                    let tempTimeSize = HCGetSize(content: model?.createT as! NSString, maxWidth: wordMaxW, font: UIFont.systemFont(ofSize: 14))
                    var width : CGFloat
                    if tempTimeSize.width > tempWordSize.width{
                        width = tempTimeSize.width
                    }else{
                        width = tempWordSize.width
                    }
                    headIVF = CGRect.init(x: headX, y: cellV, width: headWidth, height: headWidth)
                    timeF = CGRect.init(x: headX - spaceToHead - tempTimeSize.width - 2, y: cellV, width: tempTimeSize.width + 2, height: timeH)
                    wordsF = CGRect.init(x: headX - spaceToHead - width - 2, y: cellV + timeH + timeMargin, width: width + 2, height: tempWordSize.height + 2)
                    contVF = CGRect.init(x: headX - spaceToHead - width - 2 - spaceToContV, y: cellV + timeH + timeMargin - spaceToContV, width: width + 2 + spaceToContV * 2, height: tempWordSize.height + 2 + spaceToContV * 2)
                    cellHeight = (wordsF?.maxY)! + cellV
                }else if model?.type == TypePic{
                    guard let c = model?.imageList?.count else{return}
                    let tempTimeSize = HCGetSize(content: model?.createT as! NSString, maxWidth: wordMaxW, font: UIFont.systemFont(ofSize: 14))
                    let imgConW = CGFloat(c) * (imgW + imgMargin) - imgMargin
                    headIVF = CGRect.init(x: headX, y: cellV, width: headWidth, height: headWidth)
                    timeF = CGRect.init(x: headX - spaceToHead - tempTimeSize.width - 2, y: cellV, width: tempTimeSize.width + 2, height: timeH)
                    picF = CGRect.init(x: headX - spaceToHead - imgConW - 2, y: cellV + timeH + timeMargin, width: imgConW, height: imgW)
                    contVF = CGRect.init(x: headX - spaceToHead - imgConW - 2 - spaceToContV, y: cellV + timeH + timeMargin - spaceToContV, width: imgConW + spaceToContV * 2, height: imgW + spaceToContV * 2)
                    cellHeight = (picF?.maxY)! + cellV
                }else if model?.type == TypeVoice{
                    let tempTimeSize = HCGetSize(content: model?.createT as! NSString, maxWidth: wordMaxW, font: UIFont.systemFont(ofSize: 14))
                    headIVF = CGRect.init(x: headX, y: cellV, width: headWidth, height: headWidth)
                    timeF = CGRect.init(x: headX - spaceToHead - tempTimeSize.width - 2, y: cellV, width: tempTimeSize.width + 2, height: timeH)
                    voiceF = CGRect.init(x: headX - spaceToHead - voiceW, y: cellV + timeH + timeMargin, width: voiceW, height: voiceH)
                    cellHeight = (voiceF?.maxY)! + cellV
                }
                //共同
                guard model?.doctName != nil else{return}
                nameF = CGRect.init(x: headX, y: cellV + headWidth + 2, width: headWidth + 2, height: 20)
            }
        }
    }
    
}
