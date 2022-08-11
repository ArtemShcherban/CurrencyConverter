//
//  PopUpWindow.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 19.07.2022.
//

import UIKit

protocol ConverterWindowViewDelegate: AnyObject {
}

@IBDesignable
final class ConverterWindowView: PopUpWindowView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var sellButton: UIButton!
    @IBOutlet weak var usdTextField: AdjustableTextField!
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: ConverterWindowViewDelegate?
    weak var tableViewDelegate: UITableViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContentView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureContentView()
        configureTableView()
        configure()
    }
    
    private func configureContentView() {
        Bundle.main.loadNibNamed("ConverterWindowView", owner: self, options: nil)
        contentView.layer.cornerRadius = 10
        contentView.fixInView(self)
    }
    
    private func configureTableView() {
        tableView.delegate = tableViewDelegate
        tableView.dataSource = self
        tableView.register(
            UINib(nibName: ConverterCell.reuseIdentifier, bundle: nil),
            forCellReuseIdentifier: ConverterCell.reuseIdentifier)
    }
    
    private func configure() {
        transform = CGAffineTransform(scaleX: 0.001, y: 1)
    }
    
    @IBAction func rotateButtonPressed(_ sender: Any) {
        popUpWindowDelegate?.rotateButtonPressed()
    }
}

extension ConverterWindowView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ConverterCell.reuseIdentifier, for: indexPath) as? ConverterCell else {
            return UITableViewCell()
        }
        cell.configure(with: indexPath)
        return cell
    }
}
