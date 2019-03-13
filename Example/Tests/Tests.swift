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

import XCTest
import SwiftyFileSystem

/// A non-comprehensive unit test.
class Tests: XCTestCase {
    
    func testPrint() {
        
        guard let testDirectory = (Bundle(for: type(of: self)).resourcePath +/ "TestFiles")?.fileURL
            else { XCTFail("Unable to load test files directory."); return }
        
        print(testDirectory.fileExists)
        print(testDirectory.isLocal)
        print(testDirectory.isUbiquitous)
        print(testDirectory.isRegularFile)
        print(testDirectory.isDirectory)
        print(testDirectory.isSymbolicLink)
        print(testDirectory.isInferredHidden)
        print(testDirectory.isHidden)
        print(testDirectory.fileSize.dataSizeString())
        print(testDirectory.sizeOfContents.dataSizeString())
        print(String(format: "%d file(s)", testDirectory.fileCount))
        print(testDirectory.creationDate)
        print(testDirectory.contentAccessDate)
        print(testDirectory.modificationDate)
        
        let testFile = testDirectory +/ "TestFile.txt"
        print(testFile.fileExists)
        print(testFile.isLocal)
        print(testFile.isUbiquitous)
        print(testFile.isRegularFile)
        print(testFile.isDirectory)
        print(testFile.isSymbolicLink)
        print(testFile.isInferredHidden)
        print(testFile.isHidden)
        print(testFile.fileSize.dataSizeString())
        print(testFile.sizeOfContents.dataSizeString())
        print(String(format: "%d file(s)", testFile.fileCount))
        print(testFile.creationDate)
        print(testFile.contentAccessDate)
        print(testFile.modificationDate)
        
        let hiddenTestFile = testDirectory +/ ".HiddenTestFile"
        print(hiddenTestFile.fileExists)
        print(hiddenTestFile.isLocal)
        print(hiddenTestFile.isUbiquitous)
        print(hiddenTestFile.isRegularFile)
        print(hiddenTestFile.isDirectory)
        print(hiddenTestFile.isSymbolicLink)
        print(hiddenTestFile.isInferredHidden)
        print(hiddenTestFile.isHidden)
        print(hiddenTestFile.fileSize.dataSizeString())
        print(hiddenTestFile.sizeOfContents.dataSizeString())
        print(String(format: "%d file(s)", hiddenTestFile.fileCount))
        print(hiddenTestFile.creationDate)
        print(hiddenTestFile.contentAccessDate)
        print(hiddenTestFile.modificationDate)
        
        let inferredHiddenTestFile = testDirectory +/ "~InferredHiddenTestFile"
        print(inferredHiddenTestFile.fileExists)
        print(inferredHiddenTestFile.isLocal)
        print(inferredHiddenTestFile.isUbiquitous)
        print(inferredHiddenTestFile.isRegularFile)
        print(inferredHiddenTestFile.isDirectory)
        print(inferredHiddenTestFile.isSymbolicLink)
        print(inferredHiddenTestFile.isInferredHidden)
        print(inferredHiddenTestFile.isHidden)
        print(inferredHiddenTestFile.fileSize.dataSizeString())
        print(inferredHiddenTestFile.sizeOfContents.dataSizeString())
        print(String(format: "%d file(s)", inferredHiddenTestFile.fileCount))
        print(inferredHiddenTestFile.creationDate)
        print(inferredHiddenTestFile.contentAccessDate)
        print(inferredHiddenTestFile.modificationDate)
        
    }
    
