//
//  CustomTextEditor.swift
//  EveCraft
//
//  Created by Purvi Sancheti on 29/08/25.
//

import SwiftUI
import StoreKit

struct CustomTextEditor: UIViewRepresentable {
    @Binding var text: String
    let characterLimit: Int = 1000
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: .scaledFontSize(14))
        textView.backgroundColor = UIColor.clear
        textView.textColor = UIColor.black
        textView.delegate = context.coordinator
        textView.isScrollEnabled = true
        
        textView.addDoneButtonOnKeyboard()
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {  // ✅ Update only when text actually changes
            uiView.text = text
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate {
        var parent: CustomTextEditor

        init(_ parent: CustomTextEditor) {
            self.parent = parent
        }

        // ✅ Handle character limit BEFORE text changes to avoid runtime warnings
        func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
            let currentText = textView.text ?? ""
            let newText = (currentText as NSString).replacingCharacters(in: range, with: text)
            
            // Allow the change only if it doesn't exceed the limit
            return newText.count <= parent.characterLimit
        }
        
        func textViewDidChange(_ textView: UITextView) {
            // ✅ Update SwiftUI text only if necessary and within limits
            let newText = textView.text ?? ""
            if parent.text != newText && newText.count <= parent.characterLimit {
                parent.text = newText
            }
        }
    }
}

// ✅ Extension to add a Done button
extension UITextView {
    func addDoneButtonOnKeyboard() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(dismissKeyboard))

        doneButton.tintColor = UIColor.black
        toolbar.items = [flexSpace, doneButton]
        self.inputAccessoryView = toolbar
    }

    @objc func dismissKeyboard() {
        self.resignFirstResponder()
    }
}
