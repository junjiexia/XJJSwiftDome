//
//  XJJAlertPickerView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/8/5.
//

import UIKit

enum XJJAlertPickerStyle {
    case year // 年
    case year_month // 年月
    case year_month_day // 年月日
    case allDate // 年月日时分秒
    case dateWithoutSecond // 年月日时分
    case time // 时分秒
    case timeWithoutSecond // 时分
    case custom // 自定义
}

enum XJJAlertPickerNumber {
    case single
    case double
}

class XJJAlertPickerView: UIView {
    
    var sureBntClickBlock: ((_ first: [XJJText], _ second: [XJJText]) -> Void)? // 普通选择回调
    var sureDateBlock: ((_ first: DateComponents, _ second: DateComponents) -> Void)? // 时间选择回调
        
    func create(custom number: XJJAlertPickerNumber, firstPickerData: [[XJJText]], secondPickerData: [[XJJText]]? = nil, titleOne: XJJText, titleTwo: XJJText? = nil, sureText: XJJText? = nil) {
        self.style = .custom
        self.number = number
        self.pickerDataOne = firstPickerData
        self.pickerDataTwo = secondPickerData ?? []
        self.titleOne = titleOne
        self.titleTwo = titleTwo ?? XJJText("")
        if let text = sureText {
            self.sureText = text
        }
        self.createContent()
    }
        
    func create(date style: XJJAlertPickerStyle, number: XJJAlertPickerNumber, titleOne: XJJText? = nil, titleTwo: XJJText? = nil, sureText: XJJText? = nil) {
        self.style = style
        self.number = number
        if let text = titleOne {
            self.titleOne = text
        }else {
            self.titleOne = number == .double ? XJJText("开始时间") : XJJText("时间选择")
        }
        if let text = titleTwo {
            self.titleTwo = text
        }else {
            self.titleTwo = number == .double ? XJJText("结束时间") : XJJText("")
        }
        if let text = sureText {
            self.sureText = text
        }
        self.createContent()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var labelOne: UILabel!
    private var toLabel: UILabel!
    private var labelTwo: UILabel!
    private var pickerOne: UIPickerView!
    private var pickerTwo: UIPickerView!
    private var sureBtn: UIButton!
    
    private var titleOne: XJJText?
    private var titleTwo: XJJText?
    private var sureText: XJJText = XJJText("确定", color: UIColor.blue)
    private var number: XJJAlertPickerNumber = .single // 选择器数量类型
    private var style: XJJAlertPickerStyle = .custom // 类型
    private var pickerDataOne: [[XJJText]] = [] // 普通选择器数据1
    private var pickerDataTwo: [[XJJText]] = [] // 普通选择器数据2
 
    private var yearStart: Int = 1991
    private let yearCount: Int = 50
    private let monthCount: Int = 12
    private var dayCount: Int = 30 // 只用于计算后临时存放，选择器共用
    private let hourCount: Int = 24
    private let minuteCount: Int = 60
    private let secondCount: Int = 60
    private var dateCountArr: [Int] = []
    private var otherDateCountArr: [Int] = []
    private var dateUnitArr: [String] = []
    private var dateComponents: DateComponents!
    private var otherDateComponents: DateComponents!
    private var dayIndex: Int = -1
    
    private func initUI() {
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.clipsToBounds = true
        self.layer.cornerRadius = 5
        self.layer.borderColor = #colorLiteral(red: 0.8599750385, green: 0.7440964482, blue: 1, alpha: 1)
        self.layer.borderWidth = 1
    }
    
    private func createContent() {
        self.createData()
        self.createFirst()
        self.createSecond()
        self.createBtn()
    }
    
    private func createData() {
        self.dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        self.otherDateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: Date())
        if let year = dateComponents.year {
            self.yearStart = year - 20
        }
        
        switch style {
        case .year:
            self.dateCountArr = [yearCount]
            self.otherDateCountArr = [yearCount]
            self.dateUnitArr = ["年"]
        case .year_month:
            self.dateCountArr = [yearCount, monthCount]
            self.otherDateCountArr = [yearCount, monthCount]
            self.dateUnitArr = ["年", "月"]
        case .year_month_day:
            self.dateCountArr = [yearCount, monthCount, dayCount]
            self.otherDateCountArr = [yearCount, monthCount, dayCount]
            self.dateUnitArr = ["年", "月", "日"]
            self.dayIndex = 2
        case .allDate:
            self.dateCountArr = [yearCount, monthCount, dayCount, hourCount, minuteCount, secondCount]
            self.otherDateCountArr = [yearCount, monthCount, dayCount, hourCount, minuteCount, secondCount]
            self.dateUnitArr = ["年", "月", "日", "时", "分", "秒"]
            self.dayIndex = 2
        case .dateWithoutSecond:
            self.dateCountArr = [yearCount, monthCount, dayCount, hourCount, minuteCount]
            self.otherDateCountArr = [yearCount, monthCount, dayCount, hourCount, minuteCount]
            self.dateUnitArr = ["年", "月", "日", "时", "分"]
            self.dayIndex = 2
        case .time:
            self.dateCountArr = [hourCount, minuteCount, secondCount]
            self.otherDateCountArr = [hourCount, minuteCount, secondCount]
            self.dateUnitArr = ["时", "分", "秒"]
        case .timeWithoutSecond:
            self.dateCountArr = [hourCount, minuteCount]
            self.otherDateCountArr = [hourCount, minuteCount]
            self.dateUnitArr = ["时", "分"]
        default:
            break
        }
    }
    
