//
//  AppTheme.swift
//  PV
//
//  Created by Jakob Stinnes on 26.10.23.
//

import Foundation
import SwiftUI

struct AppTheme {
    
    struct Fonts {
        static let title1 = Font.largeTitle
        static let title2 = Font.title2
        static let title3 = Font.title3
        static let headline = Font.headline
        static let subheadline = Font.subheadline
        static let body = Font.body
        static let commentAuthor = Font.subheadline.bold()
        static let commentContent = Font.body
        static let commentDate = Font.subheadline
    }
    
    struct Padding {
        static let standard: CGFloat = 10
        static let large: CGFloat = 30
        static let topLarge: CGFloat = 60
        static let bottomSmall: CGFloat = 5
    }
    
    struct Colors {
        static func background(for colorScheme: ColorScheme) -> Color {
            return Color(UIColor.systemBackground)
        }

        static func listBackground(for colorScheme: ColorScheme) -> Color {
            return Color(UIColor.systemBackground)
        }

        static func scrollViewBackground(for colorScheme: ColorScheme) -> Color {
            return Color(UIColor.systemBackground)
        }

        static func searchBarBackground(for colorScheme: ColorScheme) -> Color {
            return Color(UIColor.systemGray6)
        }

        static func shadowColor(for colorScheme: ColorScheme) -> Color {
            return colorScheme == .dark ? Color.white.opacity(0.05) : Color.black.opacity(0.07)
        }

        static func buttonBlue(for colorScheme: ColorScheme) -> Color {
            return Color.blue
        }
        static func textColor(for colorScheme: ColorScheme) -> Color {
                    return colorScheme == .dark ? Color.white : Color.primary
        }
        
        static let commentBackground = Color(.systemBackground)
        static let commentAuthorText = Color.blue
        static let commentContentText = Color.primary
        static let commentDateText = Color.gray
        static func commentShadow(for colorScheme: ColorScheme) -> Color {
            return colorScheme == .dark ? Color.white.opacity(0.05) : Color.black.opacity(0.07)
        }
        
    }

    struct Icons {
        static let logo = "logo"
        static let plus = "plus"
        static let phoneFill = "phone.fill"
        static let envelopeFill = "envelope.fill"
        static let arrowRightArrowLeftCircleFill = "arrow.right.arrow.left.circle.fill"

    }
    static func convertDate(from dateString: String) -> String? {
            let inputFormatter = DateFormatter()
            inputFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSxxx"
            inputFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            guard let date = inputFormatter.date(from: dateString) else { return nil }

            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = "dd.MM.yy, HH:mm 'Uhr'"

            return outputFormatter.string(from: date)
        }
}
