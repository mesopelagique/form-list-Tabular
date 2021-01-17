//
//  ___TABLE___ListForm.swift
//  ___PACKAGENAME___
//
//  Created by ___FULLUSERNAME___ on ___DATE___
//  ___COPYRIGHT___

import UIKit
import QMobileUI
import QMobileDataStore

/// Generated list form for ___TABLE___ table.
@IBDesignable
class ___TABLE___ListForm: ListFormCollection {

    // Do not edit name or override tableName
    public override var tableName: String {
        return "___TABLE___"
    }

    // MARK: configure sheet

    /// List of columns labels, separated by comma
    @IBInspectable public var columsLabels: String = "" {
        didSet {
            self._columsLabels = columsLabels.split(separator: ",").filter({!$0.isEmpty }).map({String($0).trimmingCharacters(in: .whitespacesAndNewlines)})
        }
    }
    /// List of columns labels
    private (set) var _columsLabels: [String] = []

    /// List of columns field names, separated by comma
    @IBInspectable public var columsFieldName: String = "" {
        didSet {
            self._columsFieldName = columsFieldName.split(separator: ",").filter({!$0.isEmpty }).map({String($0).trimmingCharacters(in: .whitespacesAndNewlines)})
        }
    }
    /// List of columns field names
    private (set) var _columsFieldName: [String] = []

    /// Computations in footers, separated by comma. ex: min, max, avg, sum
    @IBInspectable public var computations: String = "" {
        didSet {
            self._computations = computations.split(separator: ",").compactMap({CoreDataComputation(rawValue: String($0).trimmingCharacters(in: .whitespacesAndNewlines))})
        }
    }
    /// enumeration to representation all possible computation on data
    enum CoreDataComputation: String {
        case sum, max, min, avg
        var label: String {
            switch self {
            case .sum:
                return "Sum"
            case .min:
                return "Min"
            case .max:
                return "Max"
            case .avg:
                return "Average"
            }
        }
    }
    /// Computations in footers
    var _computations: [CoreDataComputation] = []

    /// Has header displayed (no header is not implemented)
    let hasHeader: Bool = true // not taken into account yet

    // MARK: Life
    override func onLoad() {
        // collection view must not be under navigation bar
        self.edgesForExtendedLayout = []

        // remap datasouce to this controller instead of `self.dataSource`
        self.collectionView.dataSource = self

        // cannot rely on normal behaviour for refresh data event, a record is not displayed in one cell but in many (colCount)
        self.dataSource?.fetchedResultsController.delegate = self
    }

    override func onWillAppear(_ animated: Bool) {
        // Called when the view is about to made visible. Default does nothing
    }

    override func onDidAppear(_ animated: Bool) {
        // Called when the view has been fully transitioned onto the screen. Default does nothing
    }

    override func onWillDisappear(_ animated: Bool) {
        // Called when the view is dismissed, covered or otherwise hidden. Default does nothing
    }

    override func onDidDisappear(_ animated: Bool) {
        // Called after the view was dismissed, covered or otherwise hidden. Default does nothing
    }
}

// MARK: FetchedResultsControllerDelegate

extension ___TABLE___ListForm: FetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: FetchedResultsController) {
        // start
    }
    func controller(_ controller: FetchedResultsController, didChangeRecord aRecord: Record, at indexPath: IndexPath?, for type: FetchedResultsChangeType, newIndexPath: IndexPath?) {
    }
    func controllerDidChangeContent(_ controller: FetchedResultsController) {
        self.collectionView.reloadData()
    }
    func controllerDidChangeSection(_ controller: FetchedResultsController, at sectionIndex: FetchedResultsController.SectionIndex, for type: FetchedResultsChangeType) {
    }
    func controller(_ controller: FetchedResultsController, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return nil // no section by name, each record is a section
    }
}

// MARK: UICollectionViewDataSource

