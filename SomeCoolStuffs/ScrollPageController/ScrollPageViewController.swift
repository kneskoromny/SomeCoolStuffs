import UIKit

class ScrollPageViewController: UIViewController {
    
    // MARK: - Const
    
    private enum Const {
        static let currentPage = 0
        static let cornerRadius: CGFloat = 10
    }
    
    // MARK: - Outlets
    
    @IBOutlet private var mainLabel: UILabel?
    @IBOutlet private var scrollView: UIScrollView?
    @IBOutlet private var pageControl: UIPageControl?
    @IBOutlet private var nextViewButton: UIButton?
    @IBOutlet private var closeViewButton: UIButton?
    
    // MARK: - Private Properties
    
    private enum ViewState {
        case load
        case process
        case end
    }
    
    private var viewList = [
        UIImage(named: "1"),
        UIImage(named: "2"),
        UIImage(named: "3"),
        UIImage(named: "4"),
        UIImage(named: "5")
    ]
    private var currentViewIndex = 0
    private var viewHeight: CGFloat = 0
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //changeUI(forState: .load)
        setupPageControl()
        setupButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupScrollView()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fillScrollView()
        viewHeight = view.frame.height
    }
      
    // MARK: - Private Methods
    
    private func setupPageControl() {
        pageControl?.currentPage = Const.currentPage
        pageControl?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
    }
    
    private func setupButtons() {
        nextViewButton?.layer.cornerRadius = Const.cornerRadius
        nextViewButton?.setTitleColor(UIColor.white, for: .normal)
        nextViewButton?.backgroundColor = UIColor.systemPurple
        
        closeViewButton?.layer.cornerRadius = Const.cornerRadius
        closeViewButton?.setTitleColor(UIColor.white, for: .normal)
        nextViewButton?.backgroundColor = UIColor.systemOrange
    }
    
    private func setupScrollView() {
        scrollView?.delegate = self
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.isPagingEnabled = true
        scrollView?.isScrollEnabled = true
        
        if let height = scrollView?.frame.height {
            scrollView?.contentSize = CGSize(width: view.frame.width * CGFloat(viewList.count),
                                             height: height)
        }
    }
    
    private func fillScrollView() {
        guard let width = scrollView?.frame.width,
              let height = scrollView?.frame.height else {
            return
        }
        for i in 0 ..< viewList.count {
            let cartoonView = CartoonView()
            cartoonView.frame = CGRect(x: width * CGFloat(i), y: 0, width: view.frame.width, height: height)
            cartoonView.configure(withImage: viewList[i]!)
            scrollView?.addSubview(cartoonView)
        }
        pageControl?.numberOfPages = viewList.count
        changeUI(forState: .process)
    }
    
    private func changeCurrentView() {
        guard let scrollView = scrollView else { return }

        pageControl?.currentPage = currentViewIndex
        
        var offset = scrollView.contentOffset
        if scrollView.contentOffset.x < view.bounds.width * CGFloat(currentViewIndex) {
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
        nextViewButton?.isHidden = state == .end
        closeViewButton?.backgroundColor = state == .end
        ? UIColor.systemOrange
        : UIColor.systemYellow
        
        let titleColor = state == .end
        ? UIColor.black
        : UIColor.white
        closeViewButton?.setTitleColor(titleColor, for: .normal)
    }
    
    // MARK: - Actions
    
    @IBAction func nextButtonDidTapped(_ sender: UIButton) {
        currentViewIndex += 1
        changeCurrentView()
    }
    
    @IBAction func closeButtonDidTapped(_ sender: UIButton) {
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
