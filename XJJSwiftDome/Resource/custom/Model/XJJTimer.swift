//
//  XJJTimer.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/5.
//

/*
 注意：
 1. 定时器应减少创建，尽量使用 时间间隔倍数 或者 变量 进行控制多个定时器任务
 2. 注意一个定时器对应一个线程，线程可以不创建定时器，但定时器必须依赖一个线程
 3. 使用 start 方法创建时，每个时间间隔调用方法 timerUpdate
 4. 不用了，一定要关闭
 */

import Foundation

class XJJTimer {
    
    var interval: Int = 1 /// 定时器时间间隔
    
    private var wTimer: DispatchSourceTimer!
    
    init() { // 初始化一些变量
        
    }
    
    func start() { // 创建、启动
        let queue = DispatchQueue.global()
        self.wTimer = DispatchSource.makeTimerSource(flags: [], queue: queue)
        self.wTimer.schedule(deadline: .now() + 1.0, repeating: .seconds(interval))
        self.wTimer.setEventHandler {[weak self] in
            guard let sself = self else {return}
            sself.timerUpdate()
        }
        self.wTimer.resume()
    }
    
    func timerUpdate() { // 定时器时间间隔内执行任务
        print("...")
    }
    
    func activate() {  // 恢复活跃
        if self.wTimer != nil {
            if #available(iOS 10.0, *) {
                self.wTimer.activate()
            }else {
                self.wTimer.resume()
            }
        }
    }
    
    func suspend() {  // 暂停挂起
        if self.wTimer != nil {
            self.wTimer.suspend()
        }
    }
    
    func stop() {  // 停止
        if self.wTimer != nil {
            self.wTimer.cancel()
            self.wTimer = nil
        }
    }
}
