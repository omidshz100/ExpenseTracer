//
//  Recent.swift
//  ExpenseTracer
//
//  Created by Omid Shojaeian Zanjani on 18/12/23.
//

import SwiftUI

struct Recent: View {
   // User Properties
    @AppStorage("userName") var userName:String = "Omid"
    // view properties
    @State private var startDate:Date = .now.startOfMonth
    @State private var endDate:Date = .now.endOfMonth
    @State private var selectedCategory:Category = .expence
    @State private var showFilterView:Bool = false
    // for animaation ⚠️ ❓⚠️
    @Namespace private var animation
    var body: some View {
        GeometryReader {
            // for animation purposes
            let size = $0.size
            NavigationStack{
                ScrollView(.vertical){
                    // using LazyVStack ⚠️ ❓⚠️
                    LazyVStack(spacing:10, pinnedViews: [.sectionHeaders]){
                        Section{
                            // Date Filter Button
                            Button(action: {
                                showFilterView.toggle()
                            }, label: {
                                Text("\(dateFormat(date: startDate , format: "dd - MM yy")) to \(dateFormat(date: endDate , format: "dd - MM yy"))")
                                    .font(.caption2)
                                    .foregroundStyle(.gray)
                            }).hSpacing(.leading)
                            // Card View
                            CardView(income: 200, expence: 300)
                            // Custom Segmented Control
                            CustomSegmentedControl()
                                .padding(.bottom, 10)
                            // Using * filter * for list to seprate items in two sections ( income or Expense ) ⚠️😎
                            ForEach(sampleTransActions.filter({$0.category == selectedCategory.rawValue })){ transaction in
                                TransActionCardView(transAction: transaction)
                            }
                        }header: {
                            HeaderView(size)
                        }
                        
                    }
                    .padding(15)
                }
                .background(.gray.opacity(0.15))
                .blur(radius: showFilterView ? 5:0)
                .disabled(showFilterView)
            }
            .overlay {
                    if showFilterView {
                        DateFilterView(start: startDate, end: endDate, onSubmit: { start, end in
                            startDate = start
                            endDate = end
                            showFilterView = false
                        }, onClose: {
                            showFilterView = false
                        })
                            .transition(.move(edge: .leading))
                    }
            }
            // با یه جایه جایی از ز استک به اوورلی کلی در انیمیشن ها تغییر ایجاد کرد
            .animation(.snappy, value: showFilterView)
        }
    }
    
    @ViewBuilder
    func HeaderView(_ size:CGSize)-> some View {
        
        HStack(spacing:10){
            VStack(alignment: .leading, spacing: 5){
                Text("Wellcome")
                    .font(.title.bold())
                
                if !userName.isEmpty {
                    Text(userName)
                        .font(.callout)
                        .foregroundStyle(.gray)
                }
            }
            .visualEffect { content, geometryProxy in
               content
                    .scaleEffect(headerScale(size, proxy: geometryProxy), anchor: .topLeading)
            }
            
            Spacer(minLength: 0)
            NavigationLink{
                NewExpenseView()
            }label: {
                Image(systemName: "plus")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white)
                    .frame(width: 45, height: 45)
                    .background(appTint.gradient, in:.circle)
                    .contentShape(.circle)
            }
        }
        .padding(.bottom, userName.isEmpty ? 10:5)
        .background(){
            // fixed : when I see gap between two views
            VStack(spacing:0){
                Rectangle()
                    .fill(.ultraThinMaterial)
                Divider()
            }
            .visualEffect { content, geometryProxy in
                content
                    .opacity(headerBGOpacity(geometryProxy))
            }
                .padding(.horizontal, -15)
                .padding(.top, -(safeArea.top + 15))
        }
    }
    
    // Custom Segmented Control
    func CustomSegmentedControl() -> some View {
        HStack(spacing:0){
            ForEach(Category.allCases, id:\.rawValue) { category in
                Text(category.rawValue)
                    .hSpacing()
                    .padding(.vertical, 10)
                    .background(){
                        if category == selectedCategory {
                            Capsule()
                            // what is .background ⚠️ ❓⚠️
                                .fill(.background)
                                .shadow(radius: 10)
                            // important Tip 😎 using matchGeometry to animate
                                .matchedGeometryEffect(id: "ACTIVETAB", in: animation)
                        }
                    }
                    .contentShape(.capsule)
                    .onTapGesture {
                        withAnimation(.snappy){
                            selectedCategory = category
                        }
                    }
            }
        }
        .background(.gray.opacity(0.25), in: Capsule())
        .padding(.top, 5)
    }
    
    func headerBGOpacity(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY + safeArea.top
        print(minY)
        return minY > 0 ? 0 : (-minY / 15)
    }
    
    func headerScale(_ size:CGSize, proxy:GeometryProxy )->CGFloat {
        let minY = proxy.frame(in: .scrollView).minY
        let screenHeight = size.height
        
        let progress = minY / screenHeight
        let scale = min(max(progress, 0),1) * 0.3
        
        
        return 1 + scale
    }
}
#Preview {
    ContentView()
}
