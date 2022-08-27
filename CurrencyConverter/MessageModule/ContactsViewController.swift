//
//  ContactsViewController.swift
//  CurrencyConverter
//
//  Created by Artem Shcherban on 23.08.2022.
//

import Foundation
import Contacts
import ContactsUI

class ContactsViewController: CNContactPickerViewController, CNContactPickerDelegate {
    lazy var messageModel = MessageModel.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contactProperty: CNContactProperty) {
        guard
            contactProperty.key == "phoneNumbers",
            let phoneNumber = contactProperty.value as? CNPhoneNumber else {
            return
        }
        let stringPhoneNumber = phoneNumber.stringValue
       
        self.dismiss(animated: true)
        messageModel.prepareMessage(for: stringPhoneNumber)
    }
}
 