    private func createFirst() {
        self.labelOne = UILabel(frame: CGRect(x: XJJAlert.borderH, y: XJJAlert.borderV, width: bounds.width - XJJAlert.borderH * 2, height: XJJAlert.textHeight))
        self.addSubview(labelOne)
        
        self.labelOne.setText(titleOne)
        
        self.pickerOne = UIPickerView(frame: CGRect(x: XJJAlert.borderH, y: labelOne.frame.maxY, width: bounds.width - XJJAlert.borderH * 2, height: XJJAlert.pickerHeight))
        self.addSubview(pickerOne)
        
        self.pickerOne.delegate = self
        self.pickerOne.dataSource = self
        self.pickerOne.setValue(UIColor.darkGray, forKey: "textColor")
        self.timeSelect()
    }
    
    private func createSecond() {
        guard number == .double else {return}
        
        self.toLabel = UILabel(frame: CGRect(x: XJJAlert.borderH, y: pickerOne.frame.maxY, width: bounds.width - XJJAlert.borderH * 2, height: XJJAlert.textHeight))
        self.addSubview(toLabel)
        
        self.toLabel.text = "至"
        self.toLabel.textAlignment = .center
        self.toLabel.textColor = UIColor.darkText
        self.toLabel.font = UIFont.systemFont(ofSize: 14)
        
        self.labelTwo = UILabel(frame: CGRect(x: XJJAlert.borderH, y: toLabel.frame.maxY, width: bounds.width - XJJAlert.borderH * 2, height: XJJAlert.textHeight))
        self.addSubview(labelTwo)
        
        self.labelTwo.setText(titleTwo)
        
        self.pickerTwo = UIPickerView(frame: CGRect(x: XJJAlert.borderH, y: labelTwo.frame.maxY, width: bounds.width - XJJAlert.borderH * 2, height: XJJAlert.pickerHeight))
        self.addSubview(pickerTwo)
        
        self.pickerTwo.delegate = self
        self.pickerTwo.dataSource = self
        self.pickerTwo.setValue(UIColor.darkGray, forKey: "textColor")
        self.otherTimeSelect()
    }

    private func createBtn() {
        self.sureBtn = UIButton(type: .custom)
        self.addSubview(sureBtn)
        
        self.sureBtn.setText(sureText)
        self.sureBtn.frame = CGRect(x: bounds.width - sureText.size.width - XJJAlert.borderH, y: bounds.height - XJJAlert.btnHeight, width: sureText.size.width, height: XJJAlert.btnHeight)
        self.sureBtn.addTarget(self, action: #selector(sureAction), for: .touchUpInside)
    }
    
    @objc private func sureAction(_ btn: UIButton) {
        switch style {
        case .year, .year_month, .year_month_day, .allDate, .dateWithoutSecond, .time, .timeWithoutSecond:
            self.sureDateBlock?(dateComponents, otherDateComponents)
        default:
            guard self.pickerDataOne.count > 0 else {return}
            var arr1: [XJJText] = []
            var arr2: [XJJText] = []
            
            for i in 0..<self.pickerDataOne.count {
                let text = self.pickerDataOne[i][self.pickerOne.selectedRow(inComponent: i)]
                arr1.append(text)
            }
            
            if self.pickerDataTwo.count > 0 {
                for i in 0..<self.pickerDataTwo.count {
                    let text = self.pickerDataTwo[i][self.pickerTwo.selectedRow(inComponent: i)]
                    arr2.append(text)
                }
            }
            
            self.sureBntClickBlock?(arr1, arr2)
        }
    }
}

//MARK: - 初值设置
extension XJJAlertPickerView {
    
