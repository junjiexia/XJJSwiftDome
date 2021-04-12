//
//  XJJGUID.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/3/16.
//

import Foundation

class XJJGUID: Codable {
    
    enum StreamType: Int, Codable {
        case ASF_UNKNOWN = 0
        case ASF_AUDIO = 1
        case ASF_VIDEO = 2
        case ASF_CONTROL = 3
        case ASF_JFIF = 4
        case ASF_DEGRADABLE_JPEG = 5
        case ASF_FILE_TRANSFER = 6
        case ASF_BINARY = 7
    }
    
    struct GUIDS: Codable {
        var id: ID = ID.NONE
        var descript: String = ""
        var guid: GUID = GUID()
        
        enum ID: Int, Codable {
            case NONE = -1
            case GUID_ERROR = 0
            /* base ASF objects */
            case GUID_ASF_HEADER = 1
            case GUID_ASF_DATA = 2
            case GUID_ASF_SIMPLE_INDEX = 3
            case GUID_INDEX = 4
            case GUID_MEDIA_OBJECT_INDEX = 5
            case GUID_TIMECODE_INDEX = 6
            /* header ASF objects */
            case GUID_ASF_FILE_PROPERTIES = 7
            case GUID_ASF_STREAM_PROPERTIES = 8
            case GUID_ASF_HEADER_EXTENSION = 9
            case GUID_ASF_CODEC_LIST = 10
            case GUID_ASF_SCRIPT_COMMAND = 11
            case GUID_ASF_MARKER = 12
            case GUID_ASF_BITRATE_MUTUAL_EXCLUSION = 13
            case GUID_ASF_ERROR_CORRECTION = 14
            case GUID_ASF_CONTENT_DESCRIPTION = 15
            case GUID_ASF_EXTENDED_CONTENT_DESCRIPTION = 16
            case GUID_ASF_STREAM_BITRATE_PROPERTIES = 17
            case GUID_ASF_EXTENDED_CONTENT_ENCRYPTION = 18
            case GUID_ASF_PADDING = 19
            /* stream properties object stream type */
            case GUID_ASF_AUDIO_MEDIA = 20
            case GUID_ASF_VIDEO_MEDIA = 21
            case GUID_ASF_COMMAND_MEDIA = 22
            case GUID_ASF_JFIF_MEDIA = 23
            case GUID_ASF_DEGRADABLE_JPEG_MEDIA = 24
            case GUID_ASF_FILE_TRANSFER_MEDIA = 25
            case GUID_ASF_BINARY_MEDIA = 26
            /* stream properties object error correction type */
            case GUID_ASF_NO_ERROR_CORRECTION = 27
            case GUID_ASF_AUDIO_SPREAD = 28
            /* mutual exclusion object exlusion type */
            case GUID_ASF_MUTEX_BITRATE = 29
            case GUID_ASF_MUTEX_UKNOWN = 30
            /* header extension */
            case GUID_ASF_RESERVED_1 = 31
            /* script command */
            case GUID_ASF_RESERVED_SCRIPT_COMMNAND = 32
            /* marker object */
            case GUID_ASF_RESERVED_MARKER = 33
            /* various */
            case GUID_ASF_AUDIO_CONCEAL_NONE = 34
            case GUID_ASF_CODEC_COMMENT1_HEADER = 35
            case GUID_ASF_2_0_HEADER = 36
            case GUID_ASF_EXTENDED_STREAM_PROPERTIES = 37
            case GUID_END = 38
        }
    }
    
    struct GUID: Codable {
        var Data1: UInt32 = 0x0 //
        var Data2: UInt16 = 0x0 //
        var Data3: UInt16 = 0x0 //
        var Data4: [UInt8] = [0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0, 0x0] //
    }
    
