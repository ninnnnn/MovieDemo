//
//  ScrollableTabView.swift
//  Moya+Rx
//
//  Created by Daniel on 2020/2/11.
//  Copyright © 2020 Daniel. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol ScrollableTabViewData {
    var title: String { get }
    var id: Int? { get }
}

struct ScrollableTabViewOption {
    enum TabIndicatorType {
        case bottomLine, cirlce
    }
    
    var marginPadding: CGFloat = 15
    var itemWidth: CGFloat = 50
    var itemSpace: CGFloat = 10
    var tabIndicatorWidth: CGFloat = 30
    var tabIndicatorHeight: CGFloat = 3
    var tabIndicatorBottomSpace: CGFloat = 10
    var tabIndicatorColor: UIColor = UIColor.hexStringToUIColor(hex: "ce0350")
    var titleShouldTransformWhenSelected: Bool = true
    var titleTransformScale: CGFloat = 0.7
    var shouldChangeTitleColorWhenSelected: Bool = false
    var titleSelectedColor: UIColor = .black
    var titleUnSelectedColor: UIColor = .black
    var selectTitleFont: UIFont = UIFont(name: "PingFangSC-Semibold", size: 18)!
    var unSelectTitleFont: UIFont = UIFont(name: "PingFangSC-Regular", size: 18)!
    var tabIndicatorType: TabIndicatorType = .bottomLine
    var disableIndexs: [Int] = []
    var disableTextColor: UIColor = .red
    var disableTextFont: UIFont = UIFont(name: "PingFangSC-Regular", size: 17)!
    
    var numberFont: UIFont = UIFont(name: "PingFangSC-Regular", size: 15)!
    
    ///After refresh data, it will select item when `updateDefaultSelectWhenRefeshData` is true, otherwise not.
    ///If `updateDefaultSelectWhenRefeshData` is false, you can select item by `updateDefualtSelect(_ data: ScrollableTabViewData)` function.
    var updateDefaultSelectWhenRefeshData: Bool = true
}

class ScrollableTabView: UIView {
    
    //MARK:- Property
    let didTapItem = BehaviorRelay<ScrollableTabViewData?>(value: nil)
    
    private let disposeBag = DisposeBag()
    private var selectedIndex = -1
    private var collectionView: UICollectionView?
    private var tabIndicator: UIView?
    private var option: ScrollableTabViewOption = ScrollableTabViewOption() {
        didSet {
            self.resizeTabIndicator()
            self.reloadData(selectIndex: selectedIndex)
        }
    }
    
    private(set) var dataArray = BehaviorRelay<[ScrollableTabViewData]>(value: [])
    private var itemWidthDic: [Int:CGFloat] = [:]
    
