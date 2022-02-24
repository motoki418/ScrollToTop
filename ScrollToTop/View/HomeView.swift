//
//  HomeView.swift
//  ScrollToTop
//
//  Created by nakamura motoki on 2022/02/23.
//

import SwiftUI

struct HomeView: View {
    // ↑ボタンを表示する処理に使う
    @State private var scrollViewOffset: CGFloat = 0
    
    // Getting Start Offset and eliminating from current offset so that we will get exact offset...
    //
    @State private var startOffset: CGFloat = 0
    
    var body: some View {
        // Scroll To Top Function...
        // with the help of ScrollViewRieader...
        ScrollViewReader{ proxyReader in   // ScrollViewProxyインスタンスを取得
            ScrollView(.vertical, showsIndicators: false){
                VStack(spacing: 25){
                    ForEach(1...30, id: \.self){ index in
                        // Sample Row View...
                        HStack(spacing: 15){
                            // サークルの上に1~30までの番号を重ねて表示
                            ZStack{
                                Circle()
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(width: 60, height: 60)
                                Text("\(index)")
                            }
                            VStack(alignment: .leading, spacing: 8){
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(height: 22)
                                
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(Color.gray.opacity(0.5))
                                    .frame(height: 22)
                                    .padding(.trailing, 100)
                            }// VStack
                        }// HStack
                    }// ForEach
                }// VStack
                .padding()
                // setting ID
                // so that it can scroll to that position...
                .id("SCROLL_TO_TOP")
                // Getting scrollView Offset...
                .overlay(
                    // Using GeometryReader to get ScrollView Offset...
                    GeometryReader{ proxy -> Color in
                        //メインスレッド
                        DispatchQueue.main.async {
                            if startOffset == 0{
                                self.startOffset = proxy.frame(in: .global).minY
                            }
                        }
                        let offset = proxy.frame(in: .global).minY
                        self.scrollViewOffset = offset - startOffset
                        // スクロール時の変数の値を(Y座標の位置)を出力
                        print("scrollViewOffsetの値\(self.scrollViewOffset)")
                        print("-----------------")
                        print("startOffsetの値\(startOffset)")
                        print("offsetの値\(offset)")
                        
                        return Color.clear
                        
                    }// GeometryReader
                        .frame(width: 0, height: 0)
                    , alignment: .topTrailing
                )// .overlay
            }// ScrollView
            // if offset goes less than 450 the showing floating action button at bottom...
            .overlay(
                Button{
                    // Scroll to top with animation...
                    withAnimation(.spring()){
                        // scrollToメソッドの第二引数に対象の要素（View）をどの位置までスクロールさせるかUnitPointで指定する。
                        // 今回は.topを指定しているので、ページトップまでスクロールする。
                        proxyReader.scrollTo("SCROLL_TO_TOP", anchor: .top)
                    }
                }label: {
                    Image(systemName: "arrow.up")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.white)
                        .padding()
                        .background(.red)
                        .clipShape(Circle())
                    // Shadow...
                        .shadow(color: Color.black.opacity(0.9), radius: 5, x: 5, y: 5)
                }// Button
                    .padding(.trailing)
                    .padding(.bottom, getSafeArea().bottom == 0 ? 12 : 0)
                // scrollViewOffsetの値が-450以下になるとボタンの透明度を0にする　非表示にする
                    .opacity(scrollViewOffset < -450 ? 1 : 0)
                    .animation(.easeInOut)
                // fixing at bottom left...
                , alignment: .bottomTrailing
            )// .overlay
        }// ScrollViewReader
    }
    func getSafeArea() -> UIEdgeInsets {
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// extending view to get safearea...
extension View{
    func getSafeArea() -> UIEdgeInsets {
        return UIApplication.shared.windows.first?.safeAreaInsets ?? UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}
