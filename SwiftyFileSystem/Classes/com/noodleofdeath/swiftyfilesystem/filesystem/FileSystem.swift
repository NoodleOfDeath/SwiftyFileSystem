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

/// SwiftyFileSystem Object.
open class FileSystem {
    
    public typealias This = FileSystem
    
    /// URL to the resource path of this application.
    open class var mainResourcePath: String { return Bundle.main.resourcePath! }
    
    /// Path to the resource path of this application.
    open class var documentPath: String? { return NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first }
    
    /// URL to the ubiquity directory of this application.
    open class var ubiquityURL: URL? { return FileManager.default.url(forUbiquityContainerIdentifier: nil) }
    
    /// Returns the ubiquity URL for the specified container identifer.
    ///
    /// - Parameters:
    ///     - identifier: of the container to get the ubiquity URL for.
    open class func ubiquityURL(for identifier: String) -> URL? {
        return FileManager.default.url(forUbiquityContainerIdentifier: identifier)
    }
    
    /// Path to the ubiquity directory of this application.
    open class var ubiquityPath: String? { return ubiquityURL?.path }
    
    /// Returns the ubiquity URL for the specified container identifer.
    ///
    /// - Parameters:
    ///     - identifier: of the container to get the ubiquity URL for.
    open class func ubiquityPath(for identifier: String) -> String? {
        return FileManager.default.url(forUbiquityContainerIdentifier: identifier)?.path
    }
    
    /// URL to the cloud documents of this application.
    open class var cloudDocsURL: URL? { return ubiquityURL +/ "Documents" }
    
    /// Path to the cloud documents of this application.
    open class var cloudDocsPath: String? { return cloudDocsURL?.path }
    
    /// Path to the inbox document directory of this application.
    open class var inboxDocPath: String? { return documentPath +/ "Inbox" }
    /// Path to the user documents directory of this application.
    
    /// Path to the "temp" directory of this application.
    open class var tmpFilesPath: String { return NSTemporaryDirectory() }
    
    /// Path to the application support path of this application.
    open class var appSupportPath: String? { return NSSearchPathForDirectoriesInDomains(.applicationSupportDirectory, .userDomainMask, true).first }
    
    /// Returns `true` if a file exists at `path`; `false`, otherwise.
    /// Shorthand for `FileManager.default.fileExists(atPath:)`.
    ///
    /// - Parameters:
    ///     - path: to check for an existing file.
    /// - Returns: `true` if a file exists at `path`; `false`, otherwise.
    open class func fileExists(atPath path: String) -> Bool {
        return FileManager.default.fileExists(atPath: path)
    }
    
