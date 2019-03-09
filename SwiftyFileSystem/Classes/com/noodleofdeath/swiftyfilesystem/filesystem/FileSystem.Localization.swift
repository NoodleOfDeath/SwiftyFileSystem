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

extension FileSystem {
    
    /// Bundle that contains resources accessed by this class.
    public static var bundle: Bundle? = {
        guard let path = Bundle(for: FileSystem.self).path(forResource: "SwiftyFileSystem", ofType: "bundle") else { return nil }
        return Bundle(path: path)
    }()
    
    /// Retrieves and formats a localized string for a given key and with
    /// specified arguments.
    ///
    /// - Parameters:
    ///     - key: of the localized string to retrieve.
    ///     - arg1: to pass into the string when it is formatted.
    ///     - arg2: to pass into the string when it is formatted.
    open class func localizedString(_ key: String, with arg1: CVarArg? = nil, _ arg2: CVarArg? = nil) -> String {
        guard let bundle = bundle else { return key }
        let formattedString = NSLocalizedString(key, bundle: bundle, comment: "")
        if let arg1 = arg1 {
            if let arg2 = arg2 {
                return String.localizedStringWithFormat(formattedString, arg1, arg2)
            }
            return String.localizedStringWithFormat(formattedString, arg1)
        }
        return formattedString
    }
    
}
