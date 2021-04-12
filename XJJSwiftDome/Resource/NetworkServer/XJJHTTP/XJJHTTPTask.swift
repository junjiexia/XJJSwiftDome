//
//  XJJHTTPTask.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/3/2.
//

import Foundation
import UIKit

enum XJJHTTPFileType: String {
    case NONE = ""
    case PNG = "png"
    case JPG = "jpg"
    case PDF = "pdf"
    case MP4 = "mp4"
    case MP3 = "mp3"
    case RMVB = "rmvb"
    case WMA = "wma"
    case RAR = "rar"
    case DOC = "doc"
    case DOCX = "docx"
    case XLS = "xls"
    case XLSX = "xlsx"
    case TXT = "txt"
    case PPT = "ppt"
}

enum XJJHTTPFileSaveType {
    case caches // app再次启动需要的文件
    case temp // 临时文件 app退步不会自动删除，需手动删除
    case tmp // 临时文件 app退出就自动删除
}

//MARK: - download - item
class XJJHTTPDownloadItem {
    var downloadResultblock: ((_ isSuccess: Bool, _ filePath: String?) -> Void)?
    
    var fileName: String = "" {
        didSet {
            self.setupFileType()
        }
    }
    var fileType: XJJHTTPFileType = .NONE
    
    var url: URL!
    
    var identifier: Int = -1
    var task: URLSessionDownloadTask?
    var dataTask: URLSessionDataTask?
    var fileSaveType: XJJHTTPFileSaveType = .tmp
    var needCache: Bool = true
    
    init(_ fileName: String) {
        self.fileName = fileName
    }
    
    init(_ fileType: XJJHTTPFileType) {
        self.fileType = fileType
        self.setupFileName()
    }
    
    init() { }
    
    func setup(_ fileType: XJJHTTPFileType) {
        self.fileType = fileType
        self.setupFileName()
    }
    
    func clear() {
        self.url = nil
        self.task = nil
        self.dataTask = nil
    }
    
    private func setupFileName() {
        switch fileType {
        case .DOC:
            self.fileName = "word." + fileType.rawValue
        case .PNG:
            self.fileName = "image." + fileType.rawValue
        case .JPG:
            self.fileName = "image." + fileType.rawValue
        case .PDF:
            self.fileName = "imageFile." + fileType.rawValue
        case .MP4:
            self.fileName = "video." + fileType.rawValue
        case .MP3:
            self.fileName = "audio." + fileType.rawValue
        case .RMVB:
            self.fileName = "video." + fileType.rawValue
        case .WMA:
            self.fileName = "audio." + fileType.rawValue
        case .RAR:
            self.fileName = "compressedFile." + fileType.rawValue
        case .DOCX:
            self.fileName = "word." + fileType.rawValue
        case .XLS:
            self.fileName = "excel." + fileType.rawValue
        case .XLSX:
            self.fileName = "excel." + fileType.rawValue
        case .TXT:
            self.fileName = "text." + fileType.rawValue
        case .PPT:
            self.fileName = "powerpoint." + fileType.rawValue
        case .NONE:
            break
        }
    }
    
    private func setupFileType() {
        guard let last = fileName.components(separatedBy: ".").last else {return}
        switch last {
        case XJJHTTPFileType.DOC.rawValue:
            self.fileType = .DOC
        case XJJHTTPFileType.PNG.rawValue:
            self.fileType = .PNG
        case XJJHTTPFileType.JPG.rawValue:
            self.fileType = .JPG
        case XJJHTTPFileType.PDF.rawValue:
            self.fileType = .PDF
        case XJJHTTPFileType.MP4.rawValue:
            self.fileType = .MP4
        case XJJHTTPFileType.MP3.rawValue:
            self.fileType = .MP3
        case XJJHTTPFileType.RMVB.rawValue:
            self.fileType = .RMVB
        case XJJHTTPFileType.WMA.rawValue:
            self.fileType = .WMA
        case XJJHTTPFileType.RAR.rawValue:
            self.fileType = .RAR
        case XJJHTTPFileType.DOCX.rawValue:
            self.fileType = .DOCX
        case XJJHTTPFileType.XLS.rawValue:
            self.fileType = .XLS
        case XJJHTTPFileType.XLSX.rawValue:
            self.fileType = .XLSX
        case XJJHTTPFileType.TXT.rawValue:
            self.fileType = .TXT
        case XJJHTTPFileType.PPT.rawValue:
            self.fileType = .PPT
        default:break
        }
    }
}

