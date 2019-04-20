//
//  OmikujiModel.swift
//  omikuji2
//
//  Created by sakiyamaK on 2019/04/15.
//  Copyright © 2019 吉田みなみ. All rights reserved.
//

import UIKit

class OmikujiModel{
  //生成用の辞書に使うkey
  static let DIC_KEY_ID = "id"
  static let DIC_KEY_TEXT = "text"
  static let DIC_KEY_IMAGE = "image"

  var id:Int = -1
  var text:String?
  var image:UIImage?

  //辞書型からインスタンスを生成するinit
  init(dic:[String:Any]){
    self.id = dic[OmikujiModel.DIC_KEY_ID] as? Int ?? -1
    self.text = dic[OmikujiModel.DIC_KEY_TEXT] as? String ?? ""
    self.image = UIImage(named: dic[OmikujiModel.DIC_KEY_IMAGE] as? String ?? "")
  }
}
