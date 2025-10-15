    //
//  DescriptionView.swift
//  EveCraft
//
//  Created by Purvi Sancheti on 29/08/25.
//

import Foundation
import SwiftUI

struct DescriptionView: View {

    // MARK: - Public bindings
    @Binding var description: String
    @FocusState.Binding var isInputFocused: Bool

    // MARK: - Character limit
    private let characterLimit = 1000

    // MARK: - Haptics
    let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
    let notificationFeedback = UINotificationFeedbackGenerator()

    // MARK: - Prompts (master list)
    private static let allPrompts: [String] = [
        "Create a modern tropical garden with palm trees along the sides, a wooden deck in the center with lounge chairs, a small pool on one corner, and warm ambient lights around the edges.",
        "Design a luxury villa garden with a central swimming pool, marble walkways leading to a gazebo, trimmed hedges along the borders, and sunbeds near the poolside.",
        "Create a cozy zen garden with white gravel, stepping stones leading to a wooden bench, bonsai trees near a bamboo fence, and a koi pond surrounded by lanterns.",
        "Design a balcony garden with vertical greenery on one wall, a small seating corner with a rattan chair and coffee table, hanging plants on the railing, and string lights above.",
        "Create a rustic countryside garden with a wooden path leading to a bench, wildflowers spread across the grass, and a pergola with vines growing overhead.",
        "Design a Mediterranean courtyard garden with olive trees, terracotta pots of flowers, a stone-paved floor, and a water fountain in the center.",
        "Create an eco-friendly garden with native plants, a small solar-powered fountain, wooden compost bins at the back, and solar lights along the path.",
        "Design a romantic evening garden with rose arches along the path, fairy lights hanging from trees, a round table with two chairs in the middle, and candles near the edges.",
        "Create a desert-inspired garden with cacti and succulents in geometric beds, a stone path leading to a shaded seating area, and rocks surrounding a small water feature.",
        "Design a rooftop garden with wooden decking, modern lounge furniture in the corner, vertical greenery on one wall, and a city skyline view behind glass railings.",
        "Create a forest-style garden with tall trees providing shade, a hammock hanging between trunks, a firepit in the middle, and ferns covering the ground.",
        "Design a water-themed garden with a shallow reflecting pool in the center, stepping stones crossing over it, a low seating area to the left, and bamboo along the back.",
        "Create a family activity garden with a play area on one side, a dining and barbecue space on the other, open grass in the center, and flower borders near the fence.",
        "Design an urban minimalist garden with white stone tiles, a sculptural tree in the middle, rectangular planters along the walls, and hidden LED lights outlining the path.",
        "Create a yoga and wellness garden with soft grass flooring, a wooden yoga deck under shade trees, a small fountain nearby, and lavender borders for calm ambience.",
        "Create a modern hillside landscape with layered stone terraces, lush greenery on each level, a wooden deck at the top for lounging, and soft lighting along the steps.",
        "Design a luxury resort landscape featuring a central infinity pool, palm trees around the perimeter, walking paths with embedded lights, and shaded cabanas for relaxation.",
        "Create a cozy mountain retreat landscape with pine trees surrounding a small cabin, stone walkways winding uphill, a firepit in the center, and wildflowers scattered along the slopes.",
        "Design a desert rockscape with sandy terrain, large natural boulders, succulents arranged in patterns, and a pergola seating area offering shade.",
        "Create a tropical beachfront landscape with coconut palms along the sand, wooden boardwalks leading to the water, hammocks between trees, and beach loungers facing the horizon.",
        "Design a calm urban park landscape with paved walking trails, benches under trees, colorful flowerbeds along the edges, and an open grassy lawn in the center.",
        "Create a countryside meadow landscape with tall grass, wildflowers spread across rolling land, a dirt path leading to a small barn, and a rustic wooden fence surrounding the area.",
        "Design a Mediterranean hillside landscape with stone steps connecting terraces, olive trees and lavender lining the paths, and a courtyard overlooking the sea.",
        "Create a peaceful lakeside landscape with a wooden pier extending into the water, reeds near the shoreline, a campfire area on the bank, and distant mountain views.",
        "Design a futuristic urban landscape with geometric stone paths, glass railings, symmetrical greenery in planters, and subtle LED lighting along the walkways.",
        "Create a riverside nature trail landscape with winding wooden bridges, picnic spots under tall trees, pebble-lined riverbanks, and a trail following the water’s flow.",
        "Design a botanical sanctuary landscape with themed plant zones, curved pathways, shaded pergola seating, and a central pond filled with lilies.",
        "Create a snowy alpine landscape with pine trees covering white slopes, a wooden cabin near the base, and winding stone paths cutting through the snow.",
        "Design a golf course landscape with smooth rolling greens, sand bunkers placed near fairways, small reflective ponds, and trees framing the view.",
        "Create a zen rock garden landscape with raked gravel patterns, large placed stones, minimalist bonsai trees, and a wooden walkway enclosing the space."
    ]

