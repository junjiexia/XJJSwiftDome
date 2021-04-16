//
//  UIImage+Extension.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/2/23.
//

import Foundation
import UIKit

extension UIImage {
    func apply(_ color: UIColor, _ imageView: UIImageView) -> UIImage? {
        imageView.tintColor = color
        return self.withRenderingMode(.alwaysTemplate)
    }
}

//MARK: - 画图片
extension UIImage {
    /*
        * 返回按钮图片
     */
    static var backArrow: UIImage? {
        get {
            return UIImage.drawBackArrow()
        }
    }
    
    class func drawBackArrow(size: CGSize? = nil,
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
    static var mutFourGaps: UIImage? {
        get {
            return UIImage.drawMutFourGaps()
        }
    }
    
    class func drawMutFourGaps(size: CGSize? = nil,
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
    static var mutSixGaps: UIImage? {
        get {
            return drawMutSixGaps()
        }
    }
    
    class func drawMutSixGaps(size: CGSize? = nil,
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
    static var spanner: UIImage? {
        get {
            return drawSpanner()
        }
    }
    
    class func drawSpanner(size: CGSize? = nil,
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
}