    static let guids: [GUIDS] = [
        GUIDS(id: .GUID_ERROR, descript: "error", guid: GUID()),
        
        /* base ASF objects */
        GUIDS(id: .GUID_ASF_HEADER, descript: "header", guid: GUID(Data1: 0x75b22630, Data2: 0x668e, Data3: 0x11cf, Data4: [0xa6, 0xd9, 0x00, 0xaa, 0x00, 0x62, 0xce, 0x6c])),
        GUIDS(id: .GUID_ASF_DATA, descript: "data", guid: GUID(Data1: 0x75b22636, Data2: 0x668e, Data3: 0x11cf, Data4: [0xa6, 0xd9, 0x00, 0xaa, 0x00, 0x62, 0xce, 0x6c])),
        GUIDS(id: .GUID_ASF_SIMPLE_INDEX, descript: "simple index", guid: GUID(Data1: 0x33000890, Data2: 0xe5b1, Data3: 0x11cf, Data4: [0x89, 0xf4, 0x00, 0xa0, 0xc9, 0x03, 0x49, 0xcb])),
        GUIDS(id: .GUID_INDEX, descript: "index", guid: GUID(Data1: 0xd6e229d3, Data2: 0x35da, Data3: 0x11d1, Data4: [0x90, 0x34, 0x00, 0xa0, 0xc9, 0x03, 0x49, 0xbe])),
        GUIDS(id: .GUID_MEDIA_OBJECT_INDEX, descript: "media object index", guid: GUID(Data1: 0xfeb103f8, Data2: 0x12ad, Data3: 0x4c64, Data4: [0x84, 0x0f, 0x2a, 0x1d, 0x2f, 0x7a, 0xd4, 0x8c])),
        GUIDS(id: .GUID_TIMECODE_INDEX, descript: "timecode index", guid: GUID(Data1: 0x3cb73fd0, Data2: 0x0c4a, Data3: 0x4803, Data4: [0x95, 0x3d, 0xed, 0xf7, 0xb6, 0x22, 0x8f, 0x0c])),
        
        /* header ASF objects */
        GUIDS(id: .GUID_ASF_FILE_PROPERTIES, descript: "file properties", guid: GUID(Data1: 0x8cabdca1, Data2: 0xa947, Data3: 0x11cf, Data4: [0x8e, 0xe4, 0x00, 0xc0, 0x0c, 0x20, 0x53, 0x65])),
        GUIDS(id: .GUID_ASF_STREAM_PROPERTIES, descript: "stream header", guid: GUID(Data1: 0xb7dc0791, Data2: 0xa9b7, Data3: 0x11cf, Data4: [0x8e, 0xe6, 0x00, 0xc0, 0x0c, 0x20, 0x53, 0x65])),
        GUIDS(id: .GUID_ASF_HEADER_EXTENSION, descript: "header extension", guid: GUID(Data1: 0x5fbf03b5, Data2: 0xa92e, Data3: 0x11cf, Data4: [0x8e, 0xe3, 0x00, 0xc0, 0x0c, 0x20, 0x53, 0x65])),
        GUIDS(id: .GUID_ASF_CODEC_LIST, descript: "codec list", guid: GUID(Data1: 0x86d15240, Data2: 0x311d, Data3: 0x11d0, Data4: [0xa3, 0xa4, 0x00, 0xa0, 0xc9, 0x03, 0x48, 0xf6])),
        GUIDS(id: .GUID_ASF_SCRIPT_COMMAND, descript: "script command", guid: GUID(Data1: 0x1efb1a30, Data2: 0x0b62, Data3: 0x11d0, Data4: [0xa3, 0x9b, 0x00, 0xa0, 0xc9, 0x03, 0x48, 0xf6])),
        GUIDS(id: .GUID_ASF_MARKER, descript: "marker", guid: GUID(Data1: 0xf487cd01, Data2: 0xa951, Data3: 0x11cf, Data4: [0x8e, 0xe6, 0x00, 0xc0, 0x0c, 0x20, 0x53, 0x65])),
        GUIDS(id: .GUID_ASF_BITRATE_MUTUAL_EXCLUSION, descript: "bitrate mutual exclusion", guid: GUID(Data1: 0xd6e229dc, Data2: 0x35da, Data3: 0x11d1, Data4: [0x90, 0x34, 0x00, 0xa0, 0xc9, 0x03, 0x49, 0xbe])),
        GUIDS(id: .GUID_ASF_ERROR_CORRECTION, descript: "error correction", guid: GUID(Data1: 0x75b22635, Data2: 0x668e, Data3: 0x11cf, Data4: [0xa6, 0xd9, 0x00, 0xaa, 0x00, 0x62, 0xce, 0x6c])),
        GUIDS(id: .GUID_ASF_CONTENT_DESCRIPTION, descript: "content description", guid: GUID(Data1: 0x75b22633, Data2: 0x668e, Data3: 0x11cf, Data4: [0xa6, 0xd9, 0x00, 0xaa, 0x00, 0x62, 0xce, 0x6c])),
        GUIDS(id: .GUID_ASF_EXTENDED_CONTENT_DESCRIPTION, descript: "extended content description", guid: GUID(Data1: 0xd2d0a440, Data2: 0xe307, Data3: 0x11d2, Data4: [0x97, 0xf0, 0x00, 0xa0, 0xc9, 0x5e, 0xa8, 0x50])),
        /* stream bitrate properties (http://get.to/sdp) */
        GUIDS(id: .GUID_ASF_STREAM_BITRATE_PROPERTIES, descript: "stream bitrate properties", guid: GUID(Data1: 0x7bf875ce, Data2: 0x468d, Data3: 0x11d1, Data4: [0x8d, 0x82, 0x00, 0x60, 0x97, 0xc9, 0xa2, 0xb2])),
        GUIDS(id: .GUID_ASF_EXTENDED_CONTENT_ENCRYPTION, descript: "extended content encryption", guid: GUID(Data1: 0x298ae614, Data2: 0x2622, Data3: 0x4c17, Data4: [0xb9, 0x35, 0xda, 0xe0, 0x7e, 0xe9, 0x28, 0x9c])),
        GUIDS(id: .GUID_ASF_PADDING, descript: "padding", guid: GUID(Data1: 0x1806d474, Data2: 0xcadf, Data3: 0x4509, Data4: [0xa4, 0xba, 0x9a, 0xab, 0xcb, 0x96, 0xaa, 0xe8])),
        
        /* stream properties object stream type */
        GUIDS(id: .GUID_ASF_AUDIO_MEDIA, descript: "audio media", guid: GUID(Data1: 0xf8699e40, Data2: 0x5b4d, Data3: 0x11cf, Data4: [0xa8, 0xfd, 0x00, 0x80, 0x5f, 0x5c, 0x44, 0x2b])),
        GUIDS(id: .GUID_ASF_VIDEO_MEDIA, descript: "video media", guid: GUID(Data1: 0xbc19efc0, Data2: 0x5b4d, Data3: 0x11cf, Data4: [0xa8, 0xfd, 0x00, 0x80, 0x5f, 0x5c, 0x44, 0x2b])),
        GUIDS(id: .GUID_ASF_COMMAND_MEDIA, descript: "command media", guid: GUID(Data1: 0x59dacfc0, Data2: 0x59e6, Data3: 0x11d0, Data4: [0xa3, 0xac, 0x00, 0xa0, 0xc9, 0x03, 0x48, 0xf6])),
        GUIDS(id: .GUID_ASF_JFIF_MEDIA, descript: "JFIF media (JPEG)", guid: GUID(Data1: 0xb61be100, Data2: 0x5b4e, Data3: 0x11cf, Data4: [0xa8, 0xfd, 0x00, 0x80, 0x5f, 0x5c, 0x44, 0x2b])),
        GUIDS(id: .GUID_ASF_DEGRADABLE_JPEG_MEDIA, descript: "Degradable JPEG media", guid: GUID(Data1: 0x35907de0, Data2: 0xe415, Data3: 0x11cf, Data4: [0xa9, 0x17, 0x00, 0x80, 0x5f, 0x5c, 0x44, 0x2b])),
        GUIDS(id: .GUID_ASF_FILE_TRANSFER_MEDIA, descript: "File Transfer media", guid: GUID(Data1: 0x91bd222c, Data2: 0xf21c, Data3: 0x497a, Data4: [0x8b, 0x6d, 0x5a, 0xa8, 0x6b, 0xfc, 0x01, 0x85])),
        GUIDS(id: .GUID_ASF_BINARY_MEDIA, descript: "Binary media", guid: GUID(Data1: 0x3afb65e2, Data2: 0x47ef, Data3: 0x40f2, Data4: [0xac, 0x2c, 0x70, 0xa9, 0x0d, 0x71, 0xd3, 0x43])),
        
        /* stream properties object error correction */
        GUIDS(id: .GUID_ASF_NO_ERROR_CORRECTION, descript: "no error correction", guid: GUID(Data1: 0x20fb5700, Data2: 0x5b55, Data3: 0x11cf, Data4: [0xa8, 0xfd, 0x00, 0x80, 0x5f, 0x5c, 0x44, 0x2b])),
        GUIDS(id: .GUID_ASF_AUDIO_SPREAD, descript: "audio spread", guid: GUID(Data1: 0xbfc3cd50, Data2: 0x618f, Data3: 0x11cf, Data4: [0x8b, 0xb2, 0x00, 0xaa, 0x00, 0xb4, 0xe2, 0x20])),
        
        /* mutual exclusion object exlusion type */
        GUIDS(id: .GUID_ASF_MUTEX_BITRATE, descript: "mutex bitrate", guid: GUID(Data1: 0xd6e22a01, Data2: 0x35da, Data3: 0x11d1, Data4: [0x90, 0x34, 0x00, 0xa0, 0xc9, 0x03, 0x49, 0xbe])),
        GUIDS(id: .GUID_ASF_MUTEX_UKNOWN, descript: "mutex unknown", guid: GUID(Data1: 0xd6e22a02, Data2: 0x35da, Data3: 0x11d1, Data4: [0x90, 0x34, 0x00, 0xa0, 0xc9, 0x03, 0x49, 0xbe])),
        
        /* header extension */
        GUIDS(id: .GUID_ASF_RESERVED_1, descript: "reserved_1", guid: GUID(Data1: 0xabd3d211, Data2: 0xa9ba, Data3: 0x11cf, Data4: [0x8e, 0xe6, 0x00, 0xc0, 0x0c, 0x20, 0x53, 0x65])),
        
        /* script command */
        GUIDS(id: .GUID_ASF_RESERVED_SCRIPT_COMMNAND, descript: "reserved script command", guid: GUID(Data1: 0x4B1ACBE3, Data2: 0x100B, Data3: 0x11D0, Data4: [0xA3, 0x9B, 0x00, 0xA0, 0xC9, 0x03, 0x48, 0xF6])),
        
        /* marker object */
        GUIDS(id: .GUID_ASF_RESERVED_MARKER, descript: "reserved marker", guid: GUID(Data1: 0x4CFEDB20, Data2: 0x75F6, Data3: 0x11CF, Data4: [0x9C, 0x0F, 0x00, 0xA0, 0xC9, 0x03, 0x49, 0xCB])),
        
        /* various */
        /* Already defined (reserved_1)
        { "head2",
        { 0xabd3d211, 0xa9ba, 0x11cf, { 0x8e, 0xe6, 0x00, 0xc0, 0x0c, 0x20, 0x53, 0x65 }} },
        */
        GUIDS(id: .GUID_ASF_AUDIO_CONCEAL_NONE, descript: "audio conceal none", guid: GUID(Data1: 0x49f1a440, Data2: 0x4ece, Data3: 0x11d0, Data4: [0xa3, 0xac, 0x00, 0xa0, 0xc9, 0x03, 0x48, 0xf6])),
        GUIDS(id: .GUID_ASF_CODEC_COMMENT1_HEADER, descript: "codec comment1 header", guid: GUID(Data1: 0x86d15241, Data2: 0x311d, Data3: 0x11d0, Data4: [0xa3, 0xa4, 0x00, 0xa0, 0xc9, 0x03, 0x48, 0xf6])),
        GUIDS(id: .GUID_ASF_2_0_HEADER, descript: "asf 2.0 header", guid: GUID(Data1: 0xd6e229d1, Data2: 0x35da, Data3: 0x11d1, Data4: [0x90, 0x34, 0x00, 0xa0, 0xc9, 0x03, 0x49, 0xbe])),
        GUIDS(id: .GUID_ASF_EXTENDED_STREAM_PROPERTIES, descript: "extended stream properties", guid: GUID(Data1: 0x14e6a5cb, Data2: 0xc672, Data3: 0x4332, Data4: [0x83, 0x99, 0xa9, 0x69, 0x52, 0x06, 0x5b, 0x5a]))
    ]
}
