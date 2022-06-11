import UIKit

class ScrollPageViewController: UIViewController {
    
    // MARK: - Const
    
    private enum Const {
        static let currentPage = 0
        static let cornerRadius: CGFloat = 10
        
        static let title = "Привет, Винни!"
        
        enum ButtonTitle {
            static let process = "Показать Винни!"
            static let end = "На этом все :]"
        }
    }
    
    // MARK: - Outlets
    
    @IBOutlet private var scrollView: UIScrollView?
    @IBOutlet private var pageControl: UIPageControl?
    @IBOutlet private var nextViewButton: UIButton?
    
    // MARK: - Private Properties
    
    private var viewList = [
        UIImage(named: "1"),
        UIImage(named: "2"),
        UIImage(named: "3"),
        UIImage(named: "4"),
        UIImage(named: "5")
    ]
    private enum ViewState {
        case process
        case end
    }
    private var currentViewIndex = 0
    private var viewHeight: CGFloat = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupPageControl()
        setupButton()
        changeUI(forState: .process)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupScrollView()
        fillScrollView()
    }
      
    // MARK: - Private Methods
    
    private func setupNavBar() {
        title = Const.title
    }
    
    private func setupPageControl() {
        pageControl?.currentPage = Const.currentPage
        pageControl?.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    }
    
    private func setupButton() {
        nextViewButton?.layer.cornerRadius = Const.cornerRadius
    }
    
    private func setupScrollView() {
        scrollView?.delegate = self
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.isPagingEnabled = true
        scrollView?.isScrollEnabled = true
        
        if let height = scrollView?.frame.height {
            let calculatedWidth = view.frame.width * CGFloat(viewList.count)
            scrollView?.contentSize = CGSize(width: calculatedWidth,
                                             height: height)
        }
    }
    
    private func fillScrollView() {
        let viewWidth = view.frame.width
        
        guard let width = scrollView?.frame.width,
              let height = scrollView?.frame.height else {
            return
        }
        for i in 0 ..< viewList.count {
            let cartoonView = CartoonView()
            cartoonView.frame = CGRect(x: width * CGFloat(i), y: 0, width: viewWidth, height: height)
            cartoonView.configure(withImage: viewList[i]!)
            scrollView?.addSubview(cartoonView)
        }
        pageControl?.numberOfPages = viewList.count
    }
    
    private func changeCurrentView() {
        guard let scrollView = scrollView else { return }

        pageControl?.currentPage = currentViewIndex
        
        var offset = scrollView.contentOffset
        if offset.x < view.bounds.width * CGFloat(currentViewIndex) {
            offset.x += view.bounds.width
        } else {
            offset.x -= view.bounds.width
        }
        let rect = CGRect(origin: offset, size: scrollView.bounds.size)
        scrollView.scrollRectToVisible(rect, animated: true)
        
        updateButtons()
    }
    
    private func updateButtons() {
        if currentViewIndex == viewList.count - 1 {
            changeUI(forState: .end)
        } else {
            changeUI(forState: .process)
        }
    }
    
    private func changeUI(forState state: ViewState) {
        let purple = UIColor.systemPurple
        let orange = UIColor.systemOrange
        
        nextViewButton?.backgroundColor = state == .process
        ? purple
        : orange
        switch state {
        case .process:
            nextViewButton?.setTitle(Const.ButtonTitle.process, for: .normal)
            nextViewButton?.setTitleColor(orange, for: .normal)
        case .end:
            nextViewButton?.setTitle(Const.ButtonTitle.end, for: .normal)
            nextViewButton?.setTitleColor(purple, for: .normal)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonDidTapped(_ sender: UIButton) {
        currentViewIndex += 1
        changeCurrentView()
    }
    
    @IBAction func pageControlDidTapped(_ sender: UIPageControl) {
        currentViewIndex = sender.currentPage
        changeCurrentView()
    }
}

// MARK: - UIScrollView Delegate

extension ScrollPageViewController: UIScrollViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl?.currentPage = Int(pageIndex)
        currentViewIndex = Int(pageIndex)
        updateButtons()
    }
}
