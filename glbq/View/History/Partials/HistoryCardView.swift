//
//  HistoryCardView.swift
//  GLBQ
//
//  Created by Purvi Sancheti on 16/10/25.
//

import Foundation
import SwiftUI
import CoreData

struct HistoryCardView: View {
    let record: ImageRecord
    let imagesDirectory: URL
    let onDelete: () -> Void
    let onClick: () -> Void
    @State private var showDeleteAlert = false
    @State private var navigateToPreview = false
    @State private var previewImage: UIImage?
    
    let notificationFeedback = UINotificationFeedbackGenerator()
    let impactFeedback = UIImpactFeedbackGenerator(style: .light)
    
    var body: some View {
        
        Button {
            impactFeedback.impactOccurred()
            onClick()
        } label: {
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: isIPad ?  ScaleUtility.scaledValue(350) : ScaleUtility.scaledValue(165),
                       height: isIPad ?  ScaleUtility.scaledValue(265) : ScaleUtility.scaledValue(165))
                .background {
                    ZStack(alignment: .topTrailing) {
                        // Load image from local path
                        if let relativePath = record.value(forKey: "localPath") as? String {
                            let fullURL = imagesDirectory.appendingPathComponent(relativePath)
                            
                            if let data = try? Data(contentsOf: fullURL),
                               let uiImage = UIImage(data: data) {
                                
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width:isIPad ?  ScaleUtility.scaledValue(365) : ScaleUtility.scaledValue(165),
                                           height: isIPad ?  ScaleUtility.scaledValue(265) : ScaleUtility.scaledValue(165))
                                    .clipped()
                                
                            } else {
                                // Fallback placeholder
                                Color.gray.opacity(0.2)
                                    .frame(width: isIPad ?  ScaleUtility.scaledValue(365) : ScaleUtility.scaledValue(165),
                                           height: isIPad ?  ScaleUtility.scaledValue(265) :  ScaleUtility.scaledValue(165))
                            }
                        } else {
                            // No path available
                            Color.gray.opacity(0.2)
                                .frame(width: isIPad ?  ScaleUtility.scaledValue(365) :  ScaleUtility.scaledValue(165),
                                       height: isIPad ?  ScaleUtility.scaledValue(265) : ScaleUtility.scaledValue(165))
                        }
                        
                        // Delete button
                        Button {
                            notificationFeedback.notificationOccurred(.warning)
                            showDeleteAlert = true
                        } label: {
                            Image(.deleteIcon2)
                                .resizable()
                                .frame(width: ScaleUtility.scaledValue(18), height: ScaleUtility.scaledValue(18))
                                .padding(.all, ScaleUtility.scaledSpacing(5))
                                .background(Color.appBlack.opacity(0.5))
                                .clipShape(Circle())
                                .overlay(
                                    Circle()
                                        .stroke(Color.primaryApp.opacity(0.25), lineWidth: 1)
                                )
                                .padding(.top, ScaleUtility.scaledSpacing(10))
                                .padding(.trailing, ScaleUtility.scaledSpacing(10))
                        }
                    }
                }
                .cornerRadius(20)
         
        }
        .alert("Delete Image", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) {
                notificationFeedback.notificationOccurred(.error)
            }
            Button("Delete", role: .destructive) {
                notificationFeedback.notificationOccurred(.success)
//                AnalyticsManager.shared.log(.deleteOne)
                deleteRecord()
            }
        } message: {
            Text("Are you sure you want to delete this image?")
        }
    }
    
    private func deleteRecord() {
        // Delete the local file
        if let relativePath = record.value(forKey: "localPath") as? String {
            let fullURL = imagesDirectory.appendingPathComponent(relativePath)
            try? FileManager.default.removeItem(at: fullURL)
        }
        
        // Delete from Core Data
        let context = PersistenceController.shared.container.viewContext
        context.delete(record)
        try? context.save()
        
        // Notify parent to refresh
        onDelete()
    }
}
