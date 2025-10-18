//
//  HistoryView.swift
//  glbq
//
//  Created by Purvi Sancheti on 11/10/25.
//

import Foundation
import SwiftUI
import CoreData

struct HistoryView: View {
    
   
    @State var navigateToSettings: Bool = false
    @State private var sortNewestFirst = true
    @State private var records: [ImageRecord] = []
    @State var isDropdownOpen = false
    @State private var showDeleteAllAlert = false
    
    // Navigation states for ImagePreview
    @State private var navigateToPreview = false
    @State private var selectedImage: UIImage?
    @State private var selectedRecord: ImageRecord?
    
    var startDesign: () -> Void

    @State var showFilterSheet: Bool = false
    @State var selectedFilter: String = "Reset"
    
    private let store = CoreDataManager.shared
    
    var body: some View {
        VStack(spacing: 0) {
            
              HistoryTopView(selectedFilter: $selectedFilter,
                             isDropdownOpen: $isDropdownOpen,
                             sortNewestFirst: $sortNewestFirst,
                             showFilterSheet: $showFilterSheet,
                             showDeleteAllAlert: $showDeleteAllAlert)
            
        
     
            if records.isEmpty {
                EmptyView(startDesign: {
                    startDesign()
                })
            } else {
                ScrollView {
                    
                    
                    Spacer()
                        .frame(height: ScaleUtility.scaledValue(20))
                    
                    LazyVStack(alignment: .leading,spacing: ScaleUtility.scaledSpacing(15)) {
                        ForEach(Array(records.chunked(into: 2)), id: \.first?.objectID) { rowRecords in
                            HStack(spacing: ScaleUtility.scaledSpacing(15)) {
                                ForEach(rowRecords, id: \.objectID) { rec in
                                
                                    HistoryCardView(
                                        record: rec,
                                        imagesDirectory: getImagesDirectory(),
                                        onDelete: reload,
                                        onClick: {
                                            if let relativePath = rec.value(forKey: "localPath") as? String {
                                                let fullURL = getImagesDirectory().appendingPathComponent(relativePath)
                                                
                                                if let data = try? Data(contentsOf: fullURL),
                                                   let uiImage = UIImage(data: data) {
                                                    selectedImage = uiImage
                                                }
                                            }
                                            selectedRecord = rec
                                            navigateToPreview = true
                                        }
                                    )
                                    
                                    
                                    
                                }
                            }
                        }
                    }
                    .padding(.horizontal, ScaleUtility.scaledSpacing(15))
                    
                    Spacer()
                        .frame(height: ScaleUtility.scaledValue(100))
      
                }
            }
           
            
            Spacer()
            
        }
        .background {
            Image(.appBg)
                .resizable()
                .frame(maxWidth: .infinity,maxHeight: .infinity)
        }
        .ignoresSafeArea(.all)
        .onAppear {
            reload()
        }
        .onChange(of: sortNewestFirst) { _ in
            reload()
        }
        .onChange(of: selectedFilter) { newFilter in
            if newFilter == "Reset" {
                // Reset filter - show all records
                reload()
            } else {
                // Filter records based on source
                filterRecords(by: newFilter)
            }
        }
        .navigationDestination(isPresented: $navigateToPreview) {
            if let image = selectedImage, let record = selectedRecord {
                PreviewScreen(
                    image: image,
                    record: record,
                    onDelete: {
                        // Handle delete from preview
                        if let relativePath = record.value(forKey: "localPath") as? String {
                            let fullURL = getImagesDirectory().appendingPathComponent(relativePath)
                            try? FileManager.default.removeItem(at: fullURL)
                        }
                        
                        let context = PersistenceController.shared.container.viewContext
                        context.delete(record)
                        try? context.save()
                        
                        reload() // Refresh the view
                    },
                    onBack: {
                        navigateToPreview = false
                    }
                )
            }
        }
        .alert("Delete All Images", isPresented: $showDeleteAllAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete All", role: .destructive) {
//                AnalyticsManager.shared.log(.deleteAll)
                deleteAllImages()
            }
        } message: {
            Text("Are you sure you want to delete all Designs?")
        }
        .sheet(isPresented: $showFilterSheet) {
            FilterSheetView(selectedFilter: $selectedFilter, showSheet: $showFilterSheet)
                .frame(height: isIPad ? ScaleUtility.scaledValue(660) : ScaleUtility.scaledValue(440) )
                .background(Color.primaryApp)
                .presentationDetents([.height( isIPad ? ScaleUtility.scaledValue(520) : ScaleUtility.scaledValue(440))])
                .presentationCornerRadius(20)
        }
    }
    
    // MARK: - Reload function
    private func reload() {
        do {
            records = try store.fetchHistory(newestFirst: sortNewestFirst)
        } catch {
            print("Failed to fetch history:", error.localizedDescription)
            records = []
        }
    }
    
    // MARK: - Filter records by source
    private func filterRecords(by filter: String) {
        do {
            let allRecords = try store.fetchHistory(newestFirst: sortNewestFirst)
            
            // Map filter names to source values
            let sourceMap: [String: String] = [
                "Templates" : "Templates",
                "Ai Garden": "Ai Garden",
                "Recreate": "Recreate",
                "Add Objects": "Add Objects",  // Fixed: matches AddObjectsView
                "Remove Objects": "Remove Objects",  // Fixed: matches RemoveObjectsView
                "Replace Objects": "Replace Objects",  // Fixed: matches ReplaceObjectsView
                "Dream Garden": "Dream Garden"
            ]
            
            if let sourceName = sourceMap[filter] {
                records = allRecords.filter { record in
                    if let source = record.value(forKey: "source") as? String {
                        return source == sourceName
                    }
                    return false
                }
            } else {
                records = allRecords
            }
        } catch {
            print("Failed to filter history:", error.localizedDescription)
            records = []
        }
    }
    
    private func deleteAllImages() {
        // Delete local files for current filter
        let imagesDir = getImagesDirectory()
        for record in records {
            if let relativePath = record.value(forKey: "localPath") as? String {
                let fullURL = imagesDir.appendingPathComponent(relativePath)
                try? FileManager.default.removeItem(at: fullURL)
            }
        }
        
        // Delete from Core Data based on current filter
        do {
            try store.deleteHistory()
            reload() // Refresh after deletion
        } catch {
            print("Delete all failed:", error.localizedDescription)
        }
    }
    
    // ADDED: Helper function to get images directory (same as LocalImageStore)
    private func getImagesDirectory() -> URL {
        let appSupport = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let folder = appSupport.appendingPathComponent("GLBQ", isDirectory: true)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        let images = folder.appendingPathComponent("Images", isDirectory: true)
        try? FileManager.default.createDirectory(at: images, withIntermediateDirectories: true)
        return images
    }
    
}



extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}