extension ___TABLE___ListForm /*: UICollectionViewDataSource*/ {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colCount(forRow: section)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.rowCount
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let rowIndex = indexPath.section
        let cellIdentifier = self.dataSource?.cellIdentifier ?? self.tableName
        if rowIndex == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "header", for: indexPath)
        }
        let dataCount = self.dataCount
        if rowIndex > dataCount {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "footer", for: indexPath)
        }
        let colIndex = indexPath.row
        if colIndex == 0 {
            if rowIndex % 2 == 0 {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "\(cellIdentifier)FirstEven", for: indexPath)
            } else {
                return collectionView.dequeueReusableCell(withReuseIdentifier: "\(cellIdentifier)First", for: indexPath)
            }
        }
        if rowIndex % 2 == 0 {
            return collectionView.dequeueReusableCell(withReuseIdentifier: "\(cellIdentifier)Even", for: indexPath)
        } else {
            return collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let label = cell.viewWithTag(10) as? UILabel else {
            return
        }

        // set data (binding more complicated,? do with normal way in willDisplay?
        if let value = self.getValue(at: indexPath) {
            label.text = "\(value)"
        } else {
            label.text = ""
        }
    }

    fileprivate var extraRowCount: Int {
        return rowsFromTop + rowsFromBottom
    }

    fileprivate var dataCount: Int {
        return self.dataSource?.count ?? 0
    }

    fileprivate var rowCount: Int {
        return dataCount + extraRowCount
    }

    fileprivate func colCount(forRow row: Int) -> Int {
       return _columsFieldName.count
    }

    fileprivate func getValue(at indexPath: IndexPath) -> Any? {
        var rowIndex = indexPath.section
        let colIndex = indexPath.row
        if hasHeader {
            if rowIndex == 0 {
                return _columsLabels[colIndex]
            }
        } else {
            rowIndex += 1
        }
        let dataCount = self.dataCount // cache? or coredata cache already? (debug sql)
        let colName = _columsFieldName[colIndex]

        if rowIndex > dataCount { // extra computation
            if let fetchedObjects = self.dataSource?.fetchedRecords {
                let data = fetchedObjects as NSArray
                var value: Any?
                let computationIndex = rowIndex - dataCount - 1
                if computationIndex < self._computations.count {
                    let cpt = self._computations[computationIndex]
                    if colIndex == 0 {
                        return cpt.label
                    }
                    value = data.value(forKeyPath: "@\(cpt.rawValue).\(colName)")
                    if NSDecimalNumber.notANumber == value as? NSObject {
                        return nil
                    }
                    return value
                } // else assert?
            }
            return "\(indexPath)"
        }
        if let store = self.dataSource?.record(at: IndexPath(row: rowIndex - 1, section: 0)) {
            return store.value(forKey: colName)
        }
        return ""
    }
}

// MARK: UICollectionViewDelegateFlowLayout
extension ___TABLE___ListForm: ___TABLE___ListFormControllerLayoutDelegate {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let rowCount = self.rowCount
        let rowIndex = indexPath.section
        if (rowCount - rowIndex <= 2) && (indexPath.item == colCount(forRow: rowIndex) - 1) {
            return CGSize(width: 140, height: 50)
        } else if rowCount - rowIndex <= 2 {
            return CGSize(width: 100, height: 50)
        } else if indexPath.item == colCount(forRow: rowIndex) - 1 {
            return CGSize(width: 140, height: 50)
        }
        return CGSize(width: 100, height: 50)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }

    var rowsFromTop: Int {
        return hasHeader ? 1: 0

    }

    var rowsFromBottom: Int {
        return _computations.count
    }

    var colsFromLeft: Int {
        return 1
    }

    var colsFromRight: Int {
        return 0
    }

}

// MARK: UICollectionViewDelegateFlowLayout
open class ___TABLE___ListFormControllerLayout: UICollectionViewFlowLayout {

    private var delegate: ___TABLE___ListFormControllerLayoutDelegate {
        return (collectionView?.delegate as! ___TABLE___ListFormControllerLayoutDelegate)
    }
    private var cellAttrsDict = [IndexPath: UICollectionViewLayoutAttributes]()
    private var cellFramesDict = [IndexPath: CGRect]()
    private var collectionViewContentWidth: CGFloat = 0
    private var collectionViewContentHeight: CGFloat = 0

    override open var collectionViewContentSize: CGSize {
        return CGSize(width: collectionViewContentWidth, height: collectionViewContentHeight)
    }

    private var rows: Int {
        return collectionView?.numberOfSections ?? 0
    }

    private func colsCount(section: Int) -> Int {
        return collectionView?.numberOfItems(inSection: section) ?? 0
    }

    override open func prepare() {
        super.prepare()
        layoutCellPositions()
        updateCellPositions()
    }