    func setCurrent(_ value: [XJJText], other: [XJJText]? = nil) {
        guard value.count > 0 else {return}
        for i in 0..<pickerDataOne.count {
            if i < value.count {
                let curr = value[i]
                let arr = pickerDataOne[i]
                for j in 0..<arr.count {
                    let val = arr[j]
                    if val.text == curr.text {
                        self.pickerOne.selectRow(j, inComponent: i, animated: true)
                    }
                }
            }
        }
        
        if let _other = other, _other.count > 0 {
            for i in 0..<pickerDataTwo.count {
                if i < _other.count {
                    let curr = _other[i]
                    let arr = pickerDataTwo[i]
                    for j in 0..<arr.count {
                        let val = arr[j]
                        if val.text == curr.text {
                            self.pickerTwo.selectRow(j, inComponent: i, animated: true)
                        }
                    }
                }
            }
        }
    }
    
    func setCurrent(fristDate value: DateComponents?) {
        guard let _value = value else {return}
        self.dateComponents = _value
        self.timeSelect()
    }
    
    func setCurrent(secondDate value: DateComponents?) {
        guard let _value = value else {return}
        self.otherDateComponents = _value
        self.otherTimeSelect()
    }
    
    private func timeSelect() {
        switch style {
        case .year:
            if let year = dateComponents.year {
                self.pickerOne.selectRow(year - yearStart, inComponent: 0, animated: true)
            }
        case .year_month:
            if let year = dateComponents.year {
                self.pickerOne.selectRow(year - yearStart, inComponent: 0, animated: true)
            }
            if let month = dateComponents.month {
                self.pickerOne.selectRow(month - 1, inComponent: 1, animated: true)
            }
        case .year_month_day:
            if let year = dateComponents.year {
                self.pickerOne.selectRow(year - yearStart, inComponent: 0, animated: true)
            }
            if let month = dateComponents.month {
                self.pickerOne.selectRow(month - 1, inComponent: 1, animated: true)
            }
            if let day = dateComponents.day {
                self.pickerOne.selectRow(day - 1, inComponent: 2, animated: true)
            }
        case .allDate:
            if let year = dateComponents.year {
                self.pickerOne.selectRow(year - yearStart, inComponent: 0, animated: true)
            }
            if let month = dateComponents.month {
                self.pickerOne.selectRow(month - 1, inComponent: 1, animated: true)
            }
            if let day = dateComponents.day {
                self.pickerOne.selectRow(day - 1, inComponent: 2, animated: true)
            }
            if let hour = dateComponents.hour {
                self.pickerOne.selectRow(hour, inComponent: 3, animated: true)
            }
            if let min = dateComponents.minute {
                self.pickerOne.selectRow(min, inComponent: 4, animated: true)
            }
            if let sec = dateComponents.second {
                self.pickerOne.selectRow(sec, inComponent: 5, animated: true)
            }
        case .dateWithoutSecond:
            if let year = dateComponents.year {
                self.pickerOne.selectRow(year - yearStart, inComponent: 0, animated: true)
            }
            if let month = dateComponents.month {
                self.pickerOne.selectRow(month - 1, inComponent: 1, animated: true)
            }
            if let day = dateComponents.day {
                self.pickerOne.selectRow(day - 1, inComponent: 2, animated: true)
            }
            if let hour = dateComponents.hour {
                self.pickerOne.selectRow(hour, inComponent: 3, animated: true)
            }
            if let min = dateComponents.minute {
                self.pickerOne.selectRow(min, inComponent: 4, animated: true)
            }
        case .time:
            if let hour = dateComponents.hour {
                self.pickerOne.selectRow(hour, inComponent: 3, animated: true)
            }
            if let min = dateComponents.minute {
                self.pickerOne.selectRow(min, inComponent: 4, animated: true)
            }
            if let sec = dateComponents.second {
                self.pickerOne.selectRow(sec, inComponent: 5, animated: true)
            }
        case .timeWithoutSecond:
            if let hour = dateComponents.hour {
                self.pickerOne.selectRow(hour, inComponent: 3, animated: true)
            }
            if let min = dateComponents.minute {
                self.pickerOne.selectRow(min, inComponent: 4, animated: true)
            }
        default:
            break
        }
    }
    
