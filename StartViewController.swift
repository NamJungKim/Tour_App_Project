//
//  StartViewController.swift
//  OYTG
//
//  Created by 김남정 on 2017. 6. 12..
//  Copyright © 2017년 NamJung. All rights reserved.
//

import UIKit

class StartViewController : UIViewController, UIScrollViewDelegate {
    @IBOutlet var scrollView : UIScrollView!
    @IBOutlet var pageControl : UIPageControl!
    @IBOutlet var button : UIButton!
    
    @IBOutlet var detailLabel: UILabel!
    var pageImages : [UIImage] = []
    var pageViews : [UIImageView?] = []
    
    override func viewDidLoad() {
        pageImages = [UIImage(named: "first.png")!,UIImage(named: "second.png")!,
                      UIImage(named: "third.png")!,UIImage(named: "forth.png")!,
                      UIImage(named: "fifth.png")!]
        
        let pageCount = self.pageImages.count
        detailLabel.text = "가고싶은 관광지를 찾아보세요!\n왼쪽으로 스와이프하면\n즐겨찾기를 할 수 있습니다!"
        self.pageControl.currentPage = 0
        self.pageControl.numberOfPages = pageCount
        for _ in 0..<pageCount{
            self.pageViews.append(nil)
        }
        let pagesScrollViewSize = self.scrollView.frame.size
        self.scrollView.contentSize = CGSize(width: pagesScrollViewSize.width * CGFloat(self.pageImages.count), height: pagesScrollViewSize.height)
        self.loadVisiblepage()
    }
    
    func loadPage(_ page: Int){
        if page < 0 || page >= pageImages.count{
            return
        }
        
        if pageViews[page] != nil{
            //pageView.removeFromSuperview()
            //pageViews[page] = nil
        }else{
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            
            let newPageView = UIImageView(image: pageImages[page])
            newPageView.contentMode = .scaleAspectFit
            newPageView.frame = frame
            scrollView.addSubview(newPageView)
            
            pageViews[page] = newPageView
        }
    }

    
    func purgePage(_ page:Int){
        if page < 0 || page >= pageImages.count{
            return
        }
        
        if let pageView = pageViews[page]{
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    

    
    func loadVisiblepage(){
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        pageControl.currentPage = page
        
        let firstPage = page - 1
        let lastPage = page + 1
        if lastPage == 5{
            button.isHidden = false
        }
        if lastPage == 1{
            detailLabel.text = "가고싶은 관광지를 찾아보세요!\n왼쪽으로 스와이프하면\n즐겨찾기를 할 수 있습니다!"
        }else if lastPage == 2{
            detailLabel.text = "주변에 뭐가 있는지 알아볼까요?"
        }else if lastPage == 3{
            detailLabel.text = "원하는 관광지를 클릭하시면\n더욱 자세한 정보를 얻을 수 있습니다!"
        }else if lastPage == 4{
            detailLabel.text = "나만의 관광지들을\n만들어 보세요!"
        }else if lastPage == 5{
            detailLabel.text = "테마도 마음대로 변경할 수 있어요!\n시작하기버튼을 눌러 지금 떠나보세요!"
        }
        for index in 0..<firstPage+1{
            purgePage(index)
        }
        
        for index in firstPage...lastPage{
            loadPage(index)
        }
        
        for index in lastPage+1..<pageImages.count+1{
            purgePage(index)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        loadVisiblepage()
    }
    
    
}
