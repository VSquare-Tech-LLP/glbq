//
//  PromptBuilder.swift
//  GLBQ
//
//  Created by Purvi Sancheti on 15/10/25.
//

import Foundation


enum PromptBuilder {
    
    
    private static let typesPrompts: [String: String] = [
        "House": "Create a beautiful front yard garden in front of a modern house with a lawn, flower beds, and a stone walkway leading to the entrance. No people.",
        "Apartment": "Create a cozy apartment balcony garden with potted plants, hanging flowers, a small chair, and city views in the background. No people.",
        "Office": "Create a clean office courtyard garden with trimmed plants, benches, modern planters, and glass building reflections around. No people.",
        "Café":  "Create a charming café outdoor garden with tables, string lights, potted flowers, and a warm, inviting atmosphere. No people.",
        "Rooftop":  "Create a stylish rooftop garden with wooden decking, lounge furniture, green plants, and a panoramic city skyline view. No people.",
        "Resort": "Create a tropical resort garden with palm trees, a swimming pool, deck chairs, and a luxury vacation ambience. No people.",
        "Park": "Create a spacious park landscape with open green lawns, trees, walking paths, benches, and sunlight filtering through leaves. No people.",
        "Villa": "Create an elegant villa garden with a marble pathway, fountain in the center, trimmed hedges, and luxury outdoor furniture. No people.",
        "Backyard": "Create a cozy backyard garden with grass, a wooden fence, patio furniture, and flower beds along the sides. No people.",
    ]
    
    private static let designPrompts: [String: String] = [
        "Modern": "Create a sleek modern garden with clean geometric paths, minimal plants, stone tiles, and stylish outdoor furniture in neutral tones. No people.",
        "Luxury": "Create an elegant luxury garden with a central pool, marble flooring, sculpted hedges, warm lighting, and premium lounge seating. No people.",
        "Cozy": "Create a warm cozy garden with wooden furniture, soft string lights, potted flowers, and a comfortable, homey atmosphere. No people.",
        "Asian": "Create a serene Asian garden with bamboo, stone lanterns, a koi pond, and a small wooden bridge surrounded by greenery. No people.",
        "Tropical":  "Create a vibrant tropical garden with palm trees, colorful flowers, wooden decking, and a sunny island resort vibe. No people.",
        "Minimal":  "Create a clean minimal garden with simple stone pathways, sparse plants, neutral tones, and open space for calm balance. No people.",
        "Rustic": "Create a charming rustic garden with wooden fences, wildflowers, a stone path, and natural textures for a countryside feel. No people.",
        "Classic": "Create a timeless classic garden with symmetrical hedges, a central fountain, elegant benches, and neatly trimmed greenery. No people.",
    ]

    private static let objectPrompts: [String: String] = [
        "Pool": "Create a realistic swimming pool with clean water, simple tiling, and a plain neutral background. No people.",
        "Furniture": "Create elegant outdoor furniture including a chair and table with a clean, minimal background. No people.",
        "Gazebo": "Create a beautiful wooden gazebo with detailed structure and a plain background. No people.",
        "Fountain": "Create a classic water fountain with clear details and a simple, clean background. No people.",
        "Pathway": "Create a stone or tile garden pathway viewed from above with a plain neutral background. No people.",
        "Trees": "Create a realistic tree with full green foliage and a clean white background. No people.",
        "Lights": "Create decorative garden lights or lanterns with a clear, minimal background. No people.",
        "Firepit": "Create a modern outdoor firepit with clean lines and a simple, plain background. No people.",
        "Bench": "Create a wooden or metal garden bench centered with a clean, minimal background. No people.",
    ]
    
    // MARK: - Ai Garden Design View
    
    static func buildPrompt(typeName: String,
                            themeName: String,
                            objectNames: Set<String>) -> String {
        var parts: [String] = []

        if let e = typesPrompts[typeName], !e.isEmpty { parts.append(e) }
        if let d = designPrompts[themeName], !d.isEmpty { parts.append(d) }
        let objectBits = objectNames.compactMap { objectPrompts[$0] }
        if !objectBits.isEmpty { parts.append(objectBits.joined(separator: ", ")) }

        // Append universal constraints so outputs look consistent
        let guardrails = [
            "High quality, professional photo.",
            "No text or logos. No people.",
            "Keep the venue architecture intact.",
            "venue place must be same as given in image",
            "Balanced composition, realistic lighting.",
        ]
        parts.append(guardrails.joined(separator: " "))

        return parts.joined(separator: " ")
    }
    
