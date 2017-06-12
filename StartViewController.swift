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
    
    var pageImages : [UIImage] = []
    var pageViews : [UIImageView?] = []
    
    override func viewDidLoad() {
        pageImages = [UIImage(named: "first.png")!,UIImage(named: "second.png")!,
                      UIImage(named: "third.png")!,UIImage(named: "forth.png")!,
                      UIImage(named: "fifth.png")!]
        
        let pageCount = self.pageImages.count
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
