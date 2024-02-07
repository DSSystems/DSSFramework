//
//  DSSLocalSearchTableView.swift
//  DSSFramework
//
//  Created by David on 07/11/20.
//  Copyright © 2020 DS_Systems. All rights reserved.
//

import UIKit
import MapKit

public protocol DSSLocalSearchItemModel: Equatable {
    static var font: UIFont { get }
    static var subtitleFont: UIFont { get }
    static var tintColor: UIColor { get }
    static var subtitleColor: UIColor { get }
    static var imageRenderingMode: UIImage.RenderingMode { get }
    static var intrinsicHeight: CGFloat { get }
    
    var imageName: String? { get }
    var imageUrl: String? { get }
    var title: String { get }
    var subtitle: String { get }
    
    static func new<T: DSSLocalSearchItemModel>(_ localSearchCompltion: MKLocalSearchCompletion) -> T?
}

public extension DSSLocalSearchItemModel {
    static var font: UIFont { UIFont.systemFont(ofSize: UIFont.systemFontSize) }
    static var subtitleFont: UIFont { UIFont.systemFont(ofSize: UIFont.smallSystemFontSize) }
    static var intrinsicHeight: CGFloat { 44 }
    static var tintColor: UIColor {
        if #available(iOS 13.0, *) {
            return .label
        } else {
            return .black
        }
    }
    static var subtitleColor: UIColor {
        if #available(iOS 13.0, *) {
            return .secondaryLabel
        } else {
            return .gray
        }
    }
    
    var imageName: String? { nil }
    var imageUrl: String? { nil }
    
    static func new<T: DSSLocalSearchItemModel>(_ localSearchCompltion: MKLocalSearchCompletion) -> T? { nil }
}

public struct DSSLocalSearchNullItem: DSSLocalSearchItemModel {
    public static var imageRenderingMode: UIImage.RenderingMode { .alwaysOriginal }
    public var title: String = ""
    public var subtitle: String = ""
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        (lhs.latitude == rhs.latitude) && (lhs.longitude == rhs.longitude)
    }
}

public protocol DSSLocalSearchSectionModel: Equatable {
    static var font: UIFont { get }
    static var textColor: UIColor { get }
    static var backgorundColor: UIColor { get }
    
    var title: String { get }
}

open class DSSLocalSearchSectionHeader<Model: DSSLocalSearchSectionModel>: UITableViewHeaderFooterView, DSSIdentifiable {
    var model: Model? {
        didSet {
            guard let model = model, model != oldValue else { return }
            titleLabel.text = model.title
        }
    }
    
    private let titleLabel: UILabel = .new { label in
        label.font = Model.font
        label.textColor = Model.textColor
        label.backgroundColor = Model.backgorundColor
    }
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setup() {
        backgroundColor = .clear
        addSubview(titleLabel)
        titleLabel.fillToSuperview(padding: .equallySpaced(horizontal: 16, vertical: 0))
    }
    
    static func height() -> CGFloat {
        Model.font.lineHeight + 8
    }
}

open class DSSLocalSearchItemCell<T: DSSLocalSearchItemModel>: DSSTableViewCell {
    public typealias Model = T
    
    class func setImge(from url: String, completion: @escaping (UIImage) -> Void) {
        fatalError("[\(NSStringFromClass(Self.self))]: You must override \(#function)")
    }
    
    class var padding: CGFloat { 16 }
    
    var localResultItem: Model? {
        didSet {
            guard let localResultItem = localResultItem, localResultItem != oldValue else {
                return prepareForReuse()
            }
            setup(localResultItem: localResultItem)
        }
    }
        
    private let titleLabel: UILabel = UILabel(text: nil, textAlignment: .left, font: T.font).withNumberOfLines(0)
    private var titleLabelLeadingAnchor: NSLayoutConstraint!
    private let iconImageView: UIImageView = UIImageView(contentMode: .scaleAspectFit).clipsToBounds()
    
    open override func setup() {
        backgroundColor = .clear
        
        contentView.addSubviews(iconImageView, titleLabel)
        
        iconImageView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil,
                             padding: .equallySpaced(horizontal: Self.padding, vertical: Self.padding / 2))
        iconImageView.widthAnchor(iconImageView.heightAnchor)
        iconImageView.isHidden = true
        