    // MARK: - State for shuffled run
    @State private var prompts: [String] = Self.allPrompts.shuffled()
    @State private var currentIndex: Int = 0

    // MARK: - Computed properties
    private var remainingCharacters: Int {
        characterLimit - description.count
    }
    
    private var isNearLimit: Bool {
        remainingCharacters <= 100
    }

    var body: some View {
        VStack(alignment: .leading) {

            ZStack(alignment: .topLeading) {
                if description.isEmpty {
                    Text("Describe your Garden Idea")
                        .font(FontManager.generalSansRegularFont(size: .scaledFontSize(14)))
                        .foregroundColor(Color.appBlack.opacity(0.5))
                }

                CustomTextEditor(text: $description)
                    .font(FontManager.generalSansRegularFont(size: .scaledFontSize(14)))
                    .focused($isInputFocused)
                    .scrollContentBackground(.hidden)
                    .background(.clear)
                    .foregroundColor(Color.appBlack)
                    .offset(x: ScaleUtility.scaledSpacing(-3), y: ScaleUtility.scaledSpacing(-7))
            }

            Spacer()


            HStack {
                Button {
                    description = ""
                    notificationFeedback.notificationOccurred(.success)
                } label: {
                    Text("Clear")
                        .font(FontManager.generalSansRegularFont(size: .scaledFontSize(14)))
                        .foregroundColor(Color.appBlack.opacity(0.75))
                }

                Spacer()

                if description.count == 1000 {
                    Text("Character limit reached (1000)")
                        .font(FontManager.generalSansRegularFont(size: .scaledFontSize(10)))
                        .foregroundColor(.red)
                        .transition(.opacity)
                }
                else {
                    Button {
//                        AnalyticsManager.shared.log(.inspire)
                        impactFeedback.impactOccurred()
                        showNextPrompt() // 🔀 inject next non-repeating random prompt
                    } label: {
                        HStack(spacing: ScaleUtility.scaledSpacing(5)) {
                            Image(.sparkleIcon2)
                                .resizable()
                                .frame(width: ScaleUtility.scaledValue(18), height: ScaleUtility.scaledValue(18))
                            
                            Text("Get idea")
                                .font(FontManager.generalSansRegularFont(size: .scaledFontSize(14)))
                                .foregroundColor(Color.primaryApp)
                        }
                        .padding(.vertical, ScaleUtility.scaledSpacing(10))
                        .padding(.horizontal, ScaleUtility.scaledSpacing(10))
                        .background(Color.accent)
                        .cornerRadius(10)
                    }
                }
            }
        }
        .frame(height: ScaleUtility.scaledValue(145))
        .padding(.top, ScaleUtility.scaledSpacing(15))
        .padding(.bottom, ScaleUtility.scaledSpacing(15))
        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
        .background(Color.primaryApp)
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.appBlack.opacity(0.25), lineWidth: 1)
        )
        .padding(.horizontal, ScaleUtility.scaledSpacing(15))
    }

    // MARK: - Logic
    private func showNextPrompt() {
        guard !prompts.isEmpty else { return }
        let newPrompt = prompts[currentIndex]
        
        // ✅ Only set if it won't exceed the character limit
        if newPrompt.count <= characterLimit {
            description = newPrompt
        }
        
        currentIndex += 1

        if currentIndex >= prompts.count {
            // Reshuffle for a fresh random run after showing all 30
            prompts.shuffle()
            currentIndex = 0
        }
    }
}
