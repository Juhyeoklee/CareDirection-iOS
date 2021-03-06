//
//  ChartView.swift
//  CareDirection
//
//  Created by 안재은 on 30/12/2019.
//  Copyright © 2019 SwiftHelloWorld. All rights reserved.
//

import Foundation
import Macaw
import UIKit


class ChartView: MacawView {
    //static let lastFiveShows = createDummyData()
    
    static var ChartList : [MainChart] = []
    static let maxValue = 100
    static let maxValueLineHeight = 100
    static let lineWidth: Double = 550
    
    static var chartList : [Chart] = []
    
    static let dataDivisor = Double(maxValue/maxValueLineHeight)
    //static let adjustData: [Double] = ChartList.map({$0.viewCount / dataDivisor})
    static var animations : [Animation] = []
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(node: ChartView.createChart(), coder: aDecoder)
        
        backgroundColor = .clear
    }


    private static func createChart() -> Group {
        var items : [Node] = addYAxisItems() + addXAxisItems()
        items.append(createBar())
        return Group(contents: items, place: .identity)
    }

    private static func addYAxisItems() -> [Node] {
        
        let maxLines = 2
        //let lineInterval = Int(maxValue/maxLines)
        let yAxisHeight: Double = 100
        let lineSpacing: Double = 30
        
        var newNodes: [Node] = []
        
        for i in 1...maxLines {
            let y = yAxisHeight - (Double(i) * lineSpacing)
            let valueLine = Line(x1: -20, y1: y, x2: lineWidth, y2: y).stroke(fill: Color.white.with(a: 0.10))
            let valueText = Text(text: "상한 섭취량", align: .max, baseline: .mid, place: .move(dx: -10, dy:y))
            valueText.fill = Color.white
            
            newNodes.append(valueLine)
            newNodes.append(valueText)
        }
        return newNodes
    }

    private static func addXAxisItems() -> [Node] {
        let chartBaseY: Double = 200
        var newNodes: [Node] = []
        
        //print(adjustData.count)
        
        createDummyData()
        
        print(ChartList.count)
        
        for i in 1...ChartList.count {
            let x = (Double(i) * 50)
            let valueText = Text(text: ChartList[i-1].nutrient_name, align: .mid, baseline: .mid, place: .move(dx: x, dy: chartBaseY + 15))
            valueText.fill = Color.black
            
            newNodes.append(valueText)
        }
        let xAxis = Line(x1: 0, y1: chartBaseY, x2: lineWidth, y2: chartBaseY).stroke(fill: Color.white.with(a: 0.25))
        newNodes.append(xAxis)
        
        return newNodes
    }
    
    static var palette = [0xffabab,0xffabab,0xb5e0e4, 0xb5e0e4, 0xb5e0e4,  0xb5e0e4, 0xb5e0e4, 0xb5e0e4, 0xb5e0e4,0xb5e0e4,0xffabab].map { val in Color(val: val)}
    
    
    private static func createBar() -> Group {
        
        createDummyData()
        
        //palette = createPalette.map { val in Color(val: val) }
        
        let items = ChartList.map { _ in Group() }
        
        print(ChartList)
        
        
        
        animations = items.enumerated().map { (i: Int, item: Group) in
            item.contentsVar.animation(delay: Double(i) * 0.1) { t in
                let height = Double(ChartList[i].nutrient_percent + 10) * t
                let rect = RoundRect(rect:Rect(x: Double(i) * 50 + 25, y: 200 - height, w: 30, h: height), rx: 5, ry: 0)
                let fill = LinearGradient(degree: 90, from: palette[i], to: palette[i].with(a: 1))
                return [rect.fill(with: fill)]
            }
        }
        return items.group()
    }
    
    static func playAnimations() {
        animations.combine().play()
    }
    
    static func createDummyData() {

        let one = MainChart(nutrient_name: "비타민A", nutrient_percent: 12)
        let two = MainChart(nutrient_name: "비타민B2", nutrient_percent: 12)
        let three = MainChart(nutrient_name: "비타민C", nutrient_percent: 12)
        let four = MainChart(nutrient_name: "비타민D", nutrient_percent: 12)
        let five = MainChart(nutrient_name: "비타민E", nutrient_percent: 12)
        let six = MainChart(nutrient_name: "칼슘", nutrient_percent: 12)
        let seven = MainChart(nutrient_name: "칼륨", nutrient_percent: 12)
        let eight = MainChart(nutrient_name: "셀레늄", nutrient_percent: 12)
        let nine = MainChart(nutrient_name: "철분", nutrient_percent: 12)
        let ten = MainChart(nutrient_name: "염산", nutrient_percent: 12)
        let eleven = MainChart(nutrient_name: "마그네슘", nutrient_percent: 12)

        ChartList = [one, two, three, four, five, six, seven, eight, nine, ten, eleven]
        
        ChartService.shared.showMainChart() {
            
            //[weak self]
            
            data in
            print(data)
            
            //guard let `self` = self else { return }
            
            switch data {
            case .success(let res):
                print("in chart view connection success")
                self.ChartList = res as! [MainChart]
                
                for i in 0...10 {
                    if self.ChartList[i].nutrient_percent > 100 || self.ChartList[i].nutrient_percent < 30 {
                        self.palette[i] = Color(val: 0xffabab)
                    } else {
                        self.palette[i] = Color(val: 0xb5e0e4)
                    }
                }
                
            case .requestErr(let message):
                //self.simpleAlert(title: "차트 정보 받아오기 실패", message: "\(message)")
                print("\(message)")
            case .pathErr:
                 print(".pathErr")
            case .serverErr:
                print(".serverErr")
            case .networkFail:
                print("네트워크 오류")
            case .dbErr:
                print("db 오류")
            }
            
        }
    }
}

