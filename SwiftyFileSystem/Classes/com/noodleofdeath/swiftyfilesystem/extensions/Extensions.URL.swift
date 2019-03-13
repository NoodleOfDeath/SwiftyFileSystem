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

extension URL {
    
    /// Resource type of this URL. Returns `unknown` if unattainable.
    public var resourceType: URLFileResourceType {
        return ((try? resourceValues(forKeys: [.fileResourceTypeKey]))?.fileResourceType) ?? .unknown
    }
    
    /// `true` if, and only if, a resource physically exists at `fileURL`.
    public var fileExists: Bool {
        return (try? checkResourceIsReachable()) ?? false
    }
    
    /// `true` if, and only if, this resource is a local resource.
    public var isLocal: Bool {
        return path.contains(FileSystem.documentPath)
    }
    
    /// `true` if this item is synced to the cloud, `false` if it is only a
    /// local file.
    public var isUbiquitous: Bool {
        if let isUbitquitous = ((try? resourceValues(forKeys: [.isUbiquitousItemKey]))?.isUbiquitousItem) { return isUbitquitous }
        guard let ubiquityPath = FileSystem.ubiquityPath else { return false }
        return path.contains(ubiquityPath)
    }
    
    /// `true` if, and only if, this resource is a regular file, or symbolic link to a regular file.
    public var isRegularFile: Bool {
        return ((try? resourceValues(forKeys: [.isRegularFileKey]))?.isRegularFile) ?? false
    }
    
    /// `true` if, and only if, this resource is a directory, or symbolic link to a directory.
    public var isDirectory: Bool {
        return ((try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory) ?? false
    }
    
    /// `true` if, and only if, this resource is a symbolic link.
    public var isSymbolicLink: Bool {
        return ((try? resourceValues(forKeys: [.isSymbolicLinkKey]))?.isSymbolicLink) ?? false
    }
    
    /// `true` if, and only if, the filename of this resource begins with `.` or `~`.
    public var isInferredHidden: Bool {
        return [".", "~"].contains(lastPathComponent.firstCharacter)
    }
    
    /// `true` for resources normally not displayed to users.
    public var isHidden: Bool {
        return ((try? resourceValues(forKeys: [.isHiddenKey]))?.isHidden) ?? false
    }
    
    /// Returns `true` if this resource is hidden, using a specified
    /// `includeInferred` flag to allow documents prefixed with `.` or `~`,
    /// to be considered hidden.
    ///
    /// - Parameters:
    ///     - includeInferred: if `true` is passed, documents prefixed
    /// with `.` or `~` will be considered hidden. Default is `true`.
    ///
    /// - Parameters:
    /// - Returns: `true` if this resource is hidden, using a specified
    /// `includeInferred` flag to allow documents prefixed with `.` or `~`,
    /// to be considered hidden.
    public func isHidden(includeInferred: Bool = true) -> Bool {
        return isHidden && (!includeInferred || (includeInferred && isInferredHidden))
    }
    
    /// The file size of this resource, if, and only if, it is not a directory.
    public var fileSize: Int {
        return ((try? resourceValues(forKeys: [.fileSizeKey]))?.fileSize) ?? -1
    }
    
    /// Synchronously calculates the recursive size of all contents contained
    /// in this resource if it is a directroy, or returns a file size if this
    /// resource is a regular file.
    public var sizeOfContents: Int {
        guard isDirectory else { return fileSize }
        var size = 0
        FileSystem.contentsOfDirectory(at: self).forEach {
            size += $0.sizeOfContents
        }
        return size
    }
    
    /// Attempts to asynchronously calculate the size of all resources contained
    /// in this file if it is a directory and callback a specified completion
    /// block when finished.
    ///
    /// - Parameters:
    ///     - completionHandler: block to run when the calculation is complete.
    public func sizeOfContents(completionHandler: @escaping (Int) -> ()) {
        guard isDirectory else {
            completionHandler(fileSize)
            return
        }
        DispatchQueue.global().async {
            var size = 0
            FileSystem.contentsOfDirectory(at: self).forEach {
                size += $0.sizeOfContents
            }
            DispatchQueue.main.async {
                completionHandler(size)
            }
        }
    }
    
    /// Number of files contained in this resource, if, and only if, it is a
    /// directory.
    public var fileCount: Int { return fileCount() }
    
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
        guard isDirectory else { return 0 }
        return FileSystem
            .contentsOfDirectory(at: self,
                                 includingPropertiesForKeys: resourceKeys,
                                 options: options).count
    }
    
    /// Date this resource was created or `distantFuture` if unobtainable.
    public var creationDate: Date {
        return ((try? resourceValues(forKeys:
            [.creationDateKey]))?.creationDate) ?? .distantFuture
    }
    
    /// Date this resource was last accessed or `distantFuture` if unobtainable.
    public var contentAccessDate: Date {
        return ((try? resourceValues(forKeys:
            [.contentAccessDateKey]))?.contentAccessDate) ?? .distantFuture
    }
    
    /// Date this resource was last modified choosing the most recent
    /// between `attributeModificationDate` and `contentModificationDate` or
    /// `distantFuture` if unobtainable.
    public var modificationDate: Date {
        return attributeModificationDate > contentModificationDate ?
            attributeModificationDate : contentModificationDate
    }
    
    /// Date the the attributes of this resource were last modified.
    public var attributeModificationDate: Date {
        return ((try? resourceValues(forKeys:
            [.attributeModificationDateKey]))?.attributeModificationDate) ??
            .distantFuture
    }
    
    /// Date the the contents of this resource were last modified.
    public var contentModificationDate: Date {
        return ((try? resourceValues(forKeys:
            [.contentModificationDateKey]))?.contentModificationDate) ??
            .distantFuture
    }
    
}