    //MARK:- Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCollectionView()
        configureTabIndicator()
        binding()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureCollectionView()
        configureTabIndicator()
        binding()
    }
    
    convenience init(frame: CGRect, option: ScrollableTabViewOption? = nil) {
        self.init(frame: frame)
        
        //initialize call didSet
        //https://stackoverflow.com/a/33979852/12394719
        defer { if let option = option { self.option = option } }
    }
    
    //MARK:- Public function
    func updateOption(_ option: ScrollableTabViewOption) {
        self.option = option
    }
    
    func updateDefualtSelect(_ data: ScrollableTabViewData) {
        let index = self.dataArray.value.enumerated().filter({ $0.element.id == data.id }).first.map({ $0.offset })
        self.reloadData(selectIndex: index)
    }
    
    //MARK:- Private function
    private func binding() {
        self.dataArray
            .currentAndPrevious()
            .subscribe(onNext: { [weak self] (currentData, previosData) in
                guard let self = self, let previosData = previosData else { return }
                self.updateItemWidthDic()
                
                let index = (self.option.updateDefaultSelectWhenRefeshData && previosData.count > 0 && self.selectedIndex != -1) ? currentData.enumerated().filter({ $0.element.id == previosData[self.selectedIndex].id }).first.map({ $0.offset }) ?? nil : nil
                self.reloadData(selectIndex: index)
            })
            .disposed(by: self.disposeBag)
    }
    
    private func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = option.itemSpace
        layout.sectionInset = UIEdgeInsets(top: 0, left: option.marginPadding, bottom: 0, right: option.marginPadding)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: collectionView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0).isActive = true
        
        collectionView.register(UINib(nibName: String(describing: ScrollableItemCell.self), bundle: nil), forCellWithReuseIdentifier: String(describing: ScrollableItemCell.self))
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.layoutIfNeeded()
        self.collectionView = collectionView
    }
    
    private func configureTabIndicator() {
        guard let collectionView = self.collectionView else { return }
        
        var tabIndicator = UIView()
        
        switch option.tabIndicatorType {
        case .bottomLine:
            tabIndicator = UIView(frame: CGRect(x: 0, y: self.bounds.size.height - option.tabIndicatorHeight - option.tabIndicatorBottomSpace, width: option.tabIndicatorWidth, height: option.tabIndicatorHeight))
            tabIndicator.layer.cornerRadius = option.tabIndicatorHeight / 2
        case .cirlce:
            let diameter = self.bounds.size.height - option.tabIndicatorBottomSpace
            tabIndicator = UIView(frame: CGRect(x: 0, y: 0, width: diameter, height: diameter))
            tabIndicator.layer.cornerRadius = diameter / 2
        }
        
        collectionView.insertSubview(tabIndicator, at: 0)
        
        tabIndicator.backgroundColor = option.tabIndicatorColor
        self.tabIndicator = tabIndicator
    }
    
    private func resizeTabIndicator() {
        self.tabIndicator?.removeFromSuperview()
        self.tabIndicator = nil
        self.configureTabIndicator()
    }
    
    private func updateItemWidthDic() {
        for index in 0..<self.dataArray.value.count {
            switch option.tabIndicatorType {
            case .bottomLine:
                let text = self.dataArray.value[index].title
                let textWidth = text.width(font: option.selectTitleFont, height: self.bounds.size.height)
                itemWidthDic[index] = textWidth
            case .cirlce:
                itemWidthDic = [:]
            }
        }
    }
    
    private func reloadData(selectIndex: Int?) {
        self.collectionView?.reloadData()
        if let index = selectIndex {
            self.collectionView?.selectItem(at: IndexPath(item: index, section: 0), animated: false, scrollPosition: [])
            self.collectionView(self.collectionView!, didSelectItemAt: IndexPath(item: index, section: 0))
        }
        self.updateTabIndicatorPosition()
    }
    
    private func updateTabIndicatorPosition() {
        guard let tabIndicator = tabIndicator else { return }
        
        var frame = tabIndicator.frame
        
        switch option.tabIndicatorType {
        case .bottomLine:
            let startX = option.marginPadding
            let totalItemWitdh: CGFloat = itemWidthDic.filter({ $0.key < selectedIndex }).compactMap({ $0.value }).reduce(0, +)
            let halfWidth = ((itemWidthDic[selectedIndex] ?? option.itemWidth) -  option.tabIndicatorWidth) / 2
            let spaces = CGFloat(selectedIndex) * option.itemSpace
            let x = startX + totalItemWitdh + halfWidth + spaces
            frame.origin.x = x
        case .cirlce:
            let startX = option.marginPadding - option.itemSpace
            let totalItemWidth = CGFloat(selectedIndex) * option.itemWidth
            let space = CGFloat(selectedIndex) * option.itemSpace
            let diameter = frame.size.width
            let halfDistance = (option.itemWidth + option.itemSpace * 2 - diameter) / 2
            let x = startX + totalItemWidth + space + halfDistance
            frame.origin.x = x
        }
        
        self.collectionView?.layoutIfNeeded()
        UIView.animate(withDuration: 0.3, animations: {
            tabIndicator.frame = frame
        })
    }
    
    private func updateTitle(in label: UILabel, selected: Bool, animation: Bool = true) {
        if option.titleShouldTransformWhenSelected {
            if animation {
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    guard let self = self else { return }
                    label.transform = selected ? .identity : CGAffineTransform(scaleX: self.option.titleTransformScale, y: self.option.titleTransformScale)
                    label.font = selected ? self.option.selectTitleFont : self.option.unSelectTitleFont
                })
            } else {
                label.transform = selected ? .identity : CGAffineTransform(scaleX: self.option.titleTransformScale, y: self.option.titleTransformScale)
                label.font = selected ? self.option.selectTitleFont : self.option.unSelectTitleFont
            }
        } else {
            label.transform = .identity
            guard let text = label.text else { return }
            if text.hasNumbers {
                let attr = getIntAttributedText(text: text, selected: selected)
                label.attributedText = attr
            } else {
                label.font = selected ? self.option.selectTitleFont : self.option.unSelectTitleFont
            }
        }
        
        if option.shouldChangeTitleColorWhenSelected {
            label.textColor = selected ? option.titleSelectedColor : option.titleUnSelectedColor
        } else {
            label.textColor = option.titleSelectedColor
        }
    }
    
    private func getIntAttributedText(text: String, selected: Bool) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(string: text)
        text.enumerated().forEach { (index, string) in
            if string.int != nil {
                attr.addAttribute(.font, value: option.numberFont, range: NSRange(location: index, length: 1))
            } else {
                attr.addAttribute(.font, value: selected ? self.option.selectTitleFont : self.option.unSelectTitleFont, range: NSRange(location: index, length: 1))
            }
        }
        return attr
    }
}

extension ScrollableTabView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: ScrollableItemCell.self), for: indexPath) as! ScrollableItemCell
        cell.titleLabel.text = dataArray.value[indexPath.item].title
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        collectionView.bringSubviewToFront(cell)
        if let cell = cell as? ScrollableItemCell {
            if option.disableIndexs.contains(indexPath.item) {
                cell.isUserInteractionEnabled = false
                cell.titleLabel.textColor = option.disableTextColor
                cell.titleLabel.font = option.disableTextFont
                cell.titleLabel.transform = .identity
            } else {
                cell.isUserInteractionEnabled = true
                updateTitle(in: cell.titleLabel, selected: selectedIndex == indexPath.item, animation: false)
            }
        }
    }
}

extension ScrollableTabView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch option.tabIndicatorType {
        case .bottomLine:
            return CGSize(width: itemWidthDic[indexPath.item] ?? 0, height: self.bounds.size.height)
        case .cirlce:
            return CGSize(width: option.itemWidth, height: self.bounds.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndex == indexPath.item { return }
        selectedIndex = indexPath.item
        
        if indexPath.item < dataArray.value.count { didTapItem.accept(dataArray.value[indexPath.row]) }
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? ScrollableItemCell else { return }
        updateTabIndicatorPosition()
        updateTitle(in: cell.titleLabel, selected: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? ScrollableItemCell else { return }
        updateTitle(in: cell.titleLabel, selected: false)
    }
}