    private func otherTimeSelect() {
        switch style {
        case .year:
            if let year = otherDateComponents.year {
                self.pickerTwo.selectRow(year - yearStart, inComponent: 0, animated: true)
            }
        case .year_month:
            if let year = otherDateComponents.year {
                self.pickerTwo.selectRow(year - yearStart, inComponent: 0, animated: true)
            }
            if let month = otherDateComponents.month {
                self.pickerTwo.selectRow(month - 1, inComponent: 1, animated: true)
            }
        case .year_month_day:
            if let year = otherDateComponents.year {
                self.pickerTwo.selectRow(year - yearStart, inComponent: 0, animated: true)
            }
            if let month = otherDateComponents.month {
                self.pickerTwo.selectRow(month - 1, inComponent: 1, animated: true)
            }
            if let day = otherDateComponents.day {
                self.pickerTwo.selectRow(day - 1, inComponent: 2, animated: true)
            }
        case .allDate:
            if let year = otherDateComponents.year {
                self.pickerTwo.selectRow(year - yearStart, inComponent: 0, animated: true)
            }
            if let month = otherDateComponents.month {
                self.pickerTwo.selectRow(month - 1, inComponent: 1, animated: true)
            }
            if let day = otherDateComponents.day {
                self.pickerTwo.selectRow(day - 1, inComponent: 2, animated: true)
            }
            if let hour = otherDateComponents.hour {
                self.pickerTwo.selectRow(hour, inComponent: 3, animated: true)
            }
            if let min = otherDateComponents.minute {
                self.pickerTwo.selectRow(min, inComponent: 4, animated: true)
            }
            if let sec = otherDateComponents.second {
                self.pickerTwo.selectRow(sec, inComponent: 5, animated: true)
            }
        case .dateWithoutSecond:
            if let year = otherDateComponents.year {
                self.pickerTwo.selectRow(year - yearStart, inComponent: 0, animated: true)
            }
            if let month = otherDateComponents.month {
                self.pickerTwo.selectRow(month - 1, inComponent: 1, animated: true)
            }
            if let day = otherDateComponents.day {
                self.pickerTwo.selectRow(day - 1, inComponent: 2, animated: true)
            }
            if let hour = otherDateComponents.hour {
                self.pickerTwo.selectRow(hour, inComponent: 3, animated: true)
            }
            if let min = otherDateComponents.minute {
                self.pickerTwo.selectRow(min, inComponent: 4, animated: true)
            }
        case .time:
            if let hour = otherDateComponents.hour {
                self.pickerTwo.selectRow(hour, inComponent: 3, animated: true)
            }
            if let min = otherDateComponents.minute {
                self.pickerTwo.selectRow(min, inComponent: 4, animated: true)
            }
            if let sec = otherDateComponents.second {
                self.pickerTwo.selectRow(sec, inComponent: 5, animated: true)
            }
        case .timeWithoutSecond:
            if let hour = otherDateComponents.hour {
                self.pickerTwo.selectRow(hour, inComponent: 3, animated: true)
            }
            if let min = otherDateComponents.minute {
                self.pickerTwo.selectRow(min, inComponent: 4, animated: true)
            }
        default:
            break
        }
    }
}

//MARK: - picker 协议
extension XJJAlertPickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == pickerOne {
            switch style {
            case .year, .year_month, .year_month_day, .allDate, .dateWithoutSecond, .time, .timeWithoutSecond:
                return self.dateCountArr.count
            default:
                break
            }
            return self.pickerDataOne.count
        }else if pickerView == pickerTwo {
            switch style {
            case .year, .year_month, .year_month_day, .allDate, .dateWithoutSecond, .time, .timeWithoutSecond:
                return self.otherDateCountArr.count
            default:
                break
            }
            return self.pickerDataTwo.count
        }else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == pickerOne {
            switch style {
            case .year, .year_month, .year_month_day, .allDate, .dateWithoutSecond, .time, .timeWithoutSecond:
                return self.dateCountArr[component]
            default:
                break
            }
            return self.pickerDataOne[component].count
        }else if pickerView == pickerTwo {
            switch style {
            case .year, .year_month, .year_month_day, .allDate, .dateWithoutSecond, .time, .timeWithoutSecond:
                return self.otherDateCountArr[component]
            default:
                break
            }
            return self.pickerDataTwo[component].count
        }else {
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var _view = view as? UILabel
        if _view == nil {
            _view = UILabel()
            _view?.font = UIFont.systemFont(ofSize: 15)
            _view?.textAlignment = .center
            _view?.adjustsFontSizeToFitWidth = true
            _view?.minimumScaleFactor = 0.5
        }
        
        switch style {
        case .year, .year_month, .year_month_day, .allDate, .dateWithoutSecond, .time, .timeWithoutSecond:
            switch self.dateUnitArr[component] {
            case "年": // 年
                _view?.text = String(format: "%04d年", yearStart + row)
            case "月", "日": // 月 日
                _view?.text = String(format: "%02d%@", row + 1, dateUnitArr[component])
            case "时", "分", "秒": // 时 分 秒
                _view?.text = String(format: "%02d%@", row, dateUnitArr[component])
            default:
                break
            }
        default:
            if pickerView == pickerOne {
                _view?.setText(pickerDataOne[component][row])
            }else if pickerView == pickerTwo {
                _view?.setText(pickerDataTwo[component][row])
            }
        }
        
        return _view!
    }
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        switch style {
        case .year:
            return 150
        case .year_month, .timeWithoutSecond:
            return 100
        case .year_month_day, .time:
            return 80
        case .allDate, .dateWithoutSecond:
            switch self.dateUnitArr[component] {
            case "年": // 年
                return 60
            default:
                return 35
            }
        default:
            var width: CGFloat = 30
            if pickerView == pickerOne {
                width = pickerDataOne[component].map { $0.size.width }.max() ?? 30
            }else if pickerView == pickerTwo {
                width = pickerDataTwo[component].map { $0.size.width }.max() ?? 30
            }
            return width
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == pickerOne {
            switch style {
            case .year, .year_month, .year_month_day, .allDate, .dateWithoutSecond, .time, .timeWithoutSecond:
                switch self.dateUnitArr[component] {
                case "年": // 年
                    self.dateComponents.year = yearStart + row
                    if dayIndex >= 0 {self.getDayArr(component: dayIndex)}
                case "月": // 月
                    self.dateComponents.month = row + 1
                    if dayIndex >= 0 {self.getDayArr(component: dayIndex)}
                case "日": // 日
                    self.dateComponents.day = row + 1
                case "时": // 时
                    self.dateComponents.hour = row
                case "分": // 分
                    self.dateComponents.minute = row
                case "秒": // 秒
                    self.dateComponents.second = row
                default:
                    break
                }
            default:
                break
            }
        }else if pickerView == pickerTwo {
            switch style {
            case .year, .year_month, .year_month_day, .allDate, .dateWithoutSecond, .time, .timeWithoutSecond:
                switch self.dateUnitArr[component] {
                case "年": // 年
                    self.otherDateComponents.year = yearStart + row
                    if dayIndex >= 0 {self.getOtherDayArr(component: dayIndex)}
                case "月": // 月
                    self.otherDateComponents.month = row + 1
                    if dayIndex >= 0 {self.getOtherDayArr(component: dayIndex)}
                case "日": // 日
                    self.otherDateComponents.day = row + 1
                case "时": // 时
                    self.otherDateComponents.hour = row
                case "分": // 分
                    self.otherDateComponents.minute = row
                case "秒": // 秒
                    self.otherDateComponents.second = row
                default:
                    break
                }
            default:
                break
            }
        }
    }
    