        titleLabel.anchor(top: topAnchor,
                          leading: nil,
                          bottom: bottomAnchor,
                          trailing: trailingAnchor,
                          padding: .init(top: 0, left: Self.padding / 2, bottom: 0, right: Self.padding))
        titleLabelLeadingAnchor = titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Self.padding)
        titleLabelLeadingAnchor.isActive = true

        iconImageView.tintColor = T.tintColor
        titleLabel.font = T.font
        titleLabel.textColor = T.tintColor
    }
    
    open func setup(localResultItem: Model) {
        if let name = localResultItem.imageName {
            iconImageView.image = UIImage(named: name)
            iconImageView.isHidden = false
            
            titleLabelLeadingAnchor.isActive = false
            titleLabelLeadingAnchor = titleLabel.leadingAnchor.constraint(
                equalTo: iconImageView.trailingAnchor,
                constant: Self.padding
            )
            titleLabelLeadingAnchor.isActive = true
        } else if let url = localResultItem.imageUrl {
            Self.setImge(from: url) { [weak self] image in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.iconImageView.isHidden = false
                    self.iconImageView.image = image
                    self.titleLabelLeadingAnchor.isActive = false
                    self.titleLabelLeadingAnchor = self.titleLabel.leadingAnchor.constraint(
                        equalTo: self.iconImageView.trailingAnchor,
                        constant: Self.padding
                    )
                    self.titleLabelLeadingAnchor.isActive = true
                }
            }
        } else {
            iconImageView.isHidden = true
            self.titleLabelLeadingAnchor.isActive = false
            self.titleLabelLeadingAnchor = self.titleLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: Self.padding
            )
            self.titleLabelLeadingAnchor.isActive = true
        }
        
        if !localResultItem.subtitle.isEmpty {
            titleLabel.numberOfLines = 2
            titleLabel.attributedText = NSMutableAttributedString(
                .init(text: localResultItem.title, font: T.font, textColor: T.tintColor),
                .init(text: localResultItem.subtitle, font: T.subtitleFont, textColor: T.subtitleColor, jumpLine: .start)
            )
        } else {
            titleLabel.numberOfLines = 2
            titleLabel.text = localResultItem.title
        }
    }
}

public protocol DSSLocalSearchTableViewDelegate {
    func localSearchTableViewDidUpdateResults(_ localSearchTableView: UITableView)
    func localSearchTableView<T: DSSLocalSearchItemModel>(_ localSearchTableView: UITableView, didSelectSearchItem item: T)
    func localSearchTableView<T: DSSLocalSearchItemModel>(_ localSearchTableView: UITableView, didSelectCustomItem item: T)
}

extension WeakRef: DSSLocalSearchTableViewDelegate where Object: DSSLocalSearchTableViewDelegate {
    public func localSearchTableView<T: DSSLocalSearchItemModel>(_ localSearchTableView: UITableView, didSelectSearchItem item: T) {
        object?.localSearchTableView(localSearchTableView, didSelectSearchItem: item)
    }
    
    public func localSearchTableView<T: DSSLocalSearchItemModel>(_ localSearchTableView: UITableView, didSelectCustomItem item: T) {
        object?.localSearchTableView(localSearchTableView, didSelectCustomItem: item)
    }
    
    public func localSearchTableViewDidUpdateResults(_ localSearchTableView: UITableView) {
        object?.localSearchTableViewDidUpdateResults(localSearchTableView)
    }
}