class XJJHTTPDownloadTask {
    var isRuning: Bool = false
    var items: [XJJHTTPDownloadItem] = []
    var tempItems: [XJJHTTPDownloadItem] = []
    var maxIndex: Int = -1
}

class XJJHTTPDownloadWorkerItem {
    var urlStr: String?
    var fileName: String?
    var saveFileType: XJJHTTPFileSaveType?
    var needCache: Bool = true
    
    init(_ urlStr: String, _ fileName: String, saveFileType: XJJHTTPFileSaveType? = nil, needCache: Bool? = true) {
        self.urlStr = urlStr
        self.fileName = fileName
        self.saveFileType = saveFileType
        self.needCache = needCache!
    }
}

//MARK: - upload - item
class XJJHTTPUploadItem {
    var uploadProgressBlock: ((_ progress: Float) -> Void)?
    var uploadCompleteBlock: ((_ isSuccess: Bool, _ result: String) -> Void)?

    var task: URLSessionUploadTask?
    var url: URL?
    var identifier: Int = -1
    var data: Data?
    
    func clear() {
        self.url = nil
        self.task = nil
    }
}

class XJJHTTPUploadTask {
    var isRuning: Bool = false
    var items: [XJJHTTPUploadItem] = []
    var maxIndex: Int = -1
}

class XJJHTTPUploadWorkerItem {
    var urlStr: String?
    var name: String = "uploadFile"
    var fileName: String = "uploadFileName"
    var data: Data?
    var uploadFileType: XJJHTTPDataType.TType = .NONE
    
    init() {}

    init(_ urlStr: String, _ name: String, _ fileName: String, _ data: Data, uploadFileType: XJJHTTPDataType.TType? = .NONE) {
        self.urlStr = urlStr
        self.name = name
        self.fileName = fileName
        self.data = data
        self.uploadFileType = uploadFileType!
    }
    
    init(_ urlStr: String, _ name: String, _ fileName: String, _ image: UIImage, uploadFileType: XJJHTTPDataType.TType? = .JPEG) {
        self.urlStr = urlStr
        self.name = name
        self.fileName = fileName
        self.data = image.jpegData(compressionQuality: 1.0)
        self.uploadFileType = uploadFileType!
    }
}

//MARK: - stream - item
enum XJJHTTPStreamType {
    case read // 读 -- InputStream
    case write // 写 -- OutputStream
}

class XJJHTTPStreamTask {
    var isStreaming: Bool = false // 流是否在运行
    var task: URLSessionStreamTask? //
    var input: InputStream? // 输入流（read 获取服务器数据）
    var output: OutputStream? // 输出流（write 写数据入服务器）
    var type: XJJHTTPStreamType = .read
    
    var readData: Data? // 读取数据
    var writeData: Data? // 写入数据
    
    func close() {
        self.closeInput()
        self.closeOutput()
    }
    
    func closeInput() {
        if self.input != nil {
            self.input?.close()
            self.input = nil
        }
    }
    
    func closeOutput() {
        if self.output != nil {
            self.output?.close()
            self.output = nil
        }
    }
}

class XJJHTTPStreamWorkerTask {
    var type: XJJHTTPStreamType = .read
    // input //
    var urlStr: String?
    var port: Int = 8080
    var minLength: Int = 0 // 最小获取量
    var maxLength: Int = 2048 // 最大获取量
    var timeOut: TimeInterval = 60 // 超时时间
    
    // output //
    var filePath: String?
    var data: Data?
    
    init(read urlStr: String, port: Int? = nil, minLength: Int? = nil, maxLength: Int? = nil, timeOut: TimeInterval? = nil) {
        self.type = .read
        self.urlStr = urlStr
        self.port = port ?? 8080
        self.minLength = minLength ?? 0
        self.maxLength = maxLength ?? 2048
        self.timeOut = timeOut ?? 60
    }
    
    init(write filePath: String) {
        self.filePath = filePath
    }
}
