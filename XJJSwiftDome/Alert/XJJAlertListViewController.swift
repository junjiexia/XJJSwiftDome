//
//  XJJAlertListViewController.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/7/30.
//

import UIKit

class XJJAlertListViewController: XJJBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initData()
        self.initUI()
        
        self.page = .alertList
        // Do any additional setup after loading the view.
    }
    
    private var table: UITableView!
    
    private var titleData: [XJJText] = []
    private var tableData: [[XJJText]] = []
    
    private func initData() {
        if let text = XJJThemeConfig.share.theme.page_text[.title] {
            self.titleData = [
                text.newText("中心按钮弹框"),
                text.newText("中心状态弹框"),
                text.newText("中心输入弹框"),
                text.newText("中心等待弹框"),
                text.newText("选择器弹框"),
                text.newText("列表弹框"),
                text.newText("系统选择弹框")
            ]
        }
        
        if let text = XJJThemeConfig.share.theme.page_text[.randomText] {
            self.tableData = [
                [
                    text.newText("无按钮提示"),
                    text.newText("单按钮提示"),
                    text.newText("双按钮提示"),
                    text.newText("三按钮提示"),
                    text.newText("三按钮三角提示"),
                    text.newText("三按钮竖列提示"),
                    text.newText("六按钮竖列提示"),
                    text.newText("七按钮两列提示"),
                    text.newText("图片按钮提示")
                ],
                [
                    text.newText("状态提示"),
                    text.newText("无标题状态提示"),
                    text.newText("图片状态提示")
                ],
                [
                    text.newText("单个输入弹框"),
                    text.newText("登录"),
                    text.newText("文本输入弹框")
                ],
                [
                    text.newText("等待弹框"),
                    text.newText("带文字的等待弹框")
                ],
                [
                    text.newText("日期选择器弹框"),
                    text.newText("双日期选择器弹框"),
                    text.newText("选择器弹框"),
                    text.newText("双选择器弹框")
                ],
                [
                    text.newText("单选列表弹框"),
                    text.newText("多选列表弹框"),
                    text.newText("单选树形列表弹框"),
                    text.newText("多选树形列表弹框")
                ],
                [
                    text.newText("底部系统Sheet")
                ]
            ]
        }
    }
    
    private func initUI() {
        self.initTable()
    }

    private func initTable() {
        self.table = UITableView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - XJJUIConfig.nav_h - XJJUIConfig.bottom_h), style: .plain)
        self.view.addSubview(table)
    
        self.table.delegate = self
        self.table.dataSource = self
        self.table.setupStyle()
        self.table.setupLine()
    }
    
}

