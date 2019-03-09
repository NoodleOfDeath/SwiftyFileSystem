//
// The MIT License (MIT)
//
// Copyright © 2019 NoodleOfDeath. All rights reserved.
// NoodleOfDeath
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation

/// Data structure for data size units.
public struct DataSizeUnit {
    
    public typealias This = DataSizeUnit
    
    /// Enumerated type for different data size unit formats.
    public enum Format {
        case short
        case long
        case conventional
    }
    
    /// Unit for byte
    public static let Byte = This(byteCount: 10 ** 0, units: [.short: "B", .long: "bytes", .conventional: "bytes"])
    
    /// Unit for kilobyte (KB)
    public static let Kilobyte = This(byteCount: 10 ** 3, units: [.short: "KB", .long: "kilobytes", .conventional: "KB"])
    
    /// Unit for megabyte (MB)
    public static let Megabyte = This(byteCount: 10 ** 6, units: [.short: "MB", .long: "megabytes", .conventional: "MB"])
    
    /// Unit for gigabyte (GB)
    public static let Gigabyte = This(byteCount: 10 ** 9, units: [.short: "GB", .long: "gigabytes", .conventional: "GB"])
    
    /// Unit for terabyte (TB)
    public static let Terabyte = This(byteCount: 10 ** 12, units: [.short: "TB", .long: "terabytes", .conventional: "TB"])
    
    /// Unit for petabyte (PB)
    public static let Petabyte = This(byteCount: 10 ** 15, units: [.short: "PB", .long: "petabytes", .conventional: "PB"])
    
    /// All data size unit types in order of largest to smallest.
    public static let values: [This] = {
        return [
            .Byte,
            .Kilobyte,
            .Megabyte,
            .Gigabyte,
            .Terabyte,
            .Petabyte,
            ].reversed()
    }()
    
    /// Byte count of this data size unit.
    public let byteCount: UInt
    
    /// Unit strings of this data size unit.
    fileprivate let units: [Format: String]
    
    /// Constructs a new data unit type.
    ///
    /// - Parameters:
    ///     - byteCount: of this data size type.
    ///     - units: of this data size type.
    fileprivate init(byteCount: UInt, units: [Format: String]) {
        self.byteCount = byteCount
        self.units = units
    }
    
    /// Constructs a new data unit type.
    ///
    /// - Parameters:
    ///     - byteCount: of this data size type.
    ///     - units: of this data size type.
    fileprivate init(byteCount: Double, units: [Format: String]) {
        self.byteCount = UInt(byteCount)
        self.units = units
    }
    
    public static func ==(lhs: This, rhs: This) -> Bool {
        return lhs.byteCount == rhs.byteCount
    }
    
    public static func *(lhs: This, rhs: Double) -> Double {
        return Double(lhs.byteCount) * rhs
    }
    
    public static func *(lhs: Double, rhs: This) -> Double {
        return lhs * Double(rhs.byteCount)
    }
    
    public static func /(lhs: This, rhs: Double) -> Double {
        return Double(lhs.byteCount) / rhs
    }
    
    public static func /(lhs: Double, rhs: This) -> Double {
        return lhs / Double(rhs.byteCount)
    }
    
    /// Formats and returns a data size in bytes with a specified number
    /// of decimals and unit format.
    ///
    /// - Parameters:
    ///     - byteCount: data size in bytes to format.
    ///     - decimals: number of decmials to display. Default is `0`.
    ///
    /// - Parameters:
    ///     - format: to use to display units. Default is `.short`.
    public static func string(dataSize byteCount: UInt, decimals: Int = 0, format: Format = .conventional) -> String {
        var finalSize: Double = 0
        var units = Byte
        for unitType in values {
            if byteCount >= unitType.byteCount {
                finalSize = Double(byteCount / unitType.byteCount) +
                    (Double(byteCount % unitType.byteCount) / Double(unitType.byteCount))
                units = unitType
                break
            }
        }
        let decimals = units == Byte ? 0 : decimals
        return String(format: String(format: "%%.%ldf %%@", decimals), finalSize, units.units(for: format))
    }
    
    /// Returns the unit string for a given unit format.
    ///
    /// - Parameters:
    ///     - format: to use for the unit string.
    /// - Returns: unit string of this data size unit for the specified
    /// unit format.
    public func units(for format: Format) -> String {
        return units[format] ?? ""
    }
    
}

/// MARK: - FixedWidthInteger Extension
extension FixedWidthInteger {
    
    /// Formats and returns a data size in bytes with a specified number
    /// of decimals and unit format.
    ///
    /// - Parameters:
    ///     - decimals: number of decmials to display. Default is `0`.
    ///     - format: to use to display units. Default is `.short`.
    public func dataSizeString(decimals: Int = 0, format: DataSizeUnit.Format = .conventional) -> String {
        return DataSizeUnit.string(dataSize: UInt(self), decimals: decimals, format: format)
    }
    
}
