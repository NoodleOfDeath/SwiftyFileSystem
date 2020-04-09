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

import AVFoundation
import CoreServices

import SwiftyUTType

#if os(iOS)

import UIKit

/// A complex extension of `UIDocument` that provides convenience methods for
/// accessing/modifying the contents and attributes of a document.
@objc(Document)
open class Document: UIDocument {
    
    public static var textEncodingDidChangeNotification = Notification.Name(rawValue: "textEncodingDidChangeNotification")
    
    /// Template provider of this document.
    
    /// Folder that contains this document.
    open var parentDirectoryURL: URL { return fileURL.deletingLastPathComponent() }
    
    ///
    fileprivate var _destinationURL: URL?
    
    /// Destination URL if this document is a symbolic link.
    open var destinationURL: URL? {
        get { return _destinationURL ?? originalFileURL.destinationURL }
        set { _destinationURL = newValue }
    }

    /// Original fileURL of this document if it was a symbolic link.
    public let originalFileURL: URL
    
    /// Remote location of this document if it is located on a remote client.
    open var remoteURL: URL?
    
    /// Filename of this document
    open var filename: String { return fileURL.lastPathComponent }
    
    /// Display name of this document.
    open lazy var displayName: String = { return filename }()
    
    fileprivate var _resourceType: URLFileResourceType = .unknown
    
    /// Resource type of this document.
    open var resourceType: URLFileResourceType {
        get {
            if _resourceType == .unknown {
                _resourceType = fileURL.resourceType
            }
            return _resourceType
        }
        set {
            if _resourceType != .unknown {
                print("WARNING: Resource type has already been " +
                    "detected. Changing resource type of an existing " +
                    "resource can cause unpredictable behavior.")
            }
            _resourceType = newValue
        }
    }
    
    /// Underlying resource which will return the destination document
    /// of this document if, and only if, it is a symbolic link.
    open var absoluteResource: Document {
        guard resourceType == .symbolicLink, let destinationURL = destinationURL else { return self }
        return Document(fileURL: destinationURL)
    }
    
    /// The mime type of this document.
    open var mimeType: MIMEType {
        guard let contents = contents, contents.count > 0 else { return .Binary }
        return .Binary
    }
    
    /// Underlying contents of this document if, and only if, it is not a directory.
    fileprivate var rawContents: Data?
    
    /// Contents of this document if, and only if, it is not a directory.
    open var contents: Data? {
        get {
            guard resourceType == .regular, documentState != .closed else {
                print("WARNING: Attempting to access document contents before opening. Make sure to run `this.open()` before trying to read the contents of this document, otherwise this getter will always return `nil`.")
                return nil
            }
            return rawContents
        }
        set {
            // If contents are unchanged, ignore any updates.
            if rawContents == newValue { return }
            rawContents = newValue
            updateChangeCount(.done)
        }
    }
    
    /// The text encoding of this document. Default is `utf8`.
    open var textEncoding: String.Encoding = .utf8 {
        didSet {
            guard textEncoding != oldValue else { return }
            NotificationCenter.default.post(name: Document.textEncodingDidChangeNotification,
                                            object: self)
        }
    }
    
    /// Contents of this document as encoded text.
    open var textContents: String? {
        get {
            guard let contents = contents else { return nil }
            return String(data: contents, encoding: textEncoding)
        }
        set {
            guard let newValue = newValue else { contents = nil; return }
            contents = Data(bytes: newValue, count: newValue.lengthOfBytes(using: textEncoding))
        }
    }
    
    /// `true` if, and only if, a resource physically exists at `fileURL`.
    open var fileExists: Bool { return originalFileURL.fileExists }
    
    /// `true` if, and only if, this document is a local document resource.
    open var isLocal: Bool { return originalFileURL.isLocal }
    
    /// `true` if this item is synced to the cloud, `false` if it is only a
    /// local file.
    open var isUbiquitous: Bool { return originalFileURL.isUbiquitous }
    
    /// `true` if, and only if, this document is a regular file, or symbolic link to a regular file.
   open var isRegularFile: Bool { return originalFileURL.isRegularFile }
    
