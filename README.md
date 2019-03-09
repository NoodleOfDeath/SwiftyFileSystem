# SwiftyFileSystem

[![CI Status](https://img.shields.io/travis/NoodleOfDeath/SwiftyFileSystem.svg?style=flat)](https://travis-ci.org/NoodleOfDeath/SwiftyFileSystem)
[![Version](https://img.shields.io/cocoapods/v/SwiftyFileSystem.svg?style=flat)](https://cocoapods.org/pods/SwiftyFileSystem)
[![License](https://img.shields.io/cocoapods/l/SwiftyFileSystem.svg?style=flat)](https://cocoapods.org/pods/SwiftyFileSystem)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyFileSystem.svg?style=flat)](https://cocoapods.org/pods/SwiftyFileSystem)

SwiftyFileSystem is a lightweight wrapper framework around the Swift `FileManager` class with several `URL` extensions, built-in renaming policies when moving and copying files, common directory path/url generation methods, and file size string formatting.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SwiftyFileSystem is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftyFileSystem'
```

## Usage

### URL Extensions

```swift
import SwiftyFileSystem

// Alias constructor for URL(fileURLWithPath: "path/to/myfile")
let url = "path/to/myfile".fileURL

// URL resource properties
print(url.fileExists) // prints `true` or `false`
print(url.isLocal) // prints `true` if the file resides on the local machine
print(url.isUbiquitous) // prints `true` if the file is managed and synced the cloud
print(url.isRegularFile) // prints `true` if the file is regular file
print(url.isDirectory) // prints `true` if the file is a directory
print(url.isSymblicLink) // prints `true` if the file is a symbolic link
print(url.isInferredHidden) // prints `true` if the filename begins wit a "." or "~" character
print(url.isHidden) // prints `true` if the file hidden by default from the user
print(url.fileSize) // prints the size of this file in bytes, if it is a regular file
print(url.sizeOfContents) // prints the recurively summated size of a directory's contents
print(url.fileCount) // prints the number of files contained in a directory
print(url.creationDate) // prints the creation date of this file
print(url.contentAcccessDate) // prints the content access date of this file
print(url.modificationDate) // prints the most recent modification date of this file
```

See [Data Size Formatting](#data-size-formatting) for displaying file sizes as formatted strings.

### Simple FileManager Methods

```swift
import SwiftyFileSystem

// FileSystem.mainResourcePath is an alias for `Bundle.main.resourcePath`
print(FileSystem.fileExists(FileSystem.mainResourcePath)) // prints "true"

// Enumerates and prints the file contents of a directory.
for file in FileSystem.contentsOfDirectory(at: FileSystem.mainResourcePath) {
    print(file)
}

// Copy a file from one url to another, and increment the name if the 
// destination file already exists using a renaming policy that puts the 
// version number after the file extension prefixed with a dash and 
// bounded by parentheses.
let src = "path/to/my-file".fileURL
let dst = URL(fileURLWithPath)
FileSystem.copyItem(at: src, to: dst, 
                    with: RenamingPolicy(options: [.versionAfterExtension, .versionDashed, ,versionInsideParentheses], 
                                         maximumAllowedRenamingAttempts: 10)
```

### Data Size Formatting

```swift
import SwiftyFileSystem

// prints file size like "##.## MB" or "##.## GB" etc."
print("path/to/myfile".fileURL.fileSize.dataSizeString(decimals: 2, format: .short))
```

## Author

NoodleOfDeath, git@noodleofdeath.com

## License

SwiftyFileSystem is available under the MIT license. See the LICENSE file for more info.
