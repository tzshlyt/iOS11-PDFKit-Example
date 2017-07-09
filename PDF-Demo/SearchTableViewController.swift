//
//  SearchTableViewController.swift
//  PDF-Demo
//
//  Created by lan on 2017/7/5.
//  Copyright © 2017年 com.tzshlyt.demo. All rights reserved.
//

import UIKit
import PDFKit

protocol SearchTableViewControllerDelegate: class {
    func searchTableViewController(_ searchTableViewController: SearchTableViewController, didSelectSerchResult selection: PDFSelection)
}

class SearchTableViewController: UITableViewController {
    open var pdfDocument: PDFDocument?
    weak var delegate: SearchTableViewControllerDelegate?
    
    var searchBar = UISearchBar()
    var searchResults = [PDFSelection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 150

        searchBar.delegate = self
        searchBar.showsCancelButton = true
        searchBar.searchBarStyle = .minimal
        navigationItem.titleView = searchBar
        
        tableView.register(UINib(nibName: "SearchViewCell", bundle: nil), forCellReuseIdentifier: "SearchViewCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.becomeFirstResponder()
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return searchResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchViewCell", for: indexPath) as! SearchViewCell
        
        let selection = searchResults[indexPath.row]
        let page = selection.pages[0]
        let outline = pdfDocument?.outlineItem(for: selection)
        
        let outlintstr = outline?.label ?? ""
        let pagestr = page.label ?? ""
        let txt = outlintstr + " 页码:  " + pagestr
        cell.destinationLabel.text = txt
        
        let extendSelection = selection.copy() as! PDFSelection
        extendSelection.extend(atStart: 10)
        extendSelection.extend(atEnd: 90)
        extendSelection.extendForLineBoundaries()
        
        let range = (extendSelection.string! as NSString).range(of: selection.string!, options: .caseInsensitive)
        let attrstr = NSMutableAttributedString(string: extendSelection.string!)
        attrstr.addAttribute(.backgroundColor, value: UIColor.yellow, range: range)
        
        cell.resultTextLabel.attributedText = attrstr
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selection = searchResults[indexPath.row]
        
        delegate?.searchTableViewController(self, didSelectSerchResult: selection)
        dismiss(animated: false, completion: nil)
    }
    
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}

extension SearchTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        pdfDocument?.cancelFindString()
        dismiss(animated: false, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count < 2 {
            return
        }
        
        searchResults.removeAll()
        tableView.reloadData()
        pdfDocument?.cancelFindString()
        pdfDocument?.delegate = self
        pdfDocument?.beginFindString(searchText, withOptions: .caseInsensitive)
    }
}

extension SearchTableViewController: PDFDocumentDelegate {
    func didMatchString(_ instance: PDFSelection) {
        searchResults.append(instance)
        tableView.reloadData()
    }
}
