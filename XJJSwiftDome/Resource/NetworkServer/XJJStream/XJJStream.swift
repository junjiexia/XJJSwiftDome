//
//  XJJStream.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/3/24.
//

import Foundation

class XJJStream: NSObject {
    var readDataBlock: ((_ data: Data) -> Void)?
    
    var bufferSize: Int = 2048
    
    override init() {}
    
    func stream(input filePath: String) {
        self.readData.removeAll()
        self.inputStream = XJJInputStream(fileAtPath: filePath)
        self.inputStream?.delegate = self
        self.inputStream?.schedule(in: .current, forMode: .default)
        self.inputStream?.open()
    }
    
    func stream(output data: Data, toFilePath: String) {
        self.writeData = data
        self.outputStream = XJJOutputStream(toFileAtPath: toFilePath, append: true)
        self.outputStream?.delegate = self
        self.outputStream?.schedule(in: .current, forMode: .default)
        self.outputStream?.open()
    }
    
    private var inputStream: XJJInputStream?
    private var readData: Data = Data()
    
    private var outputStream: XJJOutputStream?
    private var writeData: Data = Data()
    private var bufferIndex: Int = 0
    private var bufferBytes: Int = 0
}

extension XJJStream: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        
        switch eventCode {
        case .hasBytesAvailable:
            
            if let stream = aStream as? XJJInputStream {
                let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
                let length = stream.read(buffer, maxLength: bufferSize)
                
                if length > 0 {
                    self.readData.append(Data(bytes: buffer, count: length))
                }else {
                    print("XJJInputStream - 数据长度为0")
                }
            }else if let stream = aStream as? XJJOutputStream {
                self.bufferBytes += bufferIndex
                let left_length = writeData.count - bufferBytes
                let length = left_length > bufferSize ? bufferSize : left_length
                let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: length)
                
                if let range = Range(NSRange(location: bufferBytes, length: length)) {
                    self.writeData.copyBytes(to: buffer, from: range)
                    stream.write(buffer, maxLength: bufferSize)
                    self.bufferIndex = length
                }
            }
        case .endEncountered:
            aStream.close()
            aStream.remove(from: .current, forMode: .default)
            if aStream == inputStream {
                inputStream = nil
                self.readDataBlock?(readData)
            }else if aStream == outputStream {
                outputStream = nil
            }
        default:
            break
        }
    }
}

class XJJInputStream: InputStream {
    
}

class XJJOutputStream: OutputStream {
    
}
