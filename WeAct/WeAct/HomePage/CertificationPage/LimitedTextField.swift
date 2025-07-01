//
//  LimitedTextField.swift
//  WeAct
//
//  Created by 현승훈 on 7/1/25.
//

import SwiftUI
import UIKit

struct LimitedTextField: UIViewRepresentable {
    @Binding var text: String
    var placeholder: String
    var characterLimit: Int

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.placeholder = placeholder
        textField.delegate = context.coordinator
        textField.borderStyle = .none
        textField.backgroundColor = .clear
        textField.returnKeyType = .done

        // ✅ '완료' 버튼이 있는 툴바를 키보드 상단에 붙임
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: context.coordinator, action: #selector(context.coordinator.doneButtonTapped))

        toolbar.items = [flexibleSpace, doneButton]
        textField.inputAccessoryView = toolbar

        return textField
    }



    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: LimitedTextField

        init(_ parent: LimitedTextField) {
            self.parent = parent
        }

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            guard let stringRange = Range(range, in: textField.text ?? "") else { return false }
            let updatedText = (textField.text ?? "").replacingCharacters(in: stringRange, with: string)
            if updatedText.count <= parent.characterLimit {
                parent.text = updatedText
                return true
            } else {
                return false
            }
        }

        @objc func doneButtonTapped() {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }

        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }

}
