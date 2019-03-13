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

/// Enumerated type representing different mime-types.
public enum MIMEType: String {
    
    public typealias This = MIMEType
    
    /// JPEG mime-type.
    case JPEG = "image/jpeg"
    
    /// PNG mime-type.
    case PNG = "image/png"
    
    /// GIF mime-type.
    case GIF = "image/gif"
    
    /// TIFF mime-type.
    case TIFF = "image/tiff"
    
    /// PDF mime-type.
    case PDF = "application/pdf"
    
    /// VND mime-type.
    case VND = "application/vnd"
    
    /// Plain-text mime-type.
    case PlainText = "text/plain"
    
    /// Binary mime-type.
    case Binary = "application/octet-stream"
    
    /// Byte offset to mime-type map.
    public static var byteMap: [UInt8: This] = [
        0xFF: .JPEG,
        0x89: .PNG,
        0x47: .GIF,
        0x49: .TIFF,
        0x4D: .TIFF,
        0x25: .PDF,
        0xD0: .VND,
        0x46: .PlainText,
    ]
    
    /// Constucts a new mime type from a byte offset.
    public init(byteOffset: UInt8) {
        self = This.byteMap[byteOffset] ?? .Binary
    }
    
}
