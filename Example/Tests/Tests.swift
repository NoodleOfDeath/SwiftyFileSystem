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
    
    func testURLDirectory() {
        
        guard let testDirectory = (Bundle(for: type(of: self)).resourcePath +/ "TestFiles")?.fileURL
            else { XCTFail("Unable to load test files directory."); return }
        
        // URL resource properties
        
        XCTAssertTrue(testDirectory.fileExists)
        XCTAssertTrue(testDirectory.isLocal)
        XCTAssertFalse(testDirectory.isUbiquitous)
        XCTAssertFalse(testDirectory.isRegularFile)
        XCTAssertTrue(testDirectory.isDirectory)
        XCTAssertFalse(testDirectory.isSymbolicLink)
        XCTAssertFalse(testDirectory.isInferredHidden)
        XCTAssertFalse(testDirectory.isHidden)
        XCTAssertEqual("0 bytes", testDirectory.fileSize.dataSizeString())
        XCTAssertEqual("72 bytes", testDirectory.sizeOfContents.dataSizeString())
        XCTAssertEqual("4 file(s)", String(format: "%d file(s)", testDirectory.fileCount))
        print(testDirectory.creationDate)
        print(testDirectory.contentAccessDate)
        print(testDirectory.modificationDate)

    }

    func testURLRegularFile() {

        guard let testDirectory = (Bundle(for: type(of: self)).resourcePath +/ "TestFiles")?.fileURL
            else { XCTFail("Unable to load test files directory."); return }

        let url = testDirectory +/ "TestFile.txt"
        XCTAssertTrue(url.fileExists)
        XCTAssertTrue(url.isLocal)
        XCTAssertFalse(url.isUbiquitous)
        XCTAssertTrue(url.isRegularFile)
        XCTAssertFalse(url.isDirectory)
        XCTAssertFalse(url.isSymbolicLink)
        XCTAssertFalse(url.isInferredHidden)
        XCTAssertFalse(url.isHidden)
        XCTAssertEqual("20 bytes", url.fileSize.dataSizeString())
        XCTAssertEqual("20 bytes", url.sizeOfContents.dataSizeString())
        XCTAssertEqual("0 file(s)", String(format: "%d file(s)", url.fileCount))
        print(url.creationDate)
        print(url.contentAccessDate)
        print(url.modificationDate)

    }

    func testURLSymbolicLink() {

        guard let testDirectory = (Bundle(for: type(of: self)).resourcePath +/ "TestFiles")?.fileURL
            else { XCTFail("Unable to load test files directory."); return }
        
        let url = testDirectory +/ "TestLink"
        XCTAssertTrue(url.fileExists)
        XCTAssertTrue(url.isLocal)
        XCTAssertFalse(url.isUbiquitous)
        XCTAssertFalse(url.isRegularFile)
        XCTAssertFalse(url.isDirectory)
        XCTAssertTrue(url.isSymbolicLink)
        XCTAssertFalse(url.isInferredHidden)
        XCTAssertFalse(url.isHidden)
        XCTAssertEqual("12 bytes", url.fileSize.dataSizeString())
        XCTAssertEqual("12 bytes", url.sizeOfContents.dataSizeString())
        XCTAssertEqual("12 bytes", url.sizeOfContents.dataSizeString())
        XCTAssertEqual("0 file(s)", String(format: "%d file(s)", url.fileCount))
        print(url.creationDate)
        print(url.contentAccessDate)
        print(url.modificationDate)

        let dst = testDirectory +/ "TestFile.txt"
        XCTAssertEqual(url.destinationURL, dst)
        XCTAssertEqual(url.destinationURL?.fileExists, dst.fileExists)
        XCTAssertEqual(url.destinationURL?.isLocal, dst.isLocal)
        XCTAssertEqual(url.destinationURL?.isUbiquitous, dst.isUbiquitous)
        XCTAssertEqual(url.destinationURL?.isRegularFile, dst.isRegularFile)
        XCTAssertEqual(url.destinationURL?.isDirectory, dst.isDirectory)
        XCTAssertEqual(url.destinationURL?.isSymbolicLink, dst.isSymbolicLink)
        XCTAssertEqual(url.destinationURL?.isInferredHidden, dst.isInferredHidden)
        XCTAssertEqual(url.destinationURL?.isHidden, dst.isHidden)
        XCTAssertEqual(url.destinationURL?.fileSize.dataSizeString(), dst.fileSize.dataSizeString())
        XCTAssertEqual(url.destinationURL?.sizeOfContents.dataSizeString(), dst.sizeOfContents.dataSizeString())
        XCTAssertEqual(String(format: "%d file(s)", url.destinationURL?.fileCount ?? 99),
                       String(format: "%d file(s)", dst.fileCount))
        XCTAssertEqual(url.destinationURL?.creationDate, dst.creationDate)
        XCTAssertEqual(url.destinationURL?.contentAccessDate, dst.contentAccessDate)
        XCTAssertEqual(url.destinationURL?.modificationDate, dst.modificationDate)

    }

    func testURLHiddenFile() {

        guard let testDirectory = (Bundle(for: type(of: self)).resourcePath +/ "TestFiles")?.fileURL
            else { XCTFail("Unable to load test files directory."); return }
        
        let url = testDirectory +/ ".HiddenTestFile"
        XCTAssertTrue(url.fileExists)
        XCTAssertTrue(url.isLocal)
        XCTAssertFalse(url.isUbiquitous)
        XCTAssertTrue(url.isRegularFile)
        XCTAssertFalse(url.isDirectory)
        XCTAssertFalse(url.isSymbolicLink)
        XCTAssertTrue(url.isInferredHidden)
        XCTAssertTrue(url.isHidden)
        XCTAssertEqual("20 bytes", url.fileSize.dataSizeString())
        XCTAssertEqual("20 bytes", url.sizeOfContents.dataSizeString())
        XCTAssertEqual("0 file(s)", String(format: "%d file(s)", url.fileCount))
        print(url.creationDate)
        print(url.contentAccessDate)
        print(url.modificationDate)

    }

    func testURLInferredHiddenFile() {

        guard let testDirectory = (Bundle(for: type(of: self)).resourcePath +/ "TestFiles")?.fileURL
            else { XCTFail("Unable to load test files directory."); return }
        
        let url = testDirectory +/ "~InferredHiddenTestFile"
        XCTAssertTrue(url.fileExists)
        XCTAssertTrue(url.isLocal)
        XCTAssertFalse(url.isUbiquitous)
        XCTAssertTrue(url.isRegularFile)
        XCTAssertFalse(url.isDirectory)
        XCTAssertFalse(url.isSymbolicLink)
        XCTAssertTrue(url.isInferredHidden)
        XCTAssertFalse(url.isHidden)
        XCTAssertEqual("20 bytes", url.fileSize.dataSizeString())
        XCTAssertEqual("20 bytes", url.sizeOfContents.dataSizeString())
        XCTAssertEqual("0 file(s)", String(format: "%d file(s)", url.fileCount))
        print(url.creationDate)
        print(url.contentAccessDate)
        print(url.modificationDate)
        
    }

    func testDocumentDirectory() {

        guard let testDirectory = (Bundle(for: type(of: self)).resourcePath +/ "TestFiles")?.fileURL
            else { XCTFail("Unable to load test files directory."); return }

        let document = Document(fileURL: testDirectory)

        XCTAssertTrue(document.fileExists)
        XCTAssertTrue(document.isLocal)
        XCTAssertFalse(document.isUbiquitous)
        XCTAssertFalse(document.isRegularFile)
        XCTAssertTrue(document.isDirectory)
        XCTAssertFalse(document.isSymbolicLink)
        XCTAssertFalse(document.isInferredHidden)
        XCTAssertFalse(document.isHidden)
        XCTAssertEqual("0 bytes", document.fileSize.dataSizeString())
        XCTAssertEqual("72 bytes", document.sizeOfContents.dataSizeString())
        XCTAssertEqual("4 file(s)", String(format: "%d file(s)", document.fileCount))
        print(document.creationDate)
        print(document.contentAccessDate)
        print(document.modificationDate)

        let openExpectation = self.expectation(description: "DocumentOpen")
        let closeExpectation = self.expectation(description: "DocumentClose")
        document.open {
            guard $0 else { XCTFail(); return }
            XCTAssertEqual("", document.textContents ?? "")
            openExpectation.fulfill()
            document.close {
                guard $0 else { XCTFail(); return }
                closeExpectation.fulfill()
            }
        }
        
        waitForExpectations(timeout: 5, handler: nil)

    }

    func testDocumentRegularFile() {

        guard let testDirectory = (Bundle(for: type(of: self)).resourcePath +/ "TestFiles")?.fileURL
            else { XCTFail("Unable to load test files directory."); return }

        let document = Document(fileURL: testDirectory +/ "TestFile.txt")

        XCTAssertTrue(document.fileExists)
        XCTAssertTrue(document.isLocal)
        XCTAssertFalse(document.isUbiquitous)
        XCTAssertTrue(document.isRegularFile)
        XCTAssertFalse(document.isDirectory)
        XCTAssertFalse(document.isSymbolicLink)
        XCTAssertFalse(document.isInferredHidden)
        XCTAssertFalse(document.isHidden)
        XCTAssertEqual("20 bytes", document.fileSize.dataSizeString())
        XCTAssertEqual("20 bytes", document.sizeOfContents.dataSizeString())
        XCTAssertEqual("0 file(s)", String(format: "%d file(s)", document.fileCount))
        print(document.creationDate)
        print(document.contentAccessDate)
        print(document.modificationDate)

        let openExpectation = self.expectation(description: "DocumentOpen")
        let closeExpectation = self.expectation(description: "DocumentClose")
        document.open {
            guard $0 else { XCTFail(); return }
            XCTAssertEqual("This is a test file\n", document.textContents ?? "")
            openExpectation.fulfill()
            document.close {
                guard $0 else { XCTFail(); return }
                closeExpectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)

    }

    func testDocumentSymbolicLink() {

        guard let testDirectory = (Bundle(for: type(of: self)).resourcePath +/ "TestFiles")?.fileURL
            else { XCTFail("Unable to load test files directory."); return }

        let document = Document(fileURL: testDirectory +/ "TestLink")

        XCTAssertTrue(document.fileExists)
        XCTAssertTrue(document.isLocal)
        XCTAssertFalse(document.isUbiquitous)
        XCTAssertFalse(document.isRegularFile)
        XCTAssertFalse(document.isDirectory)
        XCTAssertTrue(document.isSymbolicLink)
        XCTAssertFalse(document.isInferredHidden)
        XCTAssertFalse(document.isHidden)
        XCTAssertEqual("12 bytes", document.fileSize.dataSizeString())
        XCTAssertEqual("12 bytes", document.sizeOfContents.dataSizeString())
        XCTAssertEqual("0 file(s)", String(format: "%d file(s)", document.fileCount))
        print(document.creationDate)
        print(document.contentAccessDate)
        print(document.modificationDate)

        let openExpectation = self.expectation(description: "DocumentOpen")
        let closeExpectation = self.expectation(description: "DocumentClose")
        document.open {
            guard $0 else { XCTFail(); return }
            XCTAssertEqual("This is a test file\n", document.textContents ?? "")
            openExpectation.fulfill()
            document.close {
                guard $0 else { XCTFail(); return }
                closeExpectation.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)

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
        
        let copiedFiles = FileSystem.contentsOfDirectory(atPath: dst)
        XCTAssertEqual(copiedFiles.count, 11)

        for path in copiedFiles {
            print(path)
            FileSystem.moveItem(atPath: dst +/ path, toPath: dst2)
        }
        
        XCTAssertEqual(FileSystem.contentsOfDirectory(atPath: dst).count, 0)
        XCTAssertEqual(FileSystem.contentsOfDirectory(atPath: dst2).count, 11)

        if FileSystem.createSymbolicLink(atPath: dst +/ "TestLink", withDestinationPath: "TestFile.txt") {

            let url = (testDirectory +/ "TestLink").fileURL
            let url2 = (testDirectory +/ "TestFile.txt").fileURL
            XCTAssertEqual(url.destinationURL, url2)

            let document = Document(fileURL: url)

            let openExpectation = self.expectation(description: "DocumentOpen")
            let closeExpectation = self.expectation(description: "DocumentClose")
            document.open {
                guard $0 else { XCTFail(); return }
                XCTAssertEqual("This is a test file\n", document.textContents ?? "")
                openExpectation.fulfill()
                document.close {
                    guard $0 else { XCTFail(); return }
                    closeExpectation.fulfill()
                }
            }

            waitForExpectations(timeout: 5, handler: nil)

        } else {
            XCTFail()
        }

        if FileSystem.createSymbolicLink(atPath: dst +/ "TestDirLink", withDestinationPath: "../FileSystemTests") {
            let url = (dst +/ "TestDirLink").fileURL
            let url2 = dst.fileURL
            XCTAssertEqual(url.destinationURL?.fileExists, url2.fileExists)
            XCTAssertEqual(url.destinationURL?.isLocal, url2.isLocal)
            XCTAssertEqual(url.destinationURL?.isUbiquitous, url2.isUbiquitous)
            XCTAssertEqual(url.destinationURL?.isRegularFile, url2.isRegularFile)
            XCTAssertEqual(url.destinationURL?.isDirectory, url2.isDirectory)
            XCTAssertEqual(url.destinationURL?.isSymbolicLink, url2.isSymbolicLink)
            XCTAssertEqual(url.destinationURL?.isInferredHidden, url2.isInferredHidden)
            XCTAssertEqual(url.destinationURL?.isHidden, url2.isHidden)
            XCTAssertEqual(url.destinationURL?.fileSize.dataSizeString(), url2.fileSize.dataSizeString())
            XCTAssertEqual(url.destinationURL?.sizeOfContents.dataSizeString(), url2.sizeOfContents.dataSizeString())
            XCTAssertEqual(String(format: "%d file(s)", url.destinationURL?.fileCount ?? 99),
                           String(format: "%d file(s)", url2.fileCount))
            XCTAssertEqual(url.destinationURL?.creationDate, url2.creationDate)
            XCTAssertEqual(url.destinationURL?.modificationDate, url2.modificationDate)
        } else {
            XCTFail()
        }
        
    }
    
}