open class DSSLocalSearchTableView<T: DSSLocalSearchItemModel, U: DSSLocalSearchItemModel, V: DSSLocalSearchSectionModel>:
    UITableView,
    UITableViewDelegate,
    UITableViewDataSource,
    MKLocalSearchCompleterDelegate {
    
    typealias HeaderView = DSSLocalSearchSectionHeader<V>
    typealias SearchResultCell = DSSLocalSearchItemCell<T>
    typealias CustomResultCell = DSSLocalSearchItemCell<U>
    
    public struct Section {
        public enum SectionType: Int, CaseIterable {
            case search = 0, custom = 1
        }
        
        let type: SectionType
        let headerModel: V?
    }
    
    open var searchResultsDelegate: DSSLocalSearchTableViewDelegate?
    
    private let localSearchCompleter: MKLocalSearchCompleter = {
        let completer = MKLocalSearchCompleter()
        let p1 = MKMapPoint(CLLocationCoordinate2D(latitude: 17.522482, longitude: -71.876972))
        let p2 = MKMapPoint(CLLocationCoordinate2D(latitude: 19.955475, longitude: -68.275687))
        let rect = MKMapRect(x: min(p1.x, p2.x), y: min(p1.y, p2.y), width: abs(p1.x - p2.x), height: abs(p1.y - p2.y))
        completer.region = MKCoordinateRegion(rect)
        return completer
    }()
    
//    public var selectCompletion: (T) -> Void = { _ in }
    
    open var status: DSSBasicBusyTableCell.Status = .loading {
        didSet {
            searchResultsDelegate?.localSearchTableViewDidUpdateResults(self)
            reloadData()
        }
    }
    
    open var cellHeight: CGFloat { T.intrinsicHeight }
    open var headerHeight: CGFloat {
        guard numberOfItems > 0 else { return 0 }
        return HeaderView.height()
    }
    
    public var numberOfItems: Int { customResults.count + searchResults.count }
    
    private var sections: [Section] = [.init(type: .search, headerModel: nil), .init(type: .custom, headerModel: nil)] {
        didSet {
            searchResultsDelegate?.localSearchTableViewDidUpdateResults(self)
            guard status == .done else { return }
            reloadData()
        }
    }
    
    private var availableSections: [Section] {
        sections.filter { section in
            switch section.type {
            case .search: return !searchResults.isEmpty
            case .custom: return !customResults.isEmpty
            }
        }
    }
    
    open var customResults: [U] = [] {
        didSet { status = .done }
    }
    
    open private(set) var searchResults: [T] = []
    
    open var searchQuery: String? {
        didSet {
            guard let query = searchQuery, !query.isEmpty else {
                searchResults = []
                status = .loading
                return
            }
            
            status = .loading
            localSearchCompleter.queryFragment = query
        }
    }
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        
        setup()
    }
    
    @available(*, unavailable)
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setupSections(searchResultHeader: V?, customSectionHeader: V?) {
        sections = [.init(type: .search, headerModel: searchResultHeader), .init(type: .custom, headerModel: customSectionHeader)]
    }
    
    private func setup() {
        tableFooterView = .init()
        if #available(iOS 13.0, *) {
            localSearchCompleter.resultTypes = [.address, .pointOfInterest]
        } else {
            // Fallback on earlier versions
        }
        
        delegate = self
        dataSource = self
        separatorInset.left = 0
        localSearchCompleter.delegate = self
        
        register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.identifier)
        register(CustomResultCell.self, forCellReuseIdentifier: CustomResultCell.identifier)
        register(DSSBasicBusyTableCell.self, forCellReuseIdentifier: DSSBasicBusyTableCell.identifier)
        register(DSSLocalSearchSectionHeader<V>.self, forHeaderFooterViewReuseIdentifier: DSSLocalSearchSectionHeader<V>.identifier)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        guard numberOfItems > 0 else { return 1 }
        return availableSections.count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard numberOfItems > 0 else { return 1 }
        
        switch availableSections[section].type {
        case .search: return searchResults.count
        case .custom: return customResults.count
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: HeaderView.identifier) as! HeaderView
        header.model = availableSections[section].headerModel
        return header
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard numberOfItems > 0 else {
            let cell = tableView.dequeueReusableCell(withIdentifier: DSSBasicBusyTableCell.identifier) as! DSSBasicBusyTableCell
            cell.status = status
            return cell
        }
        
        switch availableSections[indexPath.section].type {
        case .search:
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCell.identifier, for: indexPath) as! SearchResultCell
            cell.localResultItem = searchResults[indexPath.item]
            return cell
        case .custom:
            let cell = tableView.dequeueReusableCell(withIdentifier: CustomResultCell.identifier, for: indexPath) as! CustomResultCell
            cell.localResultItem = customResults[indexPath.item]
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard numberOfItems > 0, !availableSections.isEmpty else { return 0 }
        return HeaderView.height()
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard numberOfItems > 0 else { return tableView.frame.height }
        return T.intrinsicHeight
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard numberOfItems > 0 else { return }
        switch availableSections[indexPath.section].type {
        case .search:
            guard !searchResults.isEmpty else { return }
            searchResultsDelegate?.localSearchTableView(self, didSelectSearchItem: searchResults[indexPath.item])
        case .custom:
            guard !customResults.isEmpty else { return }
            searchResultsDelegate?.localSearchTableView(self, didSelectCustomItem: customResults[indexPath.item])
        }
    }
    
    public func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchResults = completer.results.compactMap(T.new)
        status = .done
    }

    public func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        searchResults = []
        status = .message(text: error.localizedDescription)
    }
}
