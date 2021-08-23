//
//  XJJDrawingBoardView.swift
//  XJJSwiftDome
//
//  Created by Levy on 2021/8/12.
//

import UIKit

class XJJDrawingBoardView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var board: XJJDrawingImageView!
    private var toolBar: XJJDrawingToolView!
    
    private func initUI() {
        self.backgroundColor = UIColor.white
        
        self.initBoard()
        self.initTool()
    }
    
    private func initBoard() {
        self.board = XJJDrawingImageView()
        self.addSubview(board)
    }
    
    private func initTool() {
        self.toolBar = XJJDrawingToolView()
        self.addSubview(toolBar)
    }
    
}
