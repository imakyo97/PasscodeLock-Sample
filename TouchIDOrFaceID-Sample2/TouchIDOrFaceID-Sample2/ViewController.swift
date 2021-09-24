//
//  ViewController.swift
//  TouchIDOrFaceID-Sample2
//
//  Created by 今村京平 on 2021/09/24.
//

import UIKit
import LocalAuthentication

class ViewController: UIViewController {

    @IBOutlet weak var resultLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didTapAuthTest(_ sender: Any) {
        // LAContext 認証ポリシーとアクセス制御を評価するためのメカニズム。
        let context = LAContext()
        var error: NSError?

        /* LAPolicyDeviceOwnerAuthentucation
         バイオメトリ、Apple Watch、またはデバイスパスコードを使用したユーザー認証。*/
        // canEvaluatePolicy Bool値を返す
        // 特定のポリシーに対して認証を続行できるかどうかを評価します。
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason: String
            // デバイスでサポートされている生体認証の種類。
            switch context.biometryType {
            case .none:
                print(".none")
                reason = "デバイスに生体認証はありません"
            case .touchID:
                print("touchID")
                reason = "ロック解除のためtouchIDを使用します"
            case .faceID:
                print("faceID")
                reason = "ロック解除のためfaceIDを使用します"
            @unknown default:
                print("unknown default")
                reason = "デバイスでサポートされている生体認証エラーです"
            }
            /* デッドロックになるため、evaluatePolicyではcanEvaluatePolicyを呼ばない*/
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                if let error = error {
                    self.setupLabelText(text: error.localizedDescription)
                }
                if success {
                    // 認証成功
                    self.setupLabelText(text:"認証に成功しました")
                } else {
                    // 認証失敗
                    self.setupLabelText(text:"認証に失敗しました")
                }
            }
        } else {
            if let error = error {
                print("\(error)")
            }
        }
    }
    private func setupLabelText(text: String) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.resultLabel.text = text
        }
    }
}

