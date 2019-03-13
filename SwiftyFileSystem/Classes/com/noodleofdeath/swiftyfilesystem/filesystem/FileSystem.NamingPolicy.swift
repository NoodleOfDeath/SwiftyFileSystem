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

extension FileSystem {
    
    @available(*, unavailable, renamed: "NamingPolicy")
    public struct RenamingPolicy {}

    /// Simple data structure representing a renaming policy.
    public struct NamingPolicy {
        
        public typealias This = NamingPolicy
        
        public struct Option: OptionSet {
            
            public typealias RawValue = UInt
            
            public let rawValue: UInt
            
            public static let versionBeforeBasename = Option(1 << 0)
            public static let versionAfterExtension = Option(1 << 1)
            
            public static let versionDashed = Option(1 << 2)
            public static let versionInsideParentheses = Option(1 << 3)
            public static let versionInsideBraces = Option(1 << 4)
            public static let versionInsideBrackets = Option(1 << 5)
            
            public static let versionAsString = Option(1 << 6)
            
            public init(_ rawValue: RawValue) {
                self.rawValue = rawValue
            }
            
            public init(rawValue: RawValue) {
                self.rawValue = rawValue
            }
            
        }
        
        /// Automatic format policy.
        public static let automatic =
            This(options: [.versionDashed],
                 maxRenamingAttempts: 99)
        
        /// Input regular expression format of this renaming policy.
        public let inputFormat: String
        
        /// Output regular expression format of this renaming policy.
        public let outputFormat: String
        
        /// Options of this renaming policy.
        public let options: Option
        
        /// Number of times this policy allows the file system to rename
        /// a file before giving up.
        public let maxRenamingAttempts: Int
        
        // MARK: - Constructor Methods
        
        /// Constructs a new renaming policy instance set to `.automatic`.
        public init() {
            self = .automatic
        }
        
        @available(*, unavailable, renamed: "init(options:maxRenamingAttempts:)")
        public init(options: Option, maximumAllowedRenamingAttempts: Int = .max) {
            fatalError()
        }
        
        /// Constructs a new renaming policy with an initial format string.
        ///
        /// - Parameters:
        ///     - options: to use for this renaming policy.
        ///     - maxRenamingAttempts: number of times this policy
        /// allows the file system to rename a file before giving up.
        public init(options: Option, maxRenamingAttempts: Int = .max) {
            self.options = options
            inputFormat = "(\\w+)(?:\\.(\\w+))?$"
            var format = ""
            let versionTemplate = options.contains(.versionAsString) ? "%@" : "%d"
            if options.contains(.versionInsideParentheses) {
                format = String(format: "\\(%@\\)", versionTemplate)
            } else if options.contains(.versionInsideBraces) {
                format = String(format: "\\{%@\\}", versionTemplate)
            } else if options.contains(.versionInsideBrackets) {
                format = String(format: "\\[%@\\]", versionTemplate)
            } else {
                format = versionTemplate
            }
            if options.contains(.versionBeforeBasename) {
                if options.contains(.versionDashed) {
                    format = format + "-"
                }
                format = format + "$1\\.$2"
            } else if options.contains(.versionAfterExtension) {
                format = "$1\\.$2." + format
            } else {
                if options.contains(.versionDashed) {
                    format = "$1-" + format + "\\.$2"
                } else {
                    format = "$1" + format + "\\.$2"
                }
            }
            outputFormat = format
            self.maxRenamingAttempts = maxRenamingAttempts
        }
        
        // MARK: - Instance Methods
        
        @available(*, unavailable, renamed: "with(options:maxRenamingAttempts:)")
        public func with(options: Option, maximumAllowedRenamingAttempts: Int) -> This {
            fatalError()
        }
        
        /// Contructs and returns a new renaming policy from this existing
        /// policy.
        ///
        /// - Parameters:
        ///     - options: to use for this renaming policy. If not specified,
        /// this options of this renmaing policy will be used to construct the
        /// new renaming policy.
        ///     - maxRenamingAttempts: number of times the new policy
        /// allows the file system to rename a file before giving up.
        /// - Returns: a new renaming policy from this existing policy.
        public func with(options: Option? = nil, maxRenamingAttempts: Int) -> This {
            return This(options: options ?? self.options,
                        maxRenamingAttempts: maxRenamingAttempts)
        }
        
        /// Generates a newly formatted name from a basename and specified
        /// version number.
        ///
        /// - Parameters:
        ///     - path: of the item to rename.
        ///     - version: of the item to include in the generated name.
        ///     - condition: block of code that tells this policy to stop
        /// generating upon returning true.
        /// - Returns: A newly formatted name from a basename by replacing
        /// occurences of `inputFormat` in `basename` with `outputFormat` and
        /// using the resultant string as the string format, which takes a
        /// single numeric `CVarArg` argument representing the version number
        /// of the file.
        public func generateVersionedFilename(from path: String, version: Int = 0, while condition: (_ name: String) -> Bool) -> String {
            let basename = path.lastPathComponent
            let format =
                basename.replacingOccurrences(of: inputFormat,
                                              with: outputFormat,
                                              options: .regularExpression,
                                              range: basename.range)
            var version = version
            var n = 0
            var newName = path.deletingLastPathComponent +/ basename
            while !condition(newName) && n < maxRenamingAttempts {
                version += 1
                n += 1
                newName = path.deletingLastPathComponent +/ String(format: format, version)
            }
            return newName
        }
        
        /// Generates a newly formatted name from a basename and specified
        /// version number.
        ///
        /// - Parameters:
        ///     - url: of the item to rename.
        ///     - version: of the item to include in the generated name.
        ///     - condition: block of code that tells this policy to stop
        /// generating upon returning true.
        /// - Returns: A newly formatted name from a basename by replacing
        /// occurences of `inputFormat` in `basename` with `outputFormat` and
        /// using the resultant string as the string format, which takes a
        /// single numeric `CVarArg` argument representing the version number
        /// of the file.
        public func generateVersionedURL(from url: URL, version: Int = 0, while condition: (_ name: URL) -> Bool) -> URL {
            let basename = url.lastPathComponent
            let format =
                basename.replacingOccurrences(of: inputFormat,
                                              with: outputFormat,
                                              options: .regularExpression,
                                              range: basename.range)
            var version = version
            var n = 0
            var newURL = url.deletingLastPathComponent() +/ basename
            while !condition(newURL) && n < maxRenamingAttempts {
                version += 1
                n += 1
                newURL = url.deletingLastPathComponent() +/ String(format: format, version)
            }
            return newURL
        }
        
    }

}