    private func getDayArr(component: Int) {
        if let year = dateComponents.year, let month = dateComponents.month {
            switch month {
            case 1, 3, 5, 7, 8, 10, 12:
                self.dayCount = 31
            case 4, 6 , 9, 11:
                self.dayCount = 30
            case 2:
                if year % 400 == 0 { // 世纪年能被400整除为闰年
                    self.dayCount = 29
                }else if year % 4 == 0 && year % 100 != 0 { // 普通年能被4整除且不能被100整除
                    self.dayCount = 29
                }else {
                    self.dayCount = 28
                }
            default:
                break
            }
        }
        
        self.dateCountArr[component] = dayCount
        self.pickerOne.reloadComponent(component)
    }
    
    private func getOtherDayArr(component: Int) {
        if let year = otherDateComponents.year, let month = otherDateComponents.month {
            switch month {
            case 1, 3, 5, 7, 8, 10, 12:
                self.dayCount = 31
            case 4, 6 , 9, 11:
                self.dayCount = 30
            case 2:
                if year % 400 == 0 { // 世纪年能被400整除为闰年
                    self.dayCount = 29
                }else if year % 4 == 0 && year % 100 != 0 { // 普通年能被4整除且不能被100整除
                    self.dayCount = 29
                }else {
                    self.dayCount = 28
                }
            default:
                break
            }
        }
        
        self.otherDateCountArr[component] = dayCount
        self.pickerTwo.reloadComponent(component)
    }
}