    // MARK: - Dream Garden Designer
    
    static func buildTextPrompt(description: String,
                                designName: String?,
                                objectNames: Set<String>) -> String {
        var parts: [String] = []
        // 1) user description (required)
        parts.append(description.trimmingCharacters(in: .whitespacesAndNewlines))

        // 2) optional design
        if let d = designName, !d.isEmpty,
           let dp = designPrompts[d], !dp.isEmpty {
            parts.append(dp)
        }

        // 3) optional objects (combine selected)
        let objectBits = objectNames.compactMap { objectPrompts[$0] }
        if !objectBits.isEmpty {
            parts.append(objectBits.joined(separator: ", "))
        }

        // 4) your existing guardrails (mirrors your buildPrompt style)
        parts.append("High quality, professional photo. No text or logos. No people. Balanced composition, realistic lighting.")

        return parts.joined(separator: " ")
    }
    
    // MARK: - Add object prompt
    
    
    static func buildAddObjectsPrompt(
          objectDescription: String?,
          venueContext: String? = nil,
          keepBackground: Bool = true
      ) -> String {
          var parts: [String] = []

          if let desc = objectDescription?.trimmingCharacters(in: .whitespacesAndNewlines),
             !desc.isEmpty {
              parts.append("Add the following object(s) into the venue: \"\(desc)\".")
          } else {
              parts.append("Add the provided object image into the venue.")
          }

          if keepBackground {
              parts.append("Preserve the existing background, architecture and overall composition.")
          }
          if let ctx = venueContext, !ctx.isEmpty {
              parts.append("Environment context: \(ctx). Do not replace or remove this environment.")
          }

          parts.append("""
          Make the addition look natural, realistically scaled and lit, with proper shadows and reflections.
          High quality, realistic lighting, balanced composition. No people, no text or logos.
          """)
          parts.append("Avoid floating objects, wrong perspective, or harsh cutout edges.")

          return parts.joined(separator: " ")
      }
    
    // MARK: - Remove object prompt
    
    
    static func buildObjectRemovalPrompt(
              remove: String,
              gardenContext: String? = nil,
              keepBackground: Bool = true
          ) -> String {
              let r = remove.trimmingCharacters(in: .whitespacesAndNewlines)

              var parts: [String] = []
              parts.append("""
              Remove the following objects from the garden image: "\(r)".
              """)

              if keepBackground {
                  parts.append("Preserve the existing garden layout, plants, landscaping, and overall composition.")
              } else {
                  parts.append("You may adjust garden elements as needed.")
              }

              if let ctx = gardenContext, !ctx.isEmpty {
                  parts.append("Garden context: \(ctx). Do not replace or remove existing garden features.")
              }

              parts.append("""
              Fill the removed area naturally with appropriate garden elements like grass, plants, soil, or pathways.
              Make the removal look seamless and realistic, naturally blended into the surrounding landscape.
              High quality, natural realistic lighting, balanced composition. No people, no text or logos.
              """)

              parts.append("Avoid blurry areas, artifacts, or unnatural gaps. Ensure smooth transitions between filled areas and existing garden elements.")

              return parts.joined(separator: " ")
          }
    
    
    // MARK: - Replace object prompt
    
    static func buildObjectReplacementPrompt(
        replace: String,
        with replacement: String,
        gardenContext: String? = nil,
        keepBackground: Bool = true
    ) -> String {
        let r = replace.trimmingCharacters(in: .whitespacesAndNewlines)
        let w = replacement.trimmingCharacters(in: .whitespacesAndNewlines)

        var parts: [String] = []
        parts.append("""
        Replace the following objects in the garden image: "\(r)"
        with: "\(w)".
        """)

        if keepBackground {
            parts.append("Preserve the existing garden layout, plants, landscaping and overall composition.")
        } else {
            parts.append("You may adjust garden elements as needed.")
        }

        if let ctx = gardenContext, !ctx.isEmpty {
            parts.append("Garden context: \(ctx). Do not replace or remove existing garden features.")
        }

        parts.append("""
        Make the replacement look natural, realistic and seamlessly integrated into the garden landscape.
        Ensure proper scaling, natural shadows, and realistic lighting that matches the garden environment.
        High quality, natural realistic lighting, balanced composition. No people, no text or logos.
        """)

        parts.append("Avoid blurry results, mismatched shadows, floating objects, or harsh cutout edges. Blend naturally with surrounding plants and terrain.")

        return parts.joined(separator: " ")
    }
}
