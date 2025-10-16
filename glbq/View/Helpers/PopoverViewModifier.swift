//
//  PopoverViewModifier.swift
//  GLBQ
//
//  Created by Purvi Sancheti on 16/10/25.
//

import Foundation
import SwiftUI

// Popover Modifier
struct PopoverViewModifier<PopoverContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    var popoverSize: CGSize?
    let popoverContent: () -> PopoverContent
    var popoverOffsetX: CGFloat
    var popoverIpadOffsetX: CGFloat
    var popoverOffsetY: CGFloat
    var popoverIpadOffsetY: CGFloat
    init(
        isPresented: Binding<Bool>,
        popoverSize: CGSize? = CGSize(width: 113, height: 74),
        popoverContent: @escaping () -> PopoverContent,
        popoverOffsetX: CGFloat,
        popoverIpadOffsetX: CGFloat,
        popoverOffsetY: CGFloat,
        popoverIpadOffsetY: CGFloat
        
    ) {
        self._isPresented = isPresented
        self.popoverSize = popoverSize
        self.popoverContent = popoverContent
        self.popoverOffsetX = popoverOffsetX
        self.popoverIpadOffsetX = popoverIpadOffsetX
        self.popoverOffsetY = popoverOffsetY
        self.popoverIpadOffsetY = popoverIpadOffsetY
    }

    func body(content: Content) -> some View {
        content
            .background(
                PopoverWrapper(
                    isPresented: $isPresented,
                    popoverSize: popoverSize,
                    popoverContent: popoverContent
                )
                .offset(x: isIPad ? popoverIpadOffsetX : popoverOffsetX, y: isIPad ? popoverIpadOffsetY : popoverOffsetY)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            )
    }
}



// The Wrapper that will handle the popover logic
struct PopoverWrapper<PopoverContent: View>: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    var popoverSize: CGSize?
    let popoverContent: () -> PopoverContent

    func makeUIViewController(context: Context) -> PopoverViewController<PopoverContent> {
        let controller = PopoverViewController(
            popoverSize: popoverSize,
            popoverContent: popoverContent) {
            self.isPresented = false
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: PopoverViewController<PopoverContent>, context: Context) {
        uiViewController.updateSize(popoverSize)
        if isPresented {
            uiViewController.showPopover()
        } else {
            uiViewController.hidePopover()
        }
    }
}

// Popover ViewController to manage the actual popover
class PopoverViewController<PopoverContent: View>: UIViewController, UIPopoverPresentationControllerDelegate {
    var popoverSize: CGSize?
    let popoverContent: () -> PopoverContent
    let onDismiss: () -> Void
    
    var popoverVC: UIViewController?

    init(
        popoverSize: CGSize?,
        popoverContent: @escaping () -> PopoverContent,
        onDismiss: @escaping () -> Void) {
        self.popoverSize = popoverSize
        self.popoverContent = popoverContent
        self.onDismiss = onDismiss
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none // Keeps popover on iPhone
    }

    func showPopover() {
        guard popoverVC == nil else { return }
        let vc = UIHostingController(rootView: popoverContent())
        if let size = popoverSize { vc.preferredContentSize = size }
        vc.modalPresentationStyle = .popover
        
        if let popover = vc.popoverPresentationController {
            popover.sourceView = view
            popover.delegate = self
            popover.permittedArrowDirections = []  // No arrow
            
            // Position the popover **above** the source view
            let rect = CGRect(x: view.bounds.midX - (popoverSize?.width ?? 0) / 2,
                              y: view.bounds.origin.y + 20, // Adjust this to position above
                              width: popoverSize?.width ?? 300,
                              height: popoverSize?.height ?? 200)
            popover.sourceRect = rect
        }
        
        popoverVC = vc
        self.present(vc, animated: true, completion: nil)
    }

    func hidePopover() {
        guard let vc = popoverVC, !vc.isBeingDismissed else { return }
        vc.dismiss(animated: true, completion: nil)
        popoverVC = nil
    }

    func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
        popoverVC = nil
        self.onDismiss()
    }

    func updateSize(_ size: CGSize?) {
        self.popoverSize = size
        if let vc = popoverVC, let size = size {
            vc.preferredContentSize = size
        }
    }
}