    private func layoutCellPositions() {
        guard let collectionView = collectionView, rows > 0 else {
            return
        }

        cellAttrsDict = [IndexPath: UICollectionViewLayoutAttributes]()
        cellFramesDict = [IndexPath: CGRect]()
        collectionViewContentWidth = 0
        collectionViewContentHeight = 0
        let bottomRowsSets = delegate.getBottomRows(rowCount: rows)
        var colHeights = cellHeights()
        var rowWidths = cellsRowWidths()
        var xPos: CGFloat = 0
        var yPos: CGFloat = 0
        for section in 0..<rows {
            let itemsCount = collectionView.numberOfItems(inSection: section)
            let rightColsSets = delegate.getRightCols(colCount: itemsCount)
            let sectionSpacing = (section == rows - 1) ? 0 : getSectionSpacing(forRow: section)
            let interItemSpacing = getInterItemSpacing(forRow: section)
            var maxCellHeightForSection: CGFloat = 0

            for item in 0..<itemsCount {
                let cellSize = getCellSize(forRow: section, forCol: item)
                let cellWidth = cellSize.width
                let cellHeight = cellSize.height
                let cellIndex = IndexPath(item: item, section: section)
                let cellAttributes = UICollectionViewLayoutAttributes(forCellWith: cellIndex as IndexPath)
                let interItemSpacing = (item == itemsCount - 1) ? 0 : interItemSpacing
                maxCellHeightForSection = max(maxCellHeightForSection, cellHeight)

                var rowYPos = yPos
                if bottomRowsSets.contains(section) {
                    rowYPos = collectionView.frame.height - colHeights

                    if yPos < rowYPos {
                        rowYPos = yPos
                    }
                }

                var rowXPos = xPos
                if rightColsSets.contains(item) {
                    rowXPos = collectionView.frame.width - (rowWidths[section] ?? 0)

                    if xPos < rowXPos {
                        rowXPos = xPos
                    }

                    rowWidths[section] = (rowWidths[section] ?? 0) - cellWidth - interItemSpacing
                }

                cellFramesDict[cellIndex] = CGRect(x: rowXPos, y: rowYPos, width: cellWidth, height: cellHeight)
                cellAttributes.frame = cellFramesDict[cellIndex] ?? .zero
                cellAttrsDict[cellIndex] = cellAttributes
                xPos += cellWidth + interItemSpacing
            }

            if bottomRowsSets.contains(section) {
                colHeights -= (maxCellHeightForSection + sectionSpacing)
            }

            yPos += maxCellHeightForSection + sectionSpacing
            collectionViewContentWidth = max(collectionViewContentWidth, xPos)
            xPos = 0
        }
        collectionViewContentHeight = yPos
    }

    private func cellHeights() -> CGFloat {
        var result: CGFloat = 0

        let bottomRowsSet = delegate.getBottomRows(rowCount: rows)
        for section in bottomRowsSet {
            guard let itemsCount = collectionView?.numberOfItems(inSection: section), itemsCount > 0 else { continue }
            let cellSpacing = (section == rows - 1) ? 0 : getSectionSpacing(forRow: section)
            var maximumCellRowHeight: CGFloat = 0
            for col in 0..<itemsCount {
                let cellSize = getCellSize(forRow: section, forCol: col)
                maximumCellRowHeight = max(maximumCellRowHeight, cellSize.height)
            }
            result += maximumCellRowHeight + cellSpacing
        }
        return result
    }

    private func cellsRowWidths() -> [Int: CGFloat] {
        var result: [Int: CGFloat] = [:]

        for section in 0..<rows {
            guard let itemsCount = collectionView?.numberOfItems(inSection: section), itemsCount > 0, !delegate.getRightCols(colCount: itemsCount).isEmpty else {
                continue
            }

            let cols = delegate.getRightCols(colCount: itemsCount)
            let cellSpacing = getInterItemSpacing(forRow: section)

            for col in cols {
                let cellSize = getCellSize(forRow: section, forCol: col)
                let cellSpacing = (col == itemsCount - 1) ? 0 : cellSpacing
                result[section] = (result[section] ?? 0) + cellSize.width + cellSpacing
            }
        }

        return result
    }

