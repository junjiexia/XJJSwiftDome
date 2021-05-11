//
//  UIImage+Extension.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/23.
//

import Foundation
import UIKit

extension UIImage {
    /* 单色图变换颜色
        * 临时设置单色图片颜色
     */
    public func apply(_ color: UIColor, _ imageView: UIImageView) -> UIImage? {
        imageView.tintColor = color
        return self.withRenderingMode(.alwaysTemplate)
    }
}

//MARK: - 画图片
extension UIImage {
    /*
        * 返回按钮图片
     */
    public static var backArrow: UIImage? {
        get {
            return UIImage.drawBackArrow()
        }
    }
    
    public class func drawBackArrow(size: CGSize? = nil,
                                    strokeColor: UIColor? = nil,
                                    strokeWidth: CGFloat? = 1.5) -> UIImage?
    {
        let _size = size ?? CGSize(width: 25, height: 25)
        let _strokeColor = strokeColor?.cgColor ?? UIColor.black.cgColor
        
        let startPoint = CGPoint(x: _size.width / 3 * 2, y: _size.height / 5)
        let middlePoint = CGPoint(x: _size.width / 3, y: _size.height / 2)
        let endPoint = CGPoint(x: _size.width / 3 * 2, y: _size.height / 5 * 4)
        
        UIGraphicsBeginImageContextWithOptions(_size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setStrokeColor(_strokeColor)
        context?.setLineWidth(strokeWidth!)
        
        context?.move(to: startPoint)
        context?.addLine(to: middlePoint)
        context?.addLine(to: endPoint)
        context?.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /*
        * 设置图片（4缺口螺帽）
        * 90度分布，每个圆心间距相等
        * cScale: 中间圆半径比例 0 ~ 0.2
        * oScale: 外围圆弧半径比例 0 ~ 0.2
        * lScale: 圆心间距比例 0.3 ~ 0.5
     */
    public static var mutFourGaps: UIImage? {
        get {
            return UIImage.drawMutFourGaps()
        }
    }
    
    public class func drawMutFourGaps(size: CGSize? = nil,
                                      strokeColor: UIColor? = nil,
                                      strokeWidth: CGFloat? = 1.5,
                                      cScale: CGFloat? = 0.1,
                                      oScale: CGFloat? = 0.15,
                                      lScale: CGFloat? = 0.4) -> UIImage?
    {
        let _size = size ?? CGSize(width: 25, height: 25)
        let _strokeColor = strokeColor?.cgColor ?? UIColor.black.cgColor
        
        let length = min(_size.width, _size.height) * lScale! // 取短边的特定比例长度，作为圆心的间距
        let cRadius = min(_size.width, _size.height) * cScale! // 中间圆半径
        let oRadius = min(_size.width, _size.height) * oScale! // 外围圆弧半径
        let o_angle: CGFloat = CGFloat.pi / 3
        
        let center = CGPoint(x: _size.width / 2, y: _size.height / 2) // 中心圆圆心
        let t_center = CGPoint(x: center.x, y: center.y - length) // 上边圆弧圆心
        let b_center = CGPoint(x: center.x, y: center.y + length) // 下边圆弧圆心
        let l_center = CGPoint(x: center.x - length, y: center.y) // 左边圆弧圆心
        let r_center = CGPoint(x: center.x + length, y: center.y) // 右边圆弧圆心
        
        let tpl_point = CGPoint(x: t_center.x - oRadius * sin(o_angle), y: t_center.y + oRadius * cos(o_angle)) // 上边圆弧左边点
        let tpr_point = CGPoint(x: t_center.x + oRadius * sin(o_angle), y: t_center.y + oRadius * cos(o_angle)) // 上边圆弧右边点
        let bpl_point = CGPoint(x: b_center.x - oRadius * sin(o_angle), y: b_center.y - oRadius * cos(o_angle)) // 下边圆弧左边点
        let bpr_point = CGPoint(x: b_center.x + oRadius * sin(o_angle), y: b_center.y - oRadius * cos(o_angle)) // 下边圆弧右边点
        let lpt_point = CGPoint(x: l_center.x + oRadius * cos(o_angle), y: l_center.y - oRadius * sin(o_angle)) // 左边圆弧上边点
        let lpb_point = CGPoint(x: l_center.x + oRadius * cos(o_angle), y: l_center.y + oRadius * sin(o_angle)) // 左边圆弧下边点
        let rpt_point = CGPoint(x: r_center.x - oRadius * cos(o_angle), y: r_center.y - oRadius * sin(o_angle)) // 右边圆弧上边点
        let rpb_point = CGPoint(x: r_center.x - oRadius * cos(o_angle), y: r_center.y + oRadius * sin(o_angle)) // 右边圆弧下边点
        
        UIGraphicsBeginImageContextWithOptions(_size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setStrokeColor(_strokeColor)
        context?.setLineWidth(strokeWidth!)
        
        context?.addArc(center: center, radius: cRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false)
        
        context?.move(to: tpr_point)
        context?.addArc(center: t_center, radius: oRadius, startAngle: CGFloat.pi / 6, endAngle: CGFloat.pi / 6 * 5, clockwise: false)
        context?.move(to: tpl_point)
        context?.addLine(to: lpt_point)
        context?.addArc(center: l_center, radius: oRadius, startAngle: -CGFloat.pi / 3, endAngle: CGFloat.pi / 3, clockwise: false)
        context?.move(to: lpb_point)
        context?.addLine(to: bpl_point)
        context?.addArc(center: b_center, radius: oRadius, startAngle: CGFloat.pi / 6 * 7, endAngle: CGFloat.pi / 6 * 11, clockwise: false)
        context?.move(to: bpr_point)
        context?.addLine(to: rpb_point)
        context?.addArc(center: r_center, radius: oRadius, startAngle: CGFloat.pi / 3 * 2, endAngle: CGFloat.pi / 3 * 4, clockwise: false)
        context?.move(to: rpt_point)
        context?.addLine(to: tpr_point)
        context?.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /*
        * 设置图片（6缺口螺帽）
        * 60度分布，每个圆心间距相等
        * cScale: 中间圆半径比例 0 ~ 0.2
        * oScale: 外围圆弧半径比例 0 ~ 0.2
        * lScale: 圆心间距比例 0.3 ~ 0.5
     */
    public static var mutSixGaps: UIImage? {
        get {
            return drawMutSixGaps()
        }
    }
    
    public class func drawMutSixGaps(size: CGSize? = nil,
                                     strokeColor: UIColor? = nil,
                                     strokeWidth: CGFloat? = 1.5,
                                     cScale: CGFloat? = 0.1,
                                     oScale: CGFloat? = 0.15,
                                     lScale: CGFloat? = 0.4) -> UIImage?
    {
        let _size = size ?? CGSize(width: 25, height: 25)
        let _strokeColor = strokeColor?.cgColor ?? UIColor.black.cgColor
        
        let length = min(_size.width, _size.height) * lScale! // 取短边的特定比例长度，作为圆心的间距
        let cRadius = min(_size.width, _size.height) * cScale! // 中间圆半径
        let oRadius = min(_size.width, _size.height) * oScale! // 外围圆弧半径
        let l_angle: CGFloat = CGFloat.pi / 3 // 圆心分布角度
        let o_angle: CGFloat = CGFloat.pi / 3 // 外围弧度的一半
        
        let center = CGPoint(x: _size.width / 2, y: _size.height / 2) // 中心圆圆心
        let t_center = CGPoint(x: center.x, y: center.y - length) // 上边圆弧圆心
        let b_center = CGPoint(x: center.x, y: center.y + length) // 下边圆弧圆心
        let lt_center = CGPoint(x: center.x - length * sin(l_angle), y: center.y - length * cos(l_angle)) // 左上圆弧圆心
        let lb_center = CGPoint(x: center.x - length * sin(l_angle), y: center.y + length * cos(l_angle)) // 左下圆弧圆心
        let rt_center = CGPoint(x: center.x + length * sin(l_angle), y: center.y - length * cos(l_angle)) // 右上圆弧圆心
        let rb_center = CGPoint(x: center.x + length * sin(l_angle), y: center.y + length * cos(l_angle)) // 右下圆弧圆心
        
        let tpl_point = CGPoint(x: t_center.x - oRadius * sin(o_angle), y: t_center.y + oRadius * cos(o_angle)) // 上边圆弧左边点
        let tpr_point = CGPoint(x: t_center.x + oRadius * sin(o_angle), y: t_center.y + oRadius * cos(o_angle)) // 上边圆弧右边点
        let bpl_point = CGPoint(x: b_center.x - oRadius * sin(o_angle), y: b_center.y - oRadius * cos(o_angle)) // 下边圆弧左边点
        let bpr_point = CGPoint(x: b_center.x + oRadius * sin(o_angle), y: b_center.y - oRadius * cos(o_angle)) // 下边圆弧右边点
        let ltpt_point = CGPoint(x: lt_center.x + oRadius * sin(o_angle), y: lt_center.y - oRadius * cos(o_angle)) // 左上圆弧上边点
        let ltpb_point = CGPoint(x: lt_center.x, y: lt_center.y + oRadius) // 左上圆弧下边点
        let lbpt_point = CGPoint(x: lb_center.x, y: lb_center.y - oRadius) // 左下圆弧上边点
        let lbpb_point = CGPoint(x: lb_center.x + oRadius * sin(o_angle), y: lb_center.y + oRadius * cos(o_angle)) // 左下圆弧下边点
        let rtpt_point = CGPoint(x: rt_center.x - oRadius * sin(o_angle), y: rt_center.y - oRadius * cos(o_angle)) // 右上圆弧上边点
        let rtpb_point = CGPoint(x: rt_center.x, y: rt_center.y + oRadius) // 右上圆弧下边点
        let rbpt_point = CGPoint(x: rb_center.x, y: rb_center.y - oRadius) // 右下圆弧上边点
        let rbpb_point = CGPoint(x: rb_center.x - oRadius * sin(o_angle), y: rb_center.y + oRadius * cos(o_angle)) // 右下圆弧下边点
        
        UIGraphicsBeginImageContextWithOptions(_size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setStrokeColor(_strokeColor)
        context?.setLineWidth(strokeWidth!)
        
        context?.addArc(center: center, radius: cRadius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false)
        
        context?.move(to: tpr_point)
        context?.addArc(center: t_center, radius: oRadius, startAngle: CGFloat.pi / 6, endAngle: CGFloat.pi / 6 * 5, clockwise: false)
        context?.move(to: tpl_point)
        context?.addLine(to: ltpt_point)
        context?.addArc(center: lt_center, radius: oRadius, startAngle: -CGFloat.pi / 6, endAngle: CGFloat.pi / 2, clockwise: false)
        context?.move(to: ltpb_point)
        context?.addLine(to: lbpt_point)
        context?.addArc(center: lb_center, radius: oRadius, startAngle: CGFloat.pi / 2 * 3, endAngle: CGFloat.pi / 6, clockwise: false)
        context?.move(to: lbpb_point)
        context?.addLine(to: bpl_point)
        context?.addArc(center: b_center, radius: oRadius, startAngle: CGFloat.pi / 6 * 7, endAngle: CGFloat.pi / 6 * 11, clockwise: false)
        context?.move(to: bpr_point)
        context?.addLine(to: rbpb_point)
        context?.addArc(center: rb_center, radius: oRadius, startAngle: CGFloat.pi / 6 * 5, endAngle: CGFloat.pi / 2 * 3, clockwise: false)
        context?.move(to: rbpt_point)
        context?.addLine(to: rtpb_point)
        context?.addArc(center: rt_center, radius: oRadius, startAngle: CGFloat.pi / 2, endAngle: CGFloat.pi / 6 * 7, clockwise: false)
        context?.move(to: rtpt_point)
        context?.addLine(to: tpr_point)
        context?.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /*
        * 设置图片（扳手）
        * bigSizeScale：大圆尺寸比例
        * smallSizeScale：小圆尺寸比例
        * inclination：水平倾斜度
        * lengthScale：扳手长度比例
        * bigLineScale：大圆中间横线长度比例
        * smallLineScale：小圆中间横线长度比例
        * 如下情况设置，扳手的形状趋于正常
            * 设置大圆尺寸与小圆尺寸的比例为 3 : 2
            * 设置大圆尺寸与大圆中间横线长度比例 比值为 2 : 1
            * 设置小圆尺寸与小圆中间横线长度比例 比值为 2 : 1
     */
    public static var spanner: UIImage? {
        get {
            return drawSpanner()
        }
    }
    
    public class func drawSpanner(size: CGSize? = nil,
                                  strokeColor: UIColor? = nil,
                                  strokeWidth: CGFloat? = 1.5,
                                  bigSizeScale: CGFloat? = 0.3,
                                  smallSizeScale: CGFloat? = 0.2,
                                  bigLineScale: CGFloat? = 0.15,
                                  smallLineScale: CGFloat? = 0.1,
                                  inclination: CGFloat? = nil,
                                  lengthScale: CGFloat? = nil) -> UIImage?
    {
        let _size = size ?? CGSize(width: 25, height: 25)
        let _strokeColor = strokeColor?.cgColor ?? UIColor.black.cgColor
        
        let min_length = min(_size.width, _size.height)
        let bc_radius = min_length * bigSizeScale! / 2
        let sc_radius = min_length * smallSizeScale! / 2
        let bc_radian = CGFloat.pi / 3 * 2 // 大圆圆弧弧度
        let _inclination = inclination ?? CGFloat.pi / 3 // 整体水平倾斜度
        let scale: CGFloat = lengthScale ?? 0.6 // 长度比例
        
        let bc_center = CGPoint(x: _size.width / 3 * 2, y: _size.height / 4)
        let sc_center = CGPoint(x: bc_center.x - min_length * scale * cos(_inclination), y: bc_center.y + min_length * scale * sin(_inclination))
        
        let bc_line_length: CGFloat = min_length * bigLineScale! // 大圆中间横线长度
        let sc_line_length: CGFloat = min_length * smallLineScale! // 小圆中间横线长度
        
        let bct_point = CGPoint(x: bc_center.x - bc_line_length / 2 * sin(_inclination), y: bc_center.y - bc_line_length / 2 * cos(_inclination)) // 大圆内部上方点
        let bcb_point = CGPoint(x: bc_center.x + bc_line_length / 2 * sin(_inclination), y: bc_center.y + bc_line_length / 2 * cos(_inclination)) // 大圆内部下方点
        let bc_length = sqrt(bc_radius * bc_radius - (bc_line_length / 2) * (bc_line_length / 2)) // 大圆坐标斜边
        let bctt_point = CGPoint(x: bct_point.x + bc_length * cos(_inclination), y: bct_point.y - bc_length * sin(_inclination)) // 大圆外部上方点
        let bcbb_point = CGPoint(x: bcb_point.x + bc_length * cos(_inclination), y: bcb_point.y - bc_length * sin(_inclination)) // 大圆外部下方点
        let bclt_radian = CGFloat.pi / 2 - (bc_radian - acos(bc_line_length / 2 / bc_radius)) // 大圆连接处到圆心 与 倾斜线 的弧度
        let bclt_point = CGPoint(x: bc_center.x - bc_radius * cos(abs(_inclination - bclt_radian)), y: bc_center.y + bc_radius * sin(abs(_inclination - bclt_radian))) // 大圆上方连接点
        let bclb_point = CGPoint(x: bc_center.x - bc_radius * cos(_inclination + bclt_radian), y: bc_center.y + bc_radius * sin(_inclination + bclt_radian)) // 大圆下方连接点
        
        let sct_point = CGPoint(x: sc_center.x - sc_line_length / 2 * sin(_inclination), y: sc_center.y - sc_line_length / 2 * cos(_inclination)) // 小圆内部上方点
        let scb_point = CGPoint(x: sc_center.x + sc_line_length / 2 * sin(_inclination), y: sc_center.y + sc_line_length / 2 * cos(_inclination)) // 小圆内部下方点
        let sc_length = sqrt(sc_radius * sc_radius - (sc_line_length / 2) * (bc_line_length / 2)) // 小圆坐标斜边
        let sctt_point = CGPoint(x: sct_point.x - sc_length * cos(_inclination), y: sct_point.y + sc_length * sin(_inclination)) // 小圆外部上方点
        let scbb_point = CGPoint(x: scb_point.x - sc_length * cos(_inclination), y: scb_point.y + sc_length * sin(_inclination)) // 小圆外部下方点
        let sclt_radian = abs(asin(bc_line_length / 2 / sc_radius)) // 小圆连接处到圆心 与 倾斜线 的弧度
        let sclt_point = CGPoint(x: sc_center.x + sc_radius * cos(_inclination + sclt_radian), y: sc_center.y - sc_radius * sin(_inclination + sclt_radian)) // 小圆上方连接点
        let sclb_point = CGPoint(x: sc_center.x + sc_radius * cos(abs(sclt_radian - _inclination)), y: sc_center.y - sc_radius * sin(abs(sclt_radian - _inclination))) // 小圆下方连接点
        let sctt_radian = acos(sc_length / sc_radius) // 小圆外部上方点到圆心 与 倾斜线 的弧度
        let sc_radian = CGFloat.pi - sclt_radian - sctt_radian // 小圆圆弧弧度
        
        UIGraphicsBeginImageContextWithOptions(_size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setStrokeColor(_strokeColor)
        context?.setLineWidth(strokeWidth!)
        
        context?.move(to: bcb_point)
        context?.addLine(to: bct_point)
        context?.addLine(to: bctt_point)
        context?.move(to: bctt_point)
        context?.addArc(center: bc_center, radius: bc_radius, startAngle: CGFloat.pi * 2 - _inclination - sctt_radian, endAngle: CGFloat.pi * 2 - _inclination - sctt_radian - bc_radian, clockwise: true)
        context?.move(to: bclt_point)
        context?.addLine(to: sclt_point)
        context?.move(to: sclt_point)
        context?.addArc(center: sc_center, radius: sc_radius, startAngle: CGFloat.pi * 2 - _inclination - sclt_radian, endAngle: CGFloat.pi * 2 - _inclination - sclt_radian - sc_radian, clockwise: true)
        context?.move(to: sctt_point)
        context?.addLine(to: sct_point)
        context?.addLine(to: scb_point)
        context?.addLine(to: scbb_point)
        context?.move(to: scbb_point)
        context?.addArc(center: sc_center, radius: sc_radius, startAngle: CGFloat.pi - _inclination - sctt_radian, endAngle: CGFloat.pi - _inclination - sctt_radian - sc_radian, clockwise: true)
        context?.move(to: sclb_point)
        context?.addLine(to: bclb_point)
        context?.move(to: bclb_point)
        context?.addArc(center: bc_center, radius: bc_radius, startAngle: CGFloat.pi - _inclination - bclt_radian, endAngle: CGFloat.pi - _inclination - bclt_radian - bc_radian, clockwise: true)
        context?.move(to: bcbb_point)
        context?.addLine(to: bcb_point)
        context?.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /*
        * 闭锁 🔐
     */
    public static var lockOfClose: UIImage? {
        get {
            return drawLockOfClose()
        }
    }
    
    public class func drawLockOfClose(size: CGSize? = nil,
                                      strokeColor: UIColor? = nil,
                                      latchFillColor: UIColor? = nil,
                                      bodyFillColor: UIColor? = nil,
                                      strokeWidth: CGFloat? = 1) -> UIImage?
    {
        let _size = size ?? CGSize(width: 25, height: 25)
        let _strokeColor = strokeColor?.cgColor ?? UIColor.black.cgColor
        let _bodyFillColor = bodyFillColor?.cgColor ?? UIColor.gray.cgColor
        let _latchFillColor = latchFillColor?.cgColor ?? UIColor.lightGray.cgColor
        
        let center = CGPoint(x: _size.width / 2, y: _size.height / 2)
        let b_width = _size.width * 0.5 // 锁身宽度
        let b_height = _size.height * 0.4 // 锁身高度
        let l_height = _size.height * 0.1 // 锁扣伸直部分高度
        let lo_radius = _size.width * 0.4 / 2 // 锁扣外圈半径
        let li_radius = _size.width * 0.25 / 2 // 锁扣里圈半径
        let l_center = CGPoint(x: center.x, y: center.y - l_height) // 锁扣半圆圆心
        
        let tl_point = CGPoint(x: center.x - b_width / 2, y: center.y) // 锁身左上点
        let tr_point = CGPoint(x: center.x + b_width / 2, y: center.y) // 锁身右上点
        let bl_point = CGPoint(x: tl_point.x, y: tl_point.y + b_height) // 锁身左下点
        let br_point = CGPoint(x: tr_point.x, y: tr_point.y + b_height) // 锁身右下点
        
        let lol_point = CGPoint(x: center.x - lo_radius, y: center.y) // 锁扣外圈左边点
        let lor_point = CGPoint(x: center.x + lo_radius, y: center.y) // 锁扣外圈右边点
        let lil_point = CGPoint(x: center.x - li_radius, y: center.y) // 锁扣里圈左边点
        let lir_point = CGPoint(x: center.x + li_radius, y: center.y) // 锁扣里圈右边点
        let llol_point = CGPoint(x: lol_point.x, y: lol_point.y - l_height) // 锁扣外圈左边向上延伸点
        let llor_point = CGPoint(x: lor_point.x, y: lor_point.y - l_height) // 锁扣外圈右边向上延伸点
        let llil_point = CGPoint(x: lil_point.x, y: lil_point.y - l_height) // 锁扣里圈左边向上延伸点
        let llir_point = CGPoint(x: lir_point.x, y: lir_point.y - l_height) // 锁扣里圈右边向上延伸点
        
        UIGraphicsBeginImageContextWithOptions(_size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setStrokeColor(_strokeColor)
        context?.setLineWidth(strokeWidth!)
        
        context?.setFillColor(_bodyFillColor)
        context?.move(to: tl_point)
        context?.addLine(to: tr_point)
        context?.addLine(to: br_point)
        context?.addLine(to: bl_point)
        context?.closePath()
        context?.fillPath()
        
        context?.setFillColor(_latchFillColor)
        context?.move(to: lol_point)
        context?.addLine(to: llol_point)
        context?.move(to: llol_point)
        context?.addArc(center: l_center, radius: lo_radius, startAngle: CGFloat.pi, endAngle: 0, clockwise: false)
        context?.move(to: llor_point)
        context?.addLine(to: lor_point)
        context?.addLine(to: lir_point)
        context?.addLine(to: llir_point)
        context?.move(to: llir_point)
        context?.addArc(center: l_center, radius: li_radius, startAngle: 0, endAngle: CGFloat.pi, clockwise: true)
        context?.move(to: llil_point)
        context?.addLine(to: lil_point)
        context?.addLine(to: lol_point)
        context?.addLine(to: llol_point)
        context?.fillPath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /*
        * 开锁 🔓
     */
    public static var lockOfOpen: UIImage? {
        get {
            return drawLockOfOpen()
        }
    }
    
    public class func drawLockOfOpen(size: CGSize? = nil,
                                     strokeColor: UIColor? = nil,
                                     latchFillColor: UIColor? = nil,
                                     bodyFillColor: UIColor? = nil,
                                     strokeWidth: CGFloat? = 1,
                                     openRight: Bool? = false) -> UIImage?
    {
        let _size = size ?? CGSize(width: 25, height: 25)
        let _strokeColor = strokeColor?.cgColor ?? UIColor.black.cgColor
        let _bodyFillColor = bodyFillColor?.cgColor ?? UIColor.gray.cgColor
        let _latchFillColor = latchFillColor?.cgColor ?? UIColor.lightGray.cgColor
        
        let center = CGPoint(x: _size.width / 2, y: _size.height / 2)
        let b_width = _size.width * 0.5 // 锁身宽度
        let b_height = _size.height * 0.4 // 锁身高度
        let l_height = _size.height * 0.1 // 锁扣伸直部分高度
        let ll_height = _size.height * 0.05 // 开锁后两端差值
        let lo_radius = _size.width * 0.4 / 2 // 锁扣外圈半径
        let li_radius = _size.width * 0.25 / 2 // 锁扣里圈半径
        let l_center = openRight! ? CGPoint(x: center.x + lo_radius, y: center.y - l_height - ll_height) : CGPoint(x: center.x, y: center.y - l_height - ll_height) // 锁扣半圆圆心
        
        let borber_h = (b_width - li_radius * 2) / 2 // 锁扣内侧到边界的距离
        let tl_point = openRight! ? CGPoint(x: center.x - (b_width - borber_h), y: center.y) : CGPoint(x: center.x - b_width / 2, y: center.y) // 锁身左上点
        let tr_point = openRight! ? CGPoint(x: center.x + borber_h, y: center.y) : CGPoint(x: center.x + b_width / 2, y: center.y) // 锁身右上点
        let bl_point = CGPoint(x: tl_point.x, y: tl_point.y + b_height) // 锁身左下点
        let br_point = CGPoint(x: tr_point.x, y: tr_point.y + b_height) // 锁身右下点
        
        let lol_point = openRight! ? CGPoint(x: center.x, y: center.y) : CGPoint(x: center.x - lo_radius, y: center.y - ll_height) // 锁扣外圈左边点
        let lor_point = openRight! ? CGPoint(x: l_center.x + lo_radius, y: center.y - ll_height) : CGPoint(x: center.x + lo_radius, y: center.y) // 锁扣外圈右边点
        let lil_point = openRight! ? CGPoint(x: center.x + (lo_radius - li_radius), y: center.y) : CGPoint(x: center.x - li_radius, y: center.y - ll_height) // 锁扣里圈左边点
        let lir_point = openRight! ? CGPoint(x: l_center.x + li_radius, y: center.y - ll_height) : CGPoint(x: center.x + li_radius, y: center.y) // 锁扣里圈右边点
        let llol_point = CGPoint(x: lol_point.x, y: lol_point.y - l_height - (openRight! ? ll_height : 0)) // 锁扣外圈左边向上延伸点
        let llor_point = CGPoint(x: lor_point.x, y: lor_point.y - l_height - (openRight! ? 0 : ll_height)) // 锁扣外圈右边向上延伸点
        let llil_point = CGPoint(x: lil_point.x, y: lil_point.y - l_height - (openRight! ? ll_height : 0)) // 锁扣里圈左边向上延伸点
        let llir_point = CGPoint(x: lir_point.x, y: lir_point.y - l_height - (openRight! ? 0 : ll_height)) // 锁扣里圈右边向上延伸点
        
        
        UIGraphicsBeginImageContextWithOptions(_size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setStrokeColor(_strokeColor)
        context?.setLineWidth(strokeWidth!)
        
        context?.setFillColor(_bodyFillColor)
        context?.move(to: tl_point)
        context?.addLine(to: tr_point)
        context?.addLine(to: br_point)
        context?.addLine(to: bl_point)
        context?.closePath()
        context?.fillPath()
        
        context?.setFillColor(_latchFillColor)
        context?.move(to: lol_point)
        context?.addLine(to: llol_point)
        context?.move(to: llol_point)
        context?.addArc(center: l_center, radius: lo_radius, startAngle: CGFloat.pi, endAngle: 0, clockwise: false)
        context?.move(to: llor_point)
        context?.addLine(to: lor_point)
        context?.addLine(to: lir_point)
        context?.addLine(to: llir_point)
        context?.move(to: llir_point)
        context?.addArc(center: l_center, radius: li_radius, startAngle: 0, endAngle: CGFloat.pi, clockwise: true)
        context?.move(to: llil_point)
        context?.addLine(to: lil_point)
        context?.addLine(to: lol_point)
        context?.addLine(to: llol_point)
        context?.fillPath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /*
        * 列表菜单（三道横线）
            *
                - ----
                - ----
                - ----
            *
     */
    public static var listMenuThreeLines: UIImage? {
        get {
            return drawListMenuThreeLines()
        }
    }
    
    public class func drawListMenuThreeLines(size: CGSize? = nil,
                                             strokeColor: UIColor? = nil,
                                             strokeWidth: CGFloat? = 3) -> UIImage?
    {
        let _size = size ?? CGSize(width: 25, height: 25)
        let _strokeColor = strokeColor?.cgColor ?? UIColor.black.cgColor
        
        let short_length = _size.width * 0.1 // 短线长度
        let long_length = _size.width * 0.4 // 长线长度
        let merge_h = _size.width * 0.1 // 短线与长线之间的间隔
        let first_x = (_size.width - short_length - merge_h - long_length) / 2
        
        let fsl_point = CGPoint(x: first_x, y: _size.height / 4) // 第一行短线左边点
        let fsr_point = CGPoint(x: fsl_point.x + short_length, y: _size.height / 4) // 第一行短线右边点
        let fll_point = CGPoint(x: fsr_point.x + merge_h, y: _size.height / 4) // 第一行长线左边点
        let flr_point = CGPoint(x: fll_point.x + long_length, y: _size.height / 4) // 第一行长线右边点
        
        let ssl_point = CGPoint(x: first_x, y: _size.height / 2) // 第一行短线左边点
        let ssr_point = CGPoint(x: ssl_point.x + short_length, y: _size.height / 2) // 第二行短线右边点
        let sll_point = CGPoint(x: ssr_point.x + merge_h, y: _size.height / 2) // 第二行长线左边点
        let slr_point = CGPoint(x: sll_point.x + long_length, y: _size.height / 2) // 第二行长线右边点
        
        let tsl_point = CGPoint(x: first_x, y: _size.height / 4 * 3) // 第三行短线左边点
        let tsr_point = CGPoint(x: tsl_point.x + short_length, y: _size.height / 4 * 3) // 第三行短线右边点
        let tll_point = CGPoint(x: tsr_point.x + merge_h, y: _size.height / 4 * 3) // 第三行长线左边点
        let tlr_point = CGPoint(x: tll_point.x + long_length, y: _size.height / 4 * 3) // 第三行长线右边点
        
        UIGraphicsBeginImageContextWithOptions(_size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setStrokeColor(_strokeColor)
        context?.setLineWidth(strokeWidth!)

        context?.addLines(between: [fsl_point, fsr_point])
        context?.addLines(between: [fll_point, flr_point])
        context?.addLines(between: [ssl_point, ssr_point])
        context?.addLines(between: [sll_point, slr_point])
        context?.addLines(between: [tsl_point, tsr_point])
        context?.addLines(between: [tll_point, tlr_point])
        context?.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /*
        * 全屏
     */
    public static var fullScreen: UIImage? {
        get {
            return drawFullScreen()
        }
    }
    
    public static func drawFullScreen(size: CGSize? = nil,
                                      strokeColor: UIColor? = nil,
                                      strokeWidth: CGFloat? = 1.5) -> UIImage?
    {
        let _size = size ?? CGSize(width: 25, height: 25)
        let _strokeColor = strokeColor?.cgColor ?? UIColor.black.cgColor
        
        let center = CGPoint(x: _size.width / 2, y: _size.height / 2)
        let min_length = min(_size.width, _size.height)
        let short_length = min_length * 0.25
        let long_length = min_length * 0.4
        let arrow_length = min_length * 0.3
        
        let tl_point = CGPoint(x: center.x - long_length, y: center.y - long_length) // 左上箭头箭尖
        let tlb_point = CGPoint(x: tl_point.x, y: tl_point.y + arrow_length) // 左上箭头下方点
        let tlr_point = CGPoint(x: tl_point.x + arrow_length, y: tl_point.y) // 左上箭头右方点
        let tr_point = CGPoint(x: center.x + long_length, y: center.y - long_length) // 右上箭头箭尖
        let trl_point = CGPoint(x: tr_point.x - arrow_length, y: tr_point.y) // 右上箭头左方点
        let trb_point = CGPoint(x: tr_point.x, y: tr_point.y + arrow_length) // 右上箭头下方点
        let bl_point = CGPoint(x: center.x - long_length, y: center.y + long_length) // 左下箭头箭尖
        let blt_point = CGPoint(x: bl_point.x, y: bl_point.y - arrow_length) // 左下箭头上方点
        let blr_point = CGPoint(x: bl_point.x + arrow_length, y: bl_point.y) // 左下箭头右方点
        let br_point = CGPoint(x: center.x + long_length, y: center.y + long_length) // 右下箭头箭尖
        let brt_point = CGPoint(x: br_point.x, y: br_point.y - arrow_length) // 右下箭头上方点
        let brl_point = CGPoint(x: br_point.x - arrow_length, y: br_point.y) // 右下箭头左方点
        
        let otl_point = CGPoint(x: center.x - short_length, y: center.y - short_length) // 中间方框左上点
        let otr_point = CGPoint(x: center.x + short_length, y: center.y - short_length) // 中间方框右上点
        let obl_point = CGPoint(x: center.x - short_length, y: center.y + short_length) // 中间方框左下点
        let obr_point = CGPoint(x: center.x + short_length, y: center.y + short_length) // 中间方框右下点
        
        UIGraphicsBeginImageContextWithOptions(_size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setStrokeColor(_strokeColor)
        context?.setLineWidth(strokeWidth!)
        
        context?.move(to: tlb_point)
        context?.addLine(to: tl_point)
        context?.addLine(to: tlr_point)
        
        context?.move(to: trl_point)
        context?.addLine(to: tr_point)
        context?.addLine(to: trb_point)
        
        context?.move(to: brt_point)
        context?.addLine(to: br_point)
        context?.addLine(to: brl_point)
        
        context?.move(to: blr_point)
        context?.addLine(to: bl_point)
        context?.addLine(to: blt_point)
        
        context?.move(to: otl_point)
        context?.addLine(to: otr_point)
        context?.addLine(to: obr_point)
        context?.addLine(to: obl_point)
        context?.closePath()
        context?.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /*
        * 取消全屏
     */
    public static var cancelFullScreen: UIImage? {
        get {
            return drawCancelFullScreen()
        }
    }
    
    public static func drawCancelFullScreen(size: CGSize? = nil,
                                            strokeColor: UIColor? = nil,
                                            strokeWidth: CGFloat? = 1.5) -> UIImage?
    {
        let _size = size ?? CGSize(width: 25, height: 25)
        let _strokeColor = strokeColor?.cgColor ?? UIColor.black.cgColor
        
        let center = CGPoint(x: _size.width / 2, y: _size.height / 2)
        let min_length = min(_size.width, _size.height)
        let long_length = min_length * 0.15
        let arrow_length = min_length * 0.2
        
        let tl_point = CGPoint(x: center.x - long_length, y: center.y - long_length) // 左上箭头箭尖
        let tlt_point = CGPoint(x: tl_point.x, y: tl_point.y - arrow_length) // 左上箭头上方点
        let tll_point = CGPoint(x: tl_point.x - arrow_length, y: tl_point.y) // 左上箭头左方点
        let tr_point = CGPoint(x: center.x + long_length, y: center.y - long_length) // 右上箭头箭尖
        let trt_point = CGPoint(x: tr_point.x, y: tr_point.y - arrow_length) // 右上箭头上方点
        let trr_point = CGPoint(x: tr_point.x + arrow_length, y: tr_point.y) // 右上箭头右方点
        let bl_point = CGPoint(x: center.x - long_length, y: center.y + long_length) // 左下箭头箭尖
        let bll_point = CGPoint(x: bl_point.x - arrow_length, y: bl_point.y) // 左下箭头左方点
        let blb_point = CGPoint(x: bl_point.x, y: bl_point.y + arrow_length) // 左下箭头下方点
        let br_point = CGPoint(x: center.x + long_length, y: center.y + long_length) // 右下箭头箭尖
        let brb_point = CGPoint(x: br_point.x, y: br_point.y + arrow_length) // 右下箭头下方点
        let brr_point = CGPoint(x: br_point.x + arrow_length, y: br_point.y) // 右下箭头右方点
        
        UIGraphicsBeginImageContextWithOptions(_size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setStrokeColor(_strokeColor)
        context?.setLineWidth(strokeWidth!)
        
        context?.move(to: tll_point)
        context?.addLine(to: tl_point)
        context?.addLine(to: tlt_point)
        
        context?.move(to: trt_point)
        context?.addLine(to: tr_point)
        context?.addLine(to: trr_point)
        
        context?.move(to: brr_point)
        context?.addLine(to: br_point)
        context?.addLine(to: brb_point)
        
        context?.move(to: blb_point)
        context?.addLine(to: bl_point)
        context?.addLine(to: bll_point)
        context?.strokePath()
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /*
        * 播放
     */
    public static var play: UIImage? {
        get {
            return drawPlay()
        }
    }
    
    public static func drawPlay(size: CGSize? = nil,
                                strokeColor: UIColor? = nil,
                                fillColor: UIColor? = nil,
                                strokeWidth: CGFloat? = 1,
                                scale: CGFloat? = 1,
                                hasRound: Bool? = false) -> UIImage?
    {
        let _size = size ?? CGSize(width: 25, height: 25)
        let _strokeColor = strokeColor?.cgColor ?? UIColor.black.cgColor
        let _fillColor = fillColor?.cgColor ?? UIColor.black.cgColor
        
        let center = CGPoint(x: _size.width / 2, y: _size.height / 2)
        let min_length = min(_size.width, _size.height)
        let radius = min_length * (hasRound! ? 0.25 : 0.35) * scale!
        let radian = CGFloat.pi / 3
        let round_radius = min_length * 0.4 * scale!
        
        let lt_point = CGPoint(x: center.x - radius * cos(radian), y: center.y - radius * sin(radian))
        let lb_point = CGPoint(x: center.x - radius * cos(radian), y: center.y + radius * sin(radian))
        let r_point = CGPoint(x: center.x + radius, y: center.y)
        
        UIGraphicsBeginImageContextWithOptions(_size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setStrokeColor(_strokeColor)
        context?.setLineWidth(strokeWidth!)
        context?.setFillColor(_fillColor)
        
        context?.move(to: lt_point)
        context?.addLine(to: lb_point)
        context?.addLine(to: r_point)
        context?.closePath()
        context?.fillPath()
        
        if hasRound == true {
            context?.addArc(center: center, radius: round_radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false)
            context?.strokePath()
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /*
        * 暂停
     */
    public static var pause: UIImage? {
        get {
            return drawPause()
        }
    }
    
    public static func drawPause(size: CGSize? = nil,
                                 strokeColor: UIColor? = nil,
                                 strokeWidth: CGFloat? = 1,
                                 scale: CGFloat? = 1,
                                 hasRound: Bool? = false) -> UIImage?
    {
        let _size = size ?? CGSize(width: 25, height: 25)
        let _strokeColor = strokeColor?.cgColor ?? UIColor.black.cgColor
        
        let center = CGPoint(x: _size.width / 2, y: _size.height / 2)
        let min_length = min(_size.width, _size.height)
        let radius = min_length * (hasRound! ? 0.25 : 0.35) * scale!
        let radian = CGFloat.pi / 3
        let round_radius = min_length * 0.4 * scale!
        
        let lt_point = CGPoint(x: center.x - radius * cos(radian), y: center.y - radius * sin(radian))
        let lb_point = CGPoint(x: center.x - radius * cos(radian), y: center.y + radius * sin(radian))
        let rt_point = CGPoint(x: center.x + radius * cos(radian), y: center.y - radius * sin(radian))
        let rb_point = CGPoint(x: center.x + radius * cos(radian), y: center.y + radius * sin(radian))
        
        UIGraphicsBeginImageContextWithOptions(_size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setStrokeColor(_strokeColor)
        context?.setLineWidth(strokeWidth! * min_length * 0.1)
        
        context?.move(to: lt_point)
        context?.addLine(to: lb_point)
        context?.move(to: rt_point)
        context?.addLine(to: rb_point)
        context?.strokePath()
        
        if hasRound == true {
            context?.setLineWidth(strokeWidth!)
            context?.addArc(center: center, radius: round_radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false)
            context?.strokePath()
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
    
    /*
        * 进度条按钮
     */
    public static var progressBarButton: UIImage? {
        get {
            return drawProgressBarButton()
        }
    }
    
    // rate: 0 ~ 1，圆形的比例，1 为整个圆
    public static func drawProgressBarButton(size: CGSize? = nil,
                                             strokeColor: UIColor? = nil,
                                             strokeWidth: CGFloat? = 1,
                                             fillColor: UIColor? = nil,
                                             rate: CGFloat? = 1,
                                             scale: CGFloat? = 1) -> UIImage?
    {
        let _size = size ?? CGSize(width: 25, height: 25)
        let _strokeColor = strokeColor?.cgColor ?? UIColor.black.cgColor
        let _fillColor = fillColor?.cgColor ?? UIColor.black.cgColor
        
        let center = CGPoint(x: _size.width / 2, y: _size.height / 2)
        let min_length = min(_size.width, _size.height)
        let radius = min_length * 0.35 * scale!
        
        UIGraphicsBeginImageContextWithOptions(_size, false, UIScreen.main.scale)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.setStrokeColor(_strokeColor)
        context?.setLineWidth(strokeWidth!)
        context?.setFillColor(_fillColor)
        
        if rate == 1 {
            context?.addArc(center: center, radius: radius, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: false)
            context?.fillPath()
        }else {
            let radian = CGFloat.pi * rate! * 0.5
            
            let lt_point = CGPoint(x: center.x - radius * cos(radian), y: center.y - radius * sin(radian))
            let lb_point = CGPoint(x: center.x - radius * cos(radian), y: center.y + radius * sin(radian))
            let rt_point = CGPoint(x: center.x + radius * cos(radian), y: center.y - radius * sin(radian))
            let rb_point = CGPoint(x: center.x + radius * cos(radian), y: center.y + radius * sin(radian))
            
            context?.move(to: lt_point)
            context?.addArc(center: center, radius: radius, startAngle: CGFloat.pi / 2 + radian, endAngle: CGFloat.pi / 2 - radian, clockwise: true)
            context?.move(to: rt_point)
            context?.addLine(to: rb_point)
            context?.move(to: rb_point)
            context?.addArc(center: center, radius: radius, startAngle: CGFloat.pi / 2 * 3 + radian, endAngle: CGFloat.pi / 2 * 3 - radian, clockwise: true)
            context?.move(to: lb_point)
            context?.addLine(to: lt_point)
            context?.fillPath()
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}

//MARK: - 位图应用（bitmap）
extension UIImage {
    /* CGContext(data: T##UnsafeMutableRawPointer?, width: T##Int, height: T##Int, bitsPerComponent: T##Int, bytesPerRow: T##Int, space: T##CGColorSpace, bitmapInfo: T##UInt32)
        * 创建位图上下文
        * data - 要渲染的绘制内存的地址指针，大小应该为（一行占用字节数 * height）个字节
        * width、height - 上下文长宽
        * bitsPerComponent - 每个通道占用字节数（一般分为：红色通道，绿色通道，蓝色通道，透明通道）
        * bytesPerRow - 每一行占用字节数，一般设为0，系统会自动计算
        * space - 色彩空间 常用的三种
            * CGColorSpaceCreateDeviceRGB() - 依赖于设备的RGB颜色空间（红色，绿色和蓝色）
            * CGColorSpaceCreateDeviceGray() - 依赖于设备的灰度颜色空间（黑色到白色）
            * CGColorSpaceCreateDeviceCMYK() - 依赖于设备的CMYK颜色空间（青色，品红色，黄色和黑色）
        * bitmapInfo - 上下文配置（位图像素布局）
            * CGImageByteOrderInfo - 代表字节顺序，采用大端还是小端，以及数据单位宽度
                * kCGImageByteOrderMask
                * kCGImageByteOrderDefault - 默认
                * kCGImageByteOrder16Little - 16位小端
                * kCGImageByteOrder32Little - 32位小端
                * kCGImageByteOrder16Big - 16位大端
                * kCGImageByteOrder32Big - 32位大端
                **** iOS 一般采用 32 位小端模式，用 orderDefault 就好 ****
            * CGImageAlphaInfo - 对于透明通道的设置
                * kCGImageAlphaNone - 不包含透明度
                * kCGImageAlphaPremultipliedLast - 预乘、透明度分量在低位
                * kCGImageAlphaPremultipliedFirst - 预乘、透明度分量在高位
                * kCGImageAlphaLast - 不预乘、透明度分量在低位
                * kCGImageAlphaFirst - 不预乘、透明度分量在高位
                * kCGImageAlphaNoneSkipLast - 忽略透明度分量、透明度分量在低位
                * kCGImageAlphaNoneSkipFirst - 忽略透明度分量、透明度分量在高位
                * kCGImageAlphaOnly - 只包含透明度
                **** 预乘：每个颜色分量乘以 alpha 的值，可以加速图片的渲染（渲染时，每个颜色分量需要乘以alpha） ****
            * floatComponents - 是否有浮点数，有就加上这个值（.floatComponents），没有就不加
        ****
            * 没有用到的值：bitsPerPixel - 色彩深度，表示每个像素点占用位数
                * 8 位灰度（只有透明度：A8）<ALPHA_8> - bitsPerPixel 为 8
                * 16 位色（R5+G6+R5）<RGB_565> - bitsPerPixel 为 16（5+6+5）
                * 32 位色（A8+R8+G8+B8）<ARGB_8888> - bitsPerPixel 为 32（8+8+8+8）
                * 64 位色（R16+G16+B16+A16 但使用半精度减少一半储存空间）用于宽色域或HDR <RGBA_F16> - bitsPerPixel 为 64（16+16+16+16）
                ****
     */
    
    /* 反向蒙版图片
        * 获取图片透明度（非0即1），反转图片透明度，用于制作反向蒙版
        * 如果需要获取数据 data，就必须填写 bytesPerRow（每行字节数）
        * data 数据位数，由每像素字节数决定
        * 每像素字节数（bitsPerComponent * 通道数） -- 例：bitsPerComponent = 8 时， 'rgba or argb' = 4 * 8   /   'a' = 1 * 8   /   'rgb' = 3 * 8
        * 每行字节数必须是每像素字节数的倍数
     */
    var negationImage: UIImage? {
        get {
            return negationImageCreate()
        }
    }
    
    public func negationImageCreate() -> UIImage? {
        guard let _cgImage = self.cgImage else {return nil}
        let size = self.size
        
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.alphaOnly.rawValue)
        let bytesPerRow = Int(size.width) * 1
        var data = Array<UInt8>(repeating: 0, count: bytesPerRow * Int(size.height))
        
        let context = CGContext(data: &data, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: bytesPerRow, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context?.draw(_cgImage, in: CGRect(origin: CGPoint.zero, size: size))
        //print(context ?? "no context!", "\ndata: ", data)
        
        for y in 0..<Int(size.height) {
            for x in 0..<Int(size.width) {
                let char = data[y * bytesPerRow + x]
                let temp = 255 - char
                data[y * bytesPerRow + x] = temp
            }
        }
        
        //print(context ?? "no context!", "\ndata: ", data)
 
        guard let image = context?.makeImage() else {return nil}
        
        return UIImage(cgImage: image)
    }
    
    /* 灰度图片
        * 使用系统颜色空间设置 CGColorSpaceCreateDeviceGray
        * 还有另一种做法，就是每一个像素点都进行灰度换算，三原色大致权重比 R：G：B = 3：6：1
            * 浮点算法：Gray = R*0.3+G*0.59+B*0.11
            * 整数方法：Gray =(R*30+G*59+B*11)/100
            * 移位方法：Gray =(R*77+G*151+B*28)>>8
            * 平均值法：Gray =（R+G+B）/3
            * 仅取绿色：Gray = G
     */
    var grayImage: UIImage? {
        get {
            return grayImageCreate()
        }
    }
    
    public func grayImageCreate() -> UIImage? {
        guard let _cgImage = self.cgImage else {return nil}
        let size = self.size
        
        let colorSpace: CGColorSpace = CGColorSpaceCreateDeviceGray()
        let bitmapInfo = CGImageAlphaInfo.none.rawValue
        let context = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: 8, bytesPerRow: 0, space: colorSpace, bitmapInfo: bitmapInfo)
                
        context?.draw(_cgImage, in: CGRect(origin: CGPoint.zero, size: size))
        guard let image = context?.makeImage() else {return nil}
        
        return UIImage(cgImage: image)
    }
}
