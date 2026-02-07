//
//  ViewController.swift
//  MasaCorporal
//
//  Created by Karla Lopez on 24/10/25.
//

import UIKit

final class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var weightTF: UITextField!
    @IBOutlet weak var heightTF: UITextField!
    @IBOutlet weak var calcButton: UIButton!

    private let decimalCharset = CharacterSet(charactersIn: "0123456789.,")
    private let numberFormatter: NumberFormatter = {
        let f = NumberFormatter()
        f.locale = .current
        f.numberStyle = .decimal
        return f
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        [weightTF, heightTF].forEach {
            $0?.keyboardType = .decimalPad
            $0?.delegate = self
            $0?.addTarget(self, action: #selector(syncButton), for: .editingChanged)
        }
        calcButton.isEnabled = false

    }

    @objc private func endEditingNow() {
        view.endEditing(true)
    }

    @objc private func syncButton() {
        let validW = parseLocaleNumber(weightTF.text) ?? -1
        let validH = parseLocaleNumber(heightTF.text) ?? -1
        calcButton.isEnabled = (validW > 0 && validH > 0)
    }

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        if string.isEmpty { return true }

        if string.rangeOfCharacter(from: decimalCharset.inverted) != nil {
            return false
        }

        let current = textField.text ?? ""
        let newText = (current as NSString).replacingCharacters(in: range, with: string)
        let separators = newText.filter { $0 == "." || $0 == "," }
        if separators.count > 1 { return false }

        return true
    }

    private func parseLocaleNumber(_ text: String?) -> Double? {
        guard var t = text?.trimmingCharacters(in: .whitespacesAndNewlines), !t.isEmpty else { return nil }
        if let n = numberFormatter.number(from: t)?.doubleValue { return n }
        t = t.replacingOccurrences(of: ",", with: ".")
        return Double(t)
    }

   
    @IBAction func calculateTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "showResult", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "showResult",
              let dest = segue.destination as? ResultViewController,
              let w = parseLocaleNumber(weightTF.text),
              let h = parseLocaleNumber(heightTF.text) else { return }
        dest.weightKg = w
        dest.heightM = h
    }
}

