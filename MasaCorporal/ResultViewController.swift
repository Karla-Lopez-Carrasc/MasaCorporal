//
//  ResultViewController.swift
//  MasaCorporal
//
//  Created by Karla Lopez on 24/10/25.
//

import UIKit

final class ResultViewController: UIViewController {

    @IBOutlet weak var bmiLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!

    var weightKg: Double = 0
    var heightM: Double = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        showBMI()
    }

    private func showBMI() {
        guard heightM > 0 else { return }
        let bmi = weightKg / (heightM * heightM)

        bmiLabel.text = String(format: "%.1f", bmi)
        let (title, detail) = category(for: bmi)
        messageLabel.text = "\(title)\n\(detail)"
    }

    private func category(for bmi: Double) -> (title: String, color: UIColor) {
        switch bmi {
        case ..<18.5:
            return ("Bajo peso", .systemBlue)
        case 18.5..<25.0:
            return ("Normal", .systemGreen)
        case 25.0..<30.0:
            return ("Sobrepeso", .systemOrange)
        case 30.0..<35.0:
            return ("Obesidad I", .systemRed)
        case 35.0..<40.0:
            return ("Obesidad II", .systemRed)
        case 40.0..<50.0:
            return ("Obesidad III", .systemRed)
        default:
            return ("Obesidad IV", .systemRed)
        }
    }
}