extension XJJAlertListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableData[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "CELL")
            cell?.selectionStyle = .none
        }
        
        let text = self.tableData[indexPath.section][indexPath.row]
        cell?.textLabel?.setText(text)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 44))
        view.backgroundColor = tableView.backgroundColor
        
        let label = UILabel(frame: CGRect(x: 16, y: 0, width: view.bounds.width - 32, height: view.bounds.height))
        view.addSubview(label)
        
        let text = titleData[section]
        label.setText(text)
        
        return view
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let text = self.tableData[indexPath.section][indexPath.row]
        
        switch text.text {
        case "无按钮提示":
            XJJAlert.prompt(title: XJJText(text.text, color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 17), alignment: .center),
                            message: XJJText("这是一个弹框提示信息！！！", color: UIColor.orange, font: text.font))
        case "单按钮提示":
            XJJAlert.prompt(title: XJJText(text.text, color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 17), alignment: .center),
                            message: XJJText(random: "这是一个弹框提示信息！！！", factor: XJJText.TRandom()),
                            actions: [
                                XJJText("确定", color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 16))])
            { item in
                print("点击按钮 - ", item.actionText)
            }
        case "双按钮提示":
            XJJAlert.prompt(title: XJJText(text.text, color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 17), alignment: .center),
                            message: XJJText(random: "这是一个弹框提示信息！！！", factor: XJJText.TRandom()),
                            actions: [
                                XJJText("取消", color: UIColor.red, font: UIFont.boldSystemFont(ofSize: 16)),
                                XJJText("确定", color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 16))])
            { item in
                print("点击按钮 - ", item.actionText)
            }
        case "三按钮提示":
            XJJAlert.prompt(title: XJJText(text.text, color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 17), alignment: .center),
                            message: XJJText(random: "这是一个弹框提示信息！！！", factor: XJJText.TRandom()),
                            actions: [
                                XJJText("取消", color: UIColor.red, font: UIFont.boldSystemFont(ofSize: 16)),
                                XJJText("确定", color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 16)),
                                XJJText("拷贝", color: UIColor.orange, font: UIFont.boldSystemFont(ofSize: 16))])
            { item in
                print("点击按钮 - ", item.actionText)
            }
        case "三按钮三角提示":
            XJJAlert.prompt(title: XJJText(text.text, color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 17), alignment: .center),
                            message: XJJText(random: "这是一个弹框提示信息！！！", factor: XJJText.TRandom()),
                            actions: [
                                XJJText("取消", color: UIColor.red, font: UIFont.boldSystemFont(ofSize: 16)),
                                XJJText("确定", color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 16)),
                                XJJText("拷贝", color: UIColor.orange, font: UIFont.boldSystemFont(ofSize: 16))],
                            actionStyle: .H2)
            { item in
                print("点击按钮 - ", item.actionText)
            }
        case "三按钮竖列提示":
            XJJAlert.prompt(title: XJJText(text.text, color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 17), alignment: .center),
                            message: XJJText(random: "这是一个弹框提示信息！！！", factor: XJJText.TRandom()),
                            actions: [
                                XJJText("取消", color: UIColor.red, font: UIFont.boldSystemFont(ofSize: 16)),
                                XJJText("确定", color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 16)),
                                XJJText("拷贝", color: UIColor.orange, font: UIFont.boldSystemFont(ofSize: 16))],
                            actionStyle: .V)
            { item in
                print("点击按钮 - ", item.actionText)
            }
        case "六按钮竖列提示":
            XJJAlert.prompt(title: XJJText(text.text, color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 17), alignment: .center),
                            message: XJJText(random: "这是一个弹框提示信息！！！", factor: XJJText.TRandom()),
                            actions: [
                                XJJText("取消", color: UIColor.red, font: UIFont.boldSystemFont(ofSize: 16)),
                                XJJText("手机", color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 16)),
                                XJJText("电脑", color: UIColor.orange, font: UIFont.boldSystemFont(ofSize: 16)),
                                XJJText("笔记", color: UIColor.orange, font: UIFont.boldSystemFont(ofSize: 16)),
                                XJJText("摄像机", color: UIColor.orange, font: UIFont.boldSystemFont(ofSize: 16)),
                                XJJText("投影仪", color: UIColor.orange, font: UIFont.boldSystemFont(ofSize: 16))],
                            actionStyle: .V)
            { item in
                print("点击按钮 - ", item.actionText)
            }
        case "七按钮两列提示":
            XJJAlert.prompt(title: XJJText(text.text, color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 17), alignment: .center),
                            message: XJJText(random: "放假了！！！大家都怎么安排自己的时间呢？以下几款，哪一款才是你的最佳选项呢？", factor: XJJText.TRandom()),
                            actions: [
                                XJJText("旅游", color: UIColor.orange, font: UIFont.boldSystemFont(ofSize: 16)),
                                XJJText("睡觉", color: UIColor.orange, font: UIFont.boldSystemFont(ofSize: 16)),
                                XJJText("上网", color: UIColor.orange, font: UIFont.boldSystemFont(ofSize: 16)),
                                XJJText("看书", color: UIColor.orange, font: UIFont.boldSystemFont(ofSize: 16)),
                                XJJText("听歌", color: UIColor.orange, font: UIFont.boldSystemFont(ofSize: 16)),
                                XJJText("登山", color: UIColor.orange, font: UIFont.boldSystemFont(ofSize: 16)),
                                XJJText("游泳", color: UIColor.orange, font: UIFont.boldSystemFont(ofSize: 16))],
                            actionStyle: .H2)
            { item in
                print("点击按钮 - ", item.actionText)
            }
        case "图片按钮提示":
            XJJAlert.prompt(title: XJJText(text.text, color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 17), alignment: .center),
                            message: XJJText("这是一个带有图片的弹框提示信息！！！", color: UIColor.orange, font: text.font),
                            headerImage: XJJImages.image01,
                            actions: [
                                XJJText("取消", color: UIColor.red, font: UIFont.boldSystemFont(ofSize: 16)),
                                XJJText("确定", color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 16))])
            { item in
                print("点击按钮 - ", item.actionText)
            }
        case "状态提示":
            XJJAlert.statePrompt(title: XJJText(text.text, color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 17), alignment: .center),
                                 message: XJJText("这是一个状态弹框提示信息！！！", color: UIColor.orange, font: text.font))
        case "无标题状态提示":
            XJJAlert.statePrompt(title: nil, message: XJJText("这是一个状态弹框提示信息！！！", color: UIColor.orange, font: text.font, alignment: .center))
        case "图片状态提示":
            XJJAlert.statePrompt(title: XJJText(text.text, color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 17), alignment: .center),
                                 message: XJJText("这是一个状态弹框提示信息！！！", color: UIColor.orange, font: text.font),
                                 headerImage: XJJImages.image01)
        case "单个输入弹框":
            XJJAlert.textField(title: XJJText(text.text, color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 17), alignment: .center),
                               message: XJJText("这是一个输入弹框提示信息！！！", color: UIColor.orange, font: text.font),
                               textFields: [XJJTextFieldItem(normal: XJJText("", placeholder: "请输入"))],
                               headerImage: XJJImages.image01,
                               actions: [XJJText("取消", color: UIColor.red, font: UIFont.boldSystemFont(ofSize: 16)), XJJText("确定", color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 16))])
            { item in
                print("点击按钮 - ", item.actionText, "输入文本: ", item.textFieldItems.first?.inputText ?? "")
            }
        case "登录":
            XJJAlert.textField(title: XJJText(text.text, color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 17), alignment: .center),
                               message: XJJText("这是一个登录弹框提示信息！！！", color: UIColor.orange, font: text.font),
                               textFields: [
                                XJJTextFieldItem(title: XJJText("用户名: "), text: XJJText("", placeholder: "请输入")),
                                XJJTextFieldItem(title: XJJText("密码: "), text: XJJText("", placeholder: "请输入"))
                               ],
                               headerImage: XJJImages.image01,
                               actions: [XJJText("取消", color: UIColor.red, font: UIFont.boldSystemFont(ofSize: 16)), XJJText("注册", color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 16)), XJJText("登录", color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 16))])
            { item in
                print("点击按钮 - ", item.actionText, "用户名: ", item.textFieldItems[0].inputText, "密码: ", item.textFieldItems[1].inputText)
            }
        case "文本输入弹框":
            XJJAlert.textView(title: XJJText(text.text, color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 17), alignment: .center),
                              message: XJJText("这是一个文本输入弹框提示信息！！！", color: UIColor.orange, font: text.font),
                              textViewItem: XJJTextViewItem(title: XJJText("信息:"), text: XJJText("", placeholder: "请输入")),
                              headerImage: XJJImages.image01,
                              actions: [XJJText("取消", color: UIColor.red, font: UIFont.boldSystemFont(ofSize: 16)), XJJText("确定", color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 16))])
            { item in
                print("点击按钮 - ", item.actionText, "信息: ", item.textViewItem?.inputText ?? "")
            }
        case "等待弹框":
            XJJAlert.waitStart()
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                XJJAlert.waitStop()
            }
        case "带文字的等待弹框":
            XJJAlert.waitStart(text: XJJText("正在加载...", color: UIColor.white))
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                XJJAlert.waitStop()
            }
        case "日期选择器弹框":
            XJJAlert.datePicker(style: .year_month_day) { dateComponents in
                print("日期选择 - ", dateComponents.description)
            }
        case "双日期选择器弹框":
            let first = Date.components(ofString: "2021-07-05", format: "yyyy-MM-dd")
            let second = Date.components(ofString: "2021-08-05", format: "yyyy-MM-dd")
            XJJAlert.doubleDatePicker(style: .allDate, firstDate: first, secondDate: second) { first, second in
                print("双日期选择 - ", first.description, second.description)
            }
        case "选择器弹框":
            XJJAlert.picker(titleText: XJJText("周期选择"),
                            pickerArr: [
                                [
                                    XJJText("一天"),
                                    XJJText("三天"),
                                    XJJText("一周"),
                                    XJJText("一月")
                                ],
                                [
                                    XJJText("一次"),
                                    XJJText("三次"),
                                    XJJText("五次")
                                ]
                            ])
            { result in
                print("周期选择 - ", result.map { $0.text })
            }
        case "双选择器弹框":
            let current = [XJJText("晴天")]
            let other = [XJJText("打球")]
            XJJAlert.doublePicker(titleText: XJJText("天气选择"),
                                  pickerArr: [
                                    [
                                        XJJText("阴天"),
                                        XJJText("晴天"),
                                        XJJText("多云"),
                                        XJJText("小雨"),
                                        XJJText("暴雨"),
                                        XJJText("小雪"),
                                        XJJText("暴雪")
                                    ]
                                  ],
                                  otherTitleText: XJJText("活动选择"),
                                  otherPickerArr: [
                                    [
                                        XJJText("下棋"),
                                        XJJText("开会"),
                                        XJJText("打球"),
                                        XJJText("登山"),
                                        XJJText("钓鱼"),
                                        XJJText("游湖"),
                                        XJJText("打游戏")
                                    ]
                                  ],
                                  currentValue: current,
                                  otherValue: other)
            { first, second in
                print("天气选择 - ", first.map { $0.text }, "活动选择 - ", second.map { $0.text })
            }
        case "单选列表弹框":
            XJJAlert.table(title: XJJText(text.text, color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 17), alignment: .center),
                           tableData: [
                            XJJAlertTree(list: 0, text: XJJText("米糕", color: UIColor.orange), isSelect: true),
                            XJJAlertTree(list: 1, text: XJJText("桂花糕", color: UIColor.orange), isSelect: false),
                            XJJAlertTree(list: 2, text: XJJText("奶油蛋糕", color: UIColor.orange), isSelect: false),
                            XJJAlertTree(list: 3, text: XJJText("培根煎蛋", color: UIColor.orange), isSelect: false)
                           ],
                           message: XJJText("以下四种食物，你最喜欢哪种呢？"))
            { item in
                print("我喜欢 - ", item.text?.text ?? "")
            }
        case "多选列表弹框":
            XJJAlert.multipleTable(title: XJJText(text.text, color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 17), alignment: .center),
                                   tableData: [
                                    XJJAlertTree(list: 0, text: XJJText("米糕", color: UIColor.orange), isSelect: true),
                                    XJJAlertTree(list: 1, text: XJJText("桂花糕", color: UIColor.orange), isSelect: false),
                                    XJJAlertTree(list: 2, text: XJJText("奶油蛋糕", color: UIColor.orange), isSelect: false),
                                    XJJAlertTree(list: 3, text: XJJText("培根煎蛋", color: UIColor.orange), isSelect: false)
                                   ],
                                   message: XJJText("以下四种食物，你最喜欢哪种呢？"))
            { items in
                print("我喜欢 - ", items.map { $0.text?.text ?? "" }.joined(separator: ","))
            }
        case "单选树形列表弹框":
            XJJAlert.tree(title: XJJText(text.text, color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 17), alignment: .center),
                          tableData: [
                            XJJAlertTree(tree: 0,
                                         parentId: -1,
                                         text: XJJText("生物", color: UIColor.orange),
                                         deep: 0,
                                         children: [
                                            XJJAlertTree(tree: 1,
                                                         parentId: 0,
                                                         text: XJJText("动物", color: UIColor.orange),
                                                         deep: 1,
                                                         children: [
                                                            XJJAlertTree(tree: 3,
                                                                         parentId: 1,
                                                                         text: XJJText("哺乳类", color: UIColor.orange),
                                                                         deep: 2,
                                                                         children: [
                                                                            
                                                                         ],
                                                                         isSelect: false),
                                                            XJJAlertTree(tree: 4,
                                                                         parentId: 1,
                                                                         text: XJJText("鱼类", color: UIColor.orange),
                                                                         deep: 2,
                                                                         children: [
                                                                            
                                                                         ],
                                                                         isSelect: false),
                                                            XJJAlertTree(tree: 5,
                                                                         parentId: 1,
                                                                         text: XJJText("鸟类", color: UIColor.orange),
                                                                         deep: 2,
                                                                         children: [
                                                                            
                                                                         ],
                                                                         isSelect: false),
                                                            XJJAlertTree(tree: 6,
                                                                         parentId: 1,
                                                                         text: XJJText("两栖类", color: UIColor.orange),
                                                                         deep: 2,
                                                                         children: [
                                                                            
                                                                         ],
                                                                         isSelect: false),
                                                            XJJAlertTree(tree: 7,
                                                                         parentId: 1,
                                                                         text: XJJText("昆虫类", color: UIColor.orange),
                                                                         deep: 2,
                                                                         children: [
                                                                            
                                                                         ],
                                                                         isSelect: false)
                                                         ],
                                                         isSelect: false),
                                            XJJAlertTree(tree: 2,
                                                         parentId: 0,
                                                         text: XJJText("植物", color: UIColor.orange),
                                                         deep: 1,
                                                         children: [
                                                            XJJAlertTree(tree: 8,
                                                                         parentId: 2,
                                                                         text: XJJText("被子植物", color: UIColor.orange),
                                                                         deep: 2,
                                                                         children: [
                                                                            
                                                                         ],
                                                                         isSelect: false),
                                                            XJJAlertTree(tree: 9,
                                                                         parentId: 2,
                                                                         text: XJJText("裸子植物", color: UIColor.orange),
                                                                         deep: 2,
                                                                         children: [
                                                                            
                                                                         ],
                                                                         isSelect: false),
                                                            XJJAlertTree(tree: 10,
                                                                         parentId: 2,
                                                                         text: XJJText("苔藓植物", color: UIColor.orange),
                                                                         deep: 2,
                                                                         children: [
                                                                            
                                                                         ],
                                                                         isSelect: false),
                                                            XJJAlertTree(tree: 11,
                                                                         parentId: 2,
                                                                         text: XJJText("蕨类植物", color: UIColor.orange),
                                                                         deep: 2,
                                                                         children: [
                                                                            
                                                                         ],
                                                                         isSelect: false),
                                                            XJJAlertTree(tree: 12,
                                                                         parentId: 2,
                                                                         text: XJJText("藻类植物", color: UIColor.orange),
                                                                         deep: 2,
                                                                         children: [
                                                                            
                                                                         ],
                                                                         isSelect: false),
                                                         ],
                                                         isSelect: false)
                                         ],
                                         isSelect: false)
                          ],
                          message: XJJText("这是一个树形结构！！"))
            { item in
                print("我选择 - ", item.text?.text ?? "")
            }
        case "多选树形列表弹框":
            XJJAlert.multipleTree(title: XJJText(text.text, color: UIColor.blue, font: UIFont.boldSystemFont(ofSize: 17), alignment: .center),
                                  tableData: [
                                    XJJAlertTree(tree: 0,
                                                 parentId: -1,
                                                 text: XJJText("生物", color: UIColor.orange),
                                                 deep: 0,
                                                 children: [
                                                    XJJAlertTree(tree: 1,
                                                                 parentId: 0,
                                                                 text: XJJText("动物", color: UIColor.orange),
                                                                 deep: 1,
                                                                 children: [
                                                                    XJJAlertTree(tree: 3,
                                                                                 parentId: 1,
                                                                                 text: XJJText("哺乳类", color: UIColor.orange),
                                                                                 deep: 2,
                                                                                 children: [
                                                                                    
                                                                                 ],
                                                                                 isSelect: false),
                                                                    XJJAlertTree(tree: 4,
                                                                                 parentId: 1,
                                                                                 text: XJJText("鱼类", color: UIColor.orange),
                                                                                 deep: 2,
                                                                                 children: [
                                                                                    
                                                                                 ],
                                                                                 isSelect: false),
                                                                    XJJAlertTree(tree: 5,
                                                                                 parentId: 1,
                                                                                 text: XJJText("鸟类", color: UIColor.orange),
                                                                                 deep: 2,
                                                                                 children: [
                                                                                    
                                                                                 ],
                                                                                 isSelect: false),
                                                                    XJJAlertTree(tree: 6,
                                                                                 parentId: 1,
                                                                                 text: XJJText("两栖类", color: UIColor.orange),
                                                                                 deep: 2,
                                                                                 children: [
                                                                                    
                                                                                 ],
                                                                                 isSelect: false),
                                                                    XJJAlertTree(tree: 7,
                                                                                 parentId: 1,
                                                                                 text: XJJText("昆虫类", color: UIColor.orange),
                                                                                 deep: 2,
                                                                                 children: [
                                                                                    
                                                                                 ],
                                                                                 isSelect: false)
                                                                 ],
                                                                 isSelect: false),
                                                    XJJAlertTree(tree: 2,
                                                                 parentId: 0,
                                                                 text: XJJText("植物", color: UIColor.orange),
                                                                 deep: 1,
                                                                 children: [
                                                                    XJJAlertTree(tree: 8,
                                                                                 parentId: 2,
                                                                                 text: XJJText("被子植物", color: UIColor.orange),
                                                                                 deep: 2,
                                                                                 children: [
                                                                                    
                                                                                 ],
                                                                                 isSelect: false),
                                                                    XJJAlertTree(tree: 9,
                                                                                 parentId: 2,
                                                                                 text: XJJText("裸子植物", color: UIColor.orange),
                                                                                 deep: 2,
                                                                                 children: [
                                                                                    
                                                                                 ],
                                                                                 isSelect: false),
                                                                    XJJAlertTree(tree: 10,
                                                                                 parentId: 2,
                                                                                 text: XJJText("苔藓植物", color: UIColor.orange),
                                                                                 deep: 2,
                                                                                 children: [
                                                                                    
                                                                                 ],
                                                                                 isSelect: false),
                                                                    XJJAlertTree(tree: 11,
                                                                                 parentId: 2,
                                                                                 text: XJJText("蕨类植物", color: UIColor.orange),
                                                                                 deep: 2,
                                                                                 children: [
                                                                                    
                                                                                 ],
                                                                                 isSelect: false),
                                                                    XJJAlertTree(tree: 12,
                                                                                 parentId: 2,
                                                                                 text: XJJText("藻类植物", color: UIColor.orange),
                                                                                 deep: 2,
                                                                                 children: [
                                                                                    
                                                                                 ],
                                                                                 isSelect: false),
                                                                 ],
                                                                 isSelect: false)
                                                 ],
                                                 isSelect: false)
                                  ],
                                  message: XJJText("这是一个树形结构！！"))
            { items in
                print("我选择 - ", items.map { $0.text?.text ?? "" }.joined(separator: ","))
            }
        case "底部系统Sheet":
            XJJAlert.sheet(on: self,
                           XJJText(text.text),
                           XJJText("以下四种食物，你最喜欢哪种呢？"),
                           [
                            XJJText("米糕", color: UIColor.orange),
                            XJJText("桂花糕", color: UIColor.orange),
                            XJJText("奶油蛋糕", color: UIColor.orange),
                            XJJText("培根煎蛋", color: UIColor.orange)])
            { index, t in
                print(text.text, "-点击-", " \(index) ", t)
            }
        default:
            break
        }
    }
}