    func testURLProperties() {
        
        guard let testDirectory = (Bundle(for: type(of: self)).resourcePath +/ "TestFiles")?.fileURL
            else { XCTFail("Unable to load test files directory."); return }
        
        // URL resource properties
        
        XCTAssert(testDirectory.fileExists)
        XCTAssert(testDirectory.isLocal)
        XCTAssert(!testDirectory.isUbiquitous)
        XCTAssert(!testDirectory.isRegularFile)
        XCTAssert(testDirectory.isDirectory)
        XCTAssert(!testDirectory.isSymbolicLink)
        XCTAssert(!testDirectory.isInferredHidden)
        XCTAssert(!testDirectory.isHidden)

        let testFile = testDirectory +/ "TestFile.txt"
        XCTAssert(testFile.fileExists)
        XCTAssert(testFile.isLocal)
        XCTAssert(!testFile.isUbiquitous)
        XCTAssert(testFile.isRegularFile)
        XCTAssert(!testFile.isDirectory)
        XCTAssert(!testFile.isSymbolicLink)
        XCTAssert(!testFile.isInferredHidden)
        XCTAssert(!testFile.isHidden)
        
        let testLink = testDirectory +/ "TestLink"
        XCTAssert(testLink.fileExists)
        XCTAssert(testLink.isLocal)
        XCTAssert(!testLink.isUbiquitous)
        XCTAssert(!testLink.isRegularFile)
        XCTAssert(!testLink.isDirectory)
        XCTAssert(testLink.isSymbolicLink)
        XCTAssert(!testFile.isInferredHidden)
        XCTAssert(!testFile.isHidden)
        
        let hiddenTestFile = testDirectory +/ ".HiddenTestFile"
        XCTAssert(hiddenTestFile.fileExists)
        XCTAssert(hiddenTestFile.isLocal)
        XCTAssert(!hiddenTestFile.isUbiquitous)
        XCTAssert(hiddenTestFile.isRegularFile)
        XCTAssert(!hiddenTestFile.isDirectory)
        XCTAssert(!hiddenTestFile.isSymbolicLink)
        XCTAssert(hiddenTestFile.isInferredHidden)
        XCTAssert(hiddenTestFile.isHidden)
        
        let inferredHiddenTestFile = testDirectory +/ "~InferredHiddenTestFile"
        XCTAssert(inferredHiddenTestFile.fileExists)
        XCTAssert(inferredHiddenTestFile.isLocal)
        XCTAssert(!inferredHiddenTestFile.isUbiquitous)
        XCTAssert(inferredHiddenTestFile.isRegularFile)
        XCTAssert(!inferredHiddenTestFile.isDirectory)
        XCTAssert(!inferredHiddenTestFile.isSymbolicLink)
        XCTAssert(inferredHiddenTestFile.isInferredHidden)
        XCTAssert(!inferredHiddenTestFile.isHidden)
        
    }
    
    func testFileManager() {
        
        guard let testDirectory = (Bundle(for: type(of: self)).resourcePath +/ "TestFiles")
            else { XCTFail("Unable to load test files directory."); return }
        
        // Copy a test directory from one testDirectory to another, and increment
        // the name if the destination testDirectory already exists using a renaming
        // policy that puts the version number after the testDirectory extension
        // prefixed with a dash and bounded by parentheses.
        
        let src = testDirectory +/ "TestFile.txt"
        let dst = FileSystem.tmpFilesPath +/ "FileSystemTests"
        
        FileSystem.removeItem(atPath: dst)
        FileSystem.createDirectory(atPath: dst)
        
        for _ in 0 ..< 15 {
            FileSystem.copyItem(atPath: src, toPath: dst, with:
                FileSystem.NamingPolicy(options:
                    [.versionDashed,
                     .versionInsideParentheses], maxRenamingAttempts: 10))
        }
        
        let dst2 = FileSystem.tmpFilesPath +/ "FileSystemTests-Moved"
        FileSystem.removeItem(atPath: dst2)
        FileSystem.createDirectory(atPath: dst2)
        
        var copiedFiles = FileSystem.contentsOfDirectory(atPath: dst)
        XCTAssert(copiedFiles.count == 11)
        
        for path in copiedFiles {
            print(path)
            FileSystem.moveItem(atPath: dst +/ path, toPath: dst2)
        }
        
        let movedFiles = FileSystem.contentsOfDirectory(atPath: dst2)
        copiedFiles = FileSystem.contentsOfDirectory(atPath: dst)
        XCTAssert(copiedFiles.count == 0)
        XCTAssert(movedFiles.count == 11)
        
    }
    
}