    /// `true` if, and only if, this document is a directory, or symbolic link to a directory.
    open var isDirectory: Bool { return originalFileURL.isDirectory }
    
    /// `true` if, and only if, this document is a symbolic link.
    open var isSymbolicLink: Bool { return originalFileURL.isSymbolicLink }
    
    /// `true` if, and only if, the filename of this document begins with `.` or `~`.
    open var isInferredHidden: Bool { return originalFileURL.isInferredHidden }
    
    /// `true` for resources normally not displayed to users.
    open var isHidden: Bool { return originalFileURL.isHidden }
    
    /// Returns `true` if this document is hidden, using a specified
    /// `includeInferred` flag to allow documents prefixed with `.` or `~`,
    /// to be considered hidden.
    ///
    /// - Parameters:
    ///     - includeInferred: if `true` is passed, documents prefixed
    /// with `.` or `~` will be considered hidden. Default is `true`.
    ///
    /// - Parameters:
    /// - Returns: `true` if this document is hidden, using a specified
    /// `includeInferred` flag to allow documents prefixed with `.` or `~`,
    /// to be considered hidden.
    open func isHidden(includeInferred: Bool = true) -> Bool {
        return fileURL.isHidden(includeInferred: includeInferred)
    }
    
    /// The file size of this document if, and only if, it is not a directory.
    open var fileSize: Int { return originalFileURL.fileSize }
    
    /// Synchronously calculates the recursive size of all contents contained
    /// in this resource if it is a directroy, or returns a file size if this
    /// resource is a regular file.
    open var sizeOfContents: Int { return originalFileURL.sizeOfContents }
    
    /// Attempts to asynchronously calculate the size of all resources contained
    /// in this file if it is a directory and callack a specified completion
    /// block when finished.
    ///
    /// - Parameters:
    ///     - completionHandler: block to run when the calculation is complete.
    public func sizeOfContents(completionHandler: @escaping (Int) -> ()) {
        originalFileURL.sizeOfContents(completionHandler: completionHandler)
    }
    
    /// Number of files contained in this resource, if, and only if, it is a
    /// directory.
    open var fileCount: Int { return fileCount() }
    
    /// Returns the number of files contained in this resource, if, and only
    /// if, it is a directory and using specified resource keys and enumerating
    /// options.
    ///
    /// - Parameters:
    ///     - resourceKeys: to use when enumerating the contents of this
    /// directory.
    ///     - options: to use when enumerating the contents of this
    /// directory.
    /// - Returns: the number of files contained in this resource, if,
    /// and only if, it is a directory and using specified resource keys and
    /// enumerating options.
    public func fileCount(includingPropertiesForKeys resourceKeys: [URLResourceKey] = [], options: FileManager.DirectoryEnumerationOptions = [.skipsSubdirectoryDescendants]) -> Int {
        return originalFileURL.fileCount(includingPropertiesForKeys: resourceKeys, options: options)
    }
    
    /// Date this resource was created or `distantFuture` if unobtainable.
    open var creationDate: Date { return originalFileURL.creationDate }
    
    /// Date this resource was last accessed or `distantFuture` if unobtainable.
    open var contentAccessDate: Date { return originalFileURL.contentAccessDate }
    
    /// Date this resource was last modified choosing the most recent between
    /// `attributeModificationDate` and `contentModificationDate` or
    /// `distantFuture` if unobtainable.
    open var modificationDate: Date { return originalFileURL.modificationDate }
    
    /// Date the the attributes of this resource were last modified.
    open var attributeModificationDate: Date { return originalFileURL.attributeModificationDate }
    
    /// Date the the contents of this resource were last modified.
    open var contentModificationDate: Date { return originalFileURL.contentModificationDate }
    
    // MARK: - Constructor Methods
    
    override required public init(fileURL: URL) {
        self.originalFileURL = fileURL
        super.init(fileURL: fileURL)
    }
    
    ///
    public static func newRegularFileAt(fileURL: URL, contents: String? = nil) -> Document? {
        return nil
    }
    
