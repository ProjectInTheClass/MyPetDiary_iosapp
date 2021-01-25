//
//  SettingViewController.swift
//  DogWalker_iosapp
//
//  Created by EunYoung on 2021/01/08.
//

import UIKit
import MessageUI

class SettingViewController: UITableViewController, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var settingTableView: UITableView!
    @IBAction func unwindFromModal (seque: UIStoryboardSegue) {}
    @IBAction func backToSetting (seque: UIStoryboardSegue) {}

    var composeVC = MFMailComposeViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    func sendEmail() {
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setToRecipients(["jjy1000@dgu.ac.kr"])
        composeVC.setSubject("Hello!")
        composeVC.setMessageBody("의견을 보내주세요!", isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Called when Cell is selected.
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 0 {
        } else if indexPath.section == 1 {
            composeVC = MFMailComposeViewController()
            composeVC.delegate = self
            composeVC.mailComposeDelegate = self
            if !MFMailComposeViewController.canSendMail() {
                print("Mail services are not available")
                return
            }
            sendEmail()
        } else {
            return
        }
    }
//    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
//        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 150, height: 35))
//        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//        toastLabel.textColor = UIColor.white
//        toastLabel.font = font
//        toastLabel.textAlignment = .center;
//        toastLabel.text = message
//        toastLabel.alpha = 1.0
//        toastLabel.layer.cornerRadius = 10;
//        toastLabel.clipsToBounds = true
//        self.view.addSubview(toastLabel)
//        UIView.animate(withDuration: 10.0, delay: 0.1, options: .curveEaseOut, animations: { toastLabel.alpha = 0.0 }, completion: {(isCompleted) in toastLabel.removeFromSuperview() })
//    }
}
