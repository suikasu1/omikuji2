//
//  ViewController.swift
//  omikuji2
//
//  Created by 吉田みなみ on 2019/01/20.
//  Copyright © 2019 吉田みなみ. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  //おみくじを辞書型の配列で用意
  private let OMIKUJI_DIC_LIST = [
    [OmikujiModel.DIC_KEY_ID:1, OmikujiModel.DIC_KEY_TEXT:"今日のラッキー言語　Python", OmikujiModel.DIC_KEY_IMAGE:"goal"],
    [OmikujiModel.DIC_KEY_ID:2, OmikujiModel.DIC_KEY_TEXT:"今日のラッキー言語　Swift", OmikujiModel.DIC_KEY_IMAGE:"presen"],
    [OmikujiModel.DIC_KEY_ID:3, OmikujiModel.DIC_KEY_TEXT:"今日のラッキー言語　Ruby", OmikujiModel.DIC_KEY_IMAGE:"sleep"],
    [OmikujiModel.DIC_KEY_ID:4, OmikujiModel.DIC_KEY_TEXT:"今日のラッキー言語　C", OmikujiModel.DIC_KEY_IMAGE:"rpg"],
    [OmikujiModel.DIC_KEY_ID:5, OmikujiModel.DIC_KEY_TEXT:"今日のラッキー言語　Go", OmikujiModel.DIC_KEY_IMAGE:"read"],
    [OmikujiModel.DIC_KEY_ID:6, OmikujiModel.DIC_KEY_TEXT:"今日のラッキー言語　Java", OmikujiModel.DIC_KEY_IMAGE:"zasetsu"],
    [OmikujiModel.DIC_KEY_ID:7, OmikujiModel.DIC_KEY_TEXT:"今日のラッキー言語　PHP", OmikujiModel.DIC_KEY_IMAGE:"break"],
  ]

  //OMIKUJI_DIC_LISTからおみくじインスタンスの配列を生成
  private lazy var omikujiList:[OmikujiModel] = {
    return self.OMIKUJI_DIC_LIST.map{OmikujiModel.init(dic: $0)}
  }()

  //前回選択したおみくじ
  private var selectedOmikuji:OmikujiModel?
  //前回選択した日時
  private var selectedDate:Date?

  private let INTERVAL_HOUR = 6

  @IBOutlet weak var answerImageView: UIImageView!
  @IBOutlet weak var answerLabel: UILabel!
  @IBOutlet weak var answerButton: UIButton!
  @IBOutlet weak var shareButton: UIButton!
  @IBOutlet weak var defaultLabel: UILabel!

  
  @IBAction func SNS(_ sender: Any) {
    //表示画像をアンラップしてシェア画像を取り出し
    guard let shareImage = answerImageView.image else{return}

    //UIActivityViewControllerに渡す配列を作成
    let shareItems = [shareImage]

    //UIActivityViewControllerにシェア画像を渡す
    let controller = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)

    //iPadで落ちてしまう対策
    controller.popoverPresentationController?.sourceView = view

    //UIActivityViewControllerを表示
    present(controller, animated: true, completion: nil)
  }

  @IBAction func shuffleAction(_ sender: Any) {

    //ボタンの連打防止
    answerButton.isEnabled = false

    //結果が出るまでシェアボタンは押せないようにする
    shareButton.isEnabled = false

    //omikujiListから前回と違う結果からランダムに選択
    let omikuji = omikujiList.filter({$0.id != selectedOmikuji?.id}).shuffled().first

    let date = Date()
    var interval = -1
    if let d = self.selectedDate{
      interval = Int(date.timeIntervalSince(d)/3600)
    }
    //データがちゃんとあるかチェック
    guard
      let text = omikuji?.text,
      let image = omikuji?.image
      else{
        //ボタンを押せるようにする
        answerButton.isEnabled = true
        //エラーなのでシェアボタンは押せないままにする
        shareButton.isEnabled = false
        return
    }

    //経過時間をチェック
    guard interval < 0 || interval > INTERVAL_HOUR else{
      //ボタンを押せるようにする
      answerButton.isEnabled = true
      //エラーなのでシェアボタンは押せないままにする
      shareButton.isEnabled = false
      //アラートを表示する
      self.showAlert(hour: interval)
      return
    }


    self.selectedOmikuji = omikuji
    self.selectedDate = date

    //結果をアニメーションでじんわり表示させるために一旦透明にする
    answerLabel.alpha = 0
    answerImageView.alpha = 0

    //おみくじ結果の代入
    answerLabel.text = text
    answerImageView.image = image

    //結果をアニメーションでじんわり表示
    UIView.animate(withDuration: 0.5, animations: {
      self.defaultLabel.isHidden = true
      self.answerLabel.isHidden = false
      self.shareButton.isHidden = false
      self.answerLabel.alpha = 1
      self.answerImageView.alpha = 1
    }, completion: {(_) in
      //アニメーションが終わったらボタンを押せるようにする
      self.answerButton.isEnabled = true
      //シェアボタンを押せるようにする
      self.shareButton.isEnabled = true
    })
  }

  private func showAlert(hour:Int){

    let alert = UIAlertController(title: "おみくじは６時間に１回しか引けません", message: "次に引けるまであと\(INTERVAL_HOUR - hour)時間です", preferredStyle: UIAlertController.Style.alert)
    let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
    alert.addAction(action)
    self.present(alert, animated: true, completion: nil)
  }
}