    ///
    public static func newDirectoryAt(fileURL: URL, withIntermediateDirectories: Bool = false, attributes: [FileAttributeKey: Any]? = nil) -> Document? {
        guard FileSystem.createDirectory(at: fileURL, withIntermediateDirectories: withIntermediateDirectories, attributes: attributes) else { return nil }
        return Document(fileURL: fileURL)
    }
    
    ///
    public static func newSymbolicLinkAt(fileURL: URL, destinationURL: URL) -> Document? {
        guard FileSystem.createSymbolicLink(at: fileURL, withDestinationURL: destinationURL) else { return nil }
        return Document(fileURL: fileURL)
    }
    
    // MARK: - UIDocument Methods
    
    override open func contents(forType typeName: String) throws -> Any {
        guard let contents = self.contents else { return Data() }
        return contents
    }
    
    override open func load(fromContents contents: Any, ofType typeName: String?) throws {
        guard let contents = contents as? Data else { return }
        self.contents = contents
    }
    
    /// Shorthand for `save(to: fileURL)`.
    open func save(for saveOperation: UIDocument.SaveOperation = .forCreating,
                   completionHandler: ((Bool) -> ())? = nil) {
        save(to: originalFileURL, for: saveOperation, completionHandler: completionHandler)
    }
    
    override open func save(to fileURL: URL, 
                            for saveOperation: UIDocument.SaveOperation = .forCreating,
                            completionHandler: ((Bool) -> ())? = nil) {
        
        var success = false
        
        switch resourceType {
            
        case .regular:

            if !fileExists && saveOperation == .forCreating {
            
                var lines = [String]()
                switch uttype {
            
                case .JSON:
                    lines = ["{", "}"]
                    break
            
                case .PropertyList:
                    lines =
                        [
                            "<?xml version=\"1.0\" encoding=\"UTF-8\"?>",
                            "<!DOCTYPE plist PUBLIC \"-//Apple Computer//DTD PLIST ",
                            "1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">",
                            "<plist version=\"1.0\">",
                            "<dict/>",
                            "</plist>",
                        ]
                    break
            
                default:
                    break
                }
            
                textContents = lines.joined(separator: "\n")
            
            }
            
            super.save(to: fileURL, for: saveOperation, completionHandler: completionHandler)
            return
            
        case .directory:
            success = FileSystem.createDirectory(at: fileURL, withIntermediateDirectories: true, attributes: [:])
            break
            
        case .symbolicLink:
            guard let destinationURL = destinationURL else {
                completionHandler?(false)
                return
            }
            success = FileSystem.createSymbolicLink(at: fileURL, withDestinationURL: destinationURL)
            break
            
        default:
            break
            
        }
        
        completionHandler?(success)
        
    }
    
}

// MARK: - UTTypePathExtensionProtocol Methods
extension Document: UTTypePathExtensionProtocol {
    
    open var pathExtension: String { return fileURL.pathExtension }
    
}

extension Document: UTTypeProtocol {
    
    open var uttype: UTType { return uttypeFromPathExtension }
    
}

// MARK: - Instance Methods
extension Document {
    
    /// Returns a thumbnail of this document scaled and cropped to specified
    /// size. The resource type must conform to `UTType.Image`, `UTType.Video`,
    /// or `UTType.Movie` for this to generate a thumbail.
    ///
    /// - Parameters:
    ///     - size: Size to scale and crop a thumbnail of this document
    /// to.
    /// - Returns: A thumbnail of this document scaled and cropped to `size`.
    open func thumbnail(with dimensions: CGSize, maxFileSize: Int = .max) -> UIImage? {
        
        guard fileSize < maxFileSize else { return nil }
        
        switch uttype {
            
        case _ where uttype.conforms(to: .Image):
            return UIImage(contentsOfFile: originalFileURL.path)?.scalingAndCropping(to: dimensions)
            
        case _ where uttype.conforms(to: .Video, .Movie):
            let asset = AVURLAsset(url: originalFileURL)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            guard let cgImage = try? imgGenerator.copyCGImage(at: CMTimeMake(value: Int64(asset.duration.seconds / 2), timescale: 1), actualTime: nil) else { return nil }
            return UIImage(cgImage: cgImage)
            
        default:
            return nil
            
        }
        
    }
    
}

#endif
