//
//  DateConverter.swift
//  Eventos TI
//
//  Created by Rodrigo Amora on 22/05/24.
//

import Foundation

class DateConverter {
    class func convertToStringToDate(_ dateString: String) -> Date {
        let dateFormatter = ISO8601DateFormatter()
        return dateFormatter.date(from:dateString)!
    }
}