    /// Returns `true` if a file exists at `url`; `false`, otherwise.
    ///
    /// - Parameters:
    ///     - url: to check for an existing file.
    /// - Returns: `true` if a file exists at `url`; `false`, otherwise.
    open class func fileExists(at url: URL) -> Bool {
        do {
            return try url.checkResourceIsReachable()
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    /// Creates a directory at a specified path, with a boolean flag indicating,
    /// whether or not to create intermediate directories, and a set of initial,
    /// file attributes.
    ///
    /// - Parameters:
    ///     - path: to create a directory at.
    ///     - createIntermediates: specify `true` to create intermediate
    /// directories; `false`, otherwise.
    ///     - attributes: to apply to the newly created directory.
    /// - Returns: `true` if the operation was successful; `false`, otherwise.
    @discardableResult
    open class func createDirectory(atPath path: String, withIntermediateDirectories createIntermediates: Bool = true, attributes: [FileAttributeKey : Any]? = nil) -> Bool {
        do {
            try FileManager.default
                .createDirectory(atPath: path,
                                 withIntermediateDirectories: createIntermediates,
                                 attributes: attributes)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    /// Creates a directory at a specified url, with a boolean flag indicating,
    /// whether or not to create intermediate directories, and a set of initial,
    /// file attributes.
    ///
    /// - Parameters:
    ///     - url: to create a directory at.
    ///     - createIntermediates: specify `true` to create intermediate
    /// directories; `false`, otherwise.
    ///     - attributes: to apply to the newly created directory.
    /// - Returns: `true` if the operation was successful; `false`, otherwise.
    @discardableResult
    open class func createDirectory(at url: URL, withIntermediateDirectories createIntermediates: Bool = true, attributes: [FileAttributeKey : Any]? = nil) -> Bool {
        do {
            try FileManager.default.createDirectory(at: url, withIntermediateDirectories: createIntermediates, attributes: attributes)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    /// Returns the destination of a symbolic link located at a specified path.
    ///
    /// - Parameters:
    ///     - path: of the symbolic link to get the destination of.
    /// - Returns: destination of the symbolic link located at `path`, or `nil`,
    /// if an error occurs.
    open class func destinationOfSymbolicLink(atPath path: String) -> String? {
        do {
            return try FileManager.default.destinationOfSymbolicLink(atPath: path)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// Creates a symbolic link at the specified url that points to a specifed
    /// destination url.
    ///
    /// - Parameters:
    ///     - url: at which to create a symbolic link.
    ///     - destinationURL: to assign to the symbolic link.
    /// - Returns: `true` if the operation was successful; `false`, otherwise.
    @discardableResult
    open class func createSymbolicLink(at url: URL, withDestinationURL destinationURL: URL) -> Bool {
        do {
            try FileManager.default.createSymbolicLink(at: url, withDestinationURL: destinationURL)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }

    /// Creates a symbolic link at the specified url that points to a specifed
    /// destination url.
    ///
    /// - Parameters:
    ///     - url: at which to create a symbolic link.
    ///     - destinationPath: to assign to the symbolic link.
    /// - Returns: `true` if the operation was successful; `false`, otherwise.
    @discardableResult
    open class func createSymbolicLink(at url: URL, withDestinationPath destinationPath: String) -> Bool {
        guard let dst = URL(string: destinationPath, relativeTo: url) else { return false }
        return createSymbolicLink(at: url, withDestinationURL: dst)
    }

    /// Creates a symbolic link at the specified path that points to a specifed
    /// destination path.
    ///
    /// - Parameters:
    ///     - src: path at which to create a symbolic link.
    ///     - dst: path to assign to the symbolic link.
    /// - Returns: `true` if the operation was successful; `false`, otherwise.
    @discardableResult
    open class func createSymbolicLink(atPath src: String, withDestinationPath dst: String) -> Bool {
        if dst.starts(with: ".."), let dst = URL(string: dst, relativeTo: src.fileURL)?.absoluteURL {
            return createSymbolicLink(at: src.fileURL, withDestinationURL: dst)
        }
        do {
            try FileManager.default.createSymbolicLink(atPath: src, withDestinationPath: dst)
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
    
    /// Returns the contents of a directory at a specified path.
    ///
    /// - Parameters:
    ///     - path: of the directory to fetch the contents of.
    /// - Returns: a collection of the filenames of each item in the directory
    /// specified by `path`; an empty collection will be returned if the
    /// operation fails.
    open class func contentsOfDirectory(atPath path: String) -> [String] {
        do {
            return try FileManager.default.contentsOfDirectory(atPath: path)
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    /// Returns the contents of a directory at a specified path.
    ///
    /// - Parameters:
    ///     - url: of the directory to fetch the contents of.
    ///     - resourceKeys: of the directory to fetch the contents of.
    ///     - parameter options:
    /// - Returns: a collection of the filenames of each item in the directory
    /// specified by `path`; an empty collection will be returned if the
    /// operation fails.
    open class func contentsOfDirectory(at url: URL, includingPropertiesForKeys resourceKeys: [URLResourceKey] = [], options: FileManager.DirectoryEnumerationOptions = []) -> [URL] {
        do {
            return (try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: resourceKeys, options: options)).filter { !$0.isSymbolicLink || !options.contains(.skipsSymbolicLinks) }
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    /// Removes an item at the specifed path without throwing
    /// an error, but instead returning `true` if the item was removed
    /// successfully; `false`, otherwise.
    ///
    /// - Parameters:
    ///     - path: of the item to remove.
    /// - Returns: `true` if the item was removed successfully; `false`,
    /// otherwise.
    @discardableResult
    open class func removeItem(atPath path: String) -> Bool {
        do {
            try FileManager.default.removeItem(atPath: path)
            return true
        } catch {
            return false
        }
    }
    
    /// Removes an item at the specifed destination URL without throwing
    /// an error, but instead returning `true` if the item was removed
    /// successfully; `false`, otherwise.
    ///
    /// - Parameters:
    ///     - url: of the item to remove.
    /// - Returns: `true` if the item was removed successfully; `false`,
    /// otherwise.
    @discardableResult
    open class func removeItem(at url: URL) -> Bool {
        do {
            try FileManager.default.removeItem(at: url)
            return true
        } catch {
            return false
        }
    }
    
    /// Moves an item at a source path to a destination path using a specified
    /// renaming format if the destination file already exists.
    ///
    /// - Parameters:
    ///     - src: path to move from.
    ///     - dst: path to move to.
    ///     - policy: to use if the use
    /// - Returns: The path of the item that was moved, or `nil` if the
    /// operation fails.
    @discardableResult
    open class func moveItem(atPath src: String, toPath dst: String, with policy: NamingPolicy = .automatic) -> String? {
        let dst = dst.fileURL.isDirectory ? dst +/ src.lastPathComponent : dst
        let path = policy.generateVersionedFilename(from: dst) { !fileExists(atPath: $0) }
        do {
            try FileManager.default.moveItem(atPath: src, toPath: path)
            return path
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// Moves an item at a source URL to a destination URL using a specified
    /// renaming format if the destination file already exists.
    ///
    /// - Parameters:
    ///     - srcURL: url to move from.
    ///     - dstURL: url to move to.
    ///     - policy: to use if the use
    /// - Returns: The url of the item that was moved, or `nil` if the
    /// operation fails.
    @discardableResult
    open class func moveItem(at srcURL: URL, to dstURL: URL, with policy: NamingPolicy = .automatic) -> URL? {
        let dstURL = dstURL.isDirectory ? dstURL +/ srcURL.lastPathComponent : dstURL
        let url = policy.generateVersionedURL(from: dstURL) { !$0.fileExists }
        do {
            try FileManager.default.moveItem(at: srcURL, to: url)
            return url
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// Copies an item at a source path to a destination path using a specified
    /// renaming format if the destination file already exists.
    ///
    /// - Parameters:
    ///     - src: path to copy from.
    ///     - dst: path to copy to.
    ///     - policy: to use if the use
    /// - Returns: The path of the item that was copied, or `nil` if the
    /// operation fails.
    @discardableResult
    open class func copyItem(atPath src: String, toPath dst: String, with policy: NamingPolicy = .automatic) -> String? {
        let dst = dst.fileURL.isDirectory ? dst +/ src.lastPathComponent : dst
        let path = policy.generateVersionedFilename(from: dst) { !fileExists(atPath: $0) }
        do {
            try FileManager.default.copyItem(atPath: src, toPath: path)
            return path
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// Copies an item at a source URL to a destination URL using a specified
    /// renaming format if the destination file already exists.
    ///
    /// - Parameters:
    ///     - srcURL: url to copy from.
    ///     - dstURL: url to copy to.
    ///     - policy: to use if the use
    /// - Returns: The url of the item that was copied, or `nil` if the
    /// operation fails.
    @discardableResult
    open class func copyItem(at srcURL: URL, to dstURL: URL, with policy: NamingPolicy = .automatic) -> URL? {
        let dstURL = dstURL.isDirectory ? dstURL +/ srcURL.lastPathComponent : dstURL
        let url = policy.generateVersionedURL(from: dstURL) { !$0.fileExists }
        do {
            try FileManager.default.copyItem(at: srcURL, to: url)
            return url
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
}