    private func updateCellPositions() {
        guard let collectionView = collectionView else {
            return
        }
        let rowSet = delegate.getRows(rowCount: rows)
        for row in 0..<rows {
            let itemCount = collectionView.numberOfItems(inSection: row)
            let colSet = delegate.getCols(colCount: itemCount)
            guard rowSet.contains(row) || !colSet.isEmpty else {
                return
            }

            for col in 0..<itemCount {
                let cellIndex = IndexPath(item: col, section: row)
                let attribute = cellAttrsDict[cellIndex]

                if rowSet.contains(row) {
                    attribute?.frame.origin.y = (cellFramesDict[cellIndex]?.origin.y ?? 0) + collectionView.contentOffset.y
                }

                if colSet.contains(col) {
                    attribute?.frame.origin.x = (cellFramesDict[cellIndex]?.origin.x ?? 0) + collectionView.contentOffset.x
                }
                attribute?.zIndex = zOrder(forRow: row, forCol: col, rowSet: rowSet, colSet: colSet)
            }
        }
    }

    open override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }

    open override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var collectionViewAttributes: [UICollectionViewLayoutAttributes] = []
        for (index, attribute) in cellAttrsDict {
            if delegate.getRightCols(colCount: colsCount(section: index.section)).contains(index.item) {
                collectionViewAttributes.append(attribute)
            } else if rect.intersects(attribute.frame) {
                collectionViewAttributes.append(attribute)
            }
        }
        return collectionViewAttributes
    }

    open override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cellAttrsDict[indexPath]
    }

    private func getCellSize(forRow row: Int, forCol col: Int) -> CGSize {
        guard let collectionView = collectionView,
              let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout,
              let size = delegate.collectionView?(collectionView, layout: self, sizeForItemAt: IndexPath(item: col, section: row)) else {
            return self.itemSize
        }
        return size
    }

    private func getSectionSpacing(forRow row: Int) -> CGFloat {
        guard let collectionView = collectionView,
              let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout,
              let spacing = delegate.collectionView?(collectionView, layout: self, minimumLineSpacingForSectionAt: row) else {
            return self.minimumLineSpacing
        }
        return spacing
    }

    private func getInterItemSpacing(forRow row: Int) -> CGFloat {
        guard let collectionView = collectionView,
              let delegate = collectionView.delegate as? UICollectionViewDelegateFlowLayout,
              let spacing = delegate.collectionView?(collectionView, layout: self, minimumInteritemSpacingForSectionAt: row) else {
            return self.minimumInteritemSpacing
        }
        return spacing
    }

    private enum CellType: Int {
        case basic = 0
        case floating = 1
        case `static` = 2

        var zOrder: Int {
            return self.rawValue
        }
    }

    private func zOrder(forRow row: Int, forCol col: Int, rowSet: Set<Int>, colSet: Set<Int>) -> Int {
        if rowSet.contains(row) && colSet.contains(col) {
            return CellType.static.zOrder
        } else if rowSet.contains(row) || colSet.contains(col) {
            return CellType.floating.zOrder
        } else {
            return CellType.basic.zOrder
        }
    }
}

protocol ___TABLE___ListFormControllerLayoutDelegate: UICollectionViewDelegateFlowLayout { //swiftlint:disable:this class_delegate_protocol
    var rowsFromTop: Int { get }
    var rowsFromBottom: Int { get }
    var colsFromLeft: Int { get }
    var colsFromRight: Int { get }
}

extension ___TABLE___ListFormControllerLayoutDelegate {

    public func getRows(rowCount: Int) -> Set<Int> {
        return getTopRows(rowCount: rowCount).union(getBottomRows(rowCount: rowCount))
    }

    public func getCols(colCount: Int) -> Set<Int> {
        return getLeftCols(colCount: colCount).union(getRightCols(colCount: colCount))
    }

    public func getLeftCols(colCount: Int) -> Set<Int> {
        return getSet(totalLength: colCount, startIndex: 0, count: colsFromLeft)
    }

    public func getRightCols(colCount: Int) -> Set<Int> {
        return getSet(totalLength: colCount, startIndex: colCount - colsFromRight, count: colsFromRight)
    }

    public func getBottomRows(rowCount: Int) -> Set<Int> {
        return getSet(totalLength: rowCount, startIndex: rowCount - rowsFromBottom, count: rowsFromBottom)
    }

    public func getTopRows(rowCount: Int) -> Set<Int> {
        return getSet(totalLength: rowCount, startIndex: 0, count: rowsFromTop)
    }

    private func getSet(totalLength: Int, startIndex: Int, count: Int) -> Set<Int> {
        let setCount = min(totalLength, count)
        let startIndex = max(startIndex, 0)
        return setCount > 0 ? Set<Int>(startIndex...startIndex + setCount - 1) : Set()
    }
}
