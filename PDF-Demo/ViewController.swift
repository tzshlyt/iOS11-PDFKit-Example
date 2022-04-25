//
//  ViewController.swift
//  PDF-Demo
//
//  Created by lan on 2017/6/27.
//  Copyright © 2017年 com.tzshlyt.demo. All rights reserved.
//

import UIKit
import PDFKit

class ViewController: UIViewController {
    private var pdfdocument: PDFDocument?
    
    private var pdfview: PDFView!
    private var pdfThumbView: PDFThumbnailView!
    private lazy var toolView = ToolView.instanceFromNib()
    private weak var observe : NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pdfview = PDFView()
        
        let url = Bundle.main.url(forResource: "sample", withExtension: "pdf")
        pdfdocument = PDFDocument(url: url!)
        
        pdfview.document = pdfdocument
        pdfview.displayMode = .singlePageContinuous
        pdfview.autoScales = true
        view.addSubview(pdfview)
        
        pdfThumbView = PDFThumbnailView()
        pdfThumbView.layoutMode = .horizontal
        pdfThumbView.pdfView = pdfview
        pdfThumbView.backgroundColor = UIColor.red
        view.addSubview(pdfThumbView)
        
        view.addSubview(toolView)
        toolView.bringSubviewToFront(view)
        
        toolView.thumbBtn.addTarget(self, action: #selector(thumbBtnClick), for: .touchUpInside)
        toolView.outlineBtn.addTarget(self, action: #selector(outlineBtnClick), for: .touchUpInside)
        toolView.searchBtn.addTarget(self, action: #selector(searchBtnClick), for: .touchUpInside)
       
        pdfThumbView.translatesAutoresizingMaskIntoConstraints = false
        pdfThumbView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfThumbView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfThumbView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        pdfThumbView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        toolView.translatesAutoresizingMaskIntoConstraints = false
        toolView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        toolView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        toolView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        toolView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        pdfview.translatesAutoresizingMaskIntoConstraints = false
        pdfview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        pdfview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        pdfview.topAnchor.constraint(equalTo: pdfThumbView.bottomAnchor, constant: 0).isActive = true
        pdfview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        let tapgesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture(_:)))
        view.addGestureRecognizer(tapgesture)
    }
    
    @objc func tapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        UIView.animate(withDuration: CATransaction.animationDuration()) {
            self.toolView.alpha = 1 - self.toolView.alpha
        }
    }
    
    @objc func thumbBtnClick(sender: UIButton!) {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
        
        let width = (view.frame.width - 10 * 4) / 3
        let height = width * 1.5
        
        layout.itemSize = CGSize(width: width, height: height)
        layout.sectionInset = UIEdgeInsets.init(top: 10, left: 10, bottom: 10, right: 10)
        
        let thumbnailGridViewController = ThumbnailGridViewController(collectionViewLayout: layout)
        thumbnailGridViewController.pdfDocument = pdfdocument
        thumbnailGridViewController.delegate = self
        
        let nav = UINavigationController(rootViewController: thumbnailGridViewController)
        present(nav, animated: false, completion:nil)
    }
    
    @objc func outlineBtnClick(sender: UIButton) {
        
        if let pdfoutline = pdfdocument?.outlineRoot {
            let oulineViewController = OulineTableviewController(style: UITableView.Style.plain)
            oulineViewController.pdfOutlineRoot = pdfoutline
            oulineViewController.delegate = self
            
            let nav = UINavigationController(rootViewController: oulineViewController)
            self.present(nav, animated: false, completion:nil)
        }
    }
    
    @objc func searchBtnClick(sender: UIButton) {
        let searchViewController = SearchTableViewController()
        searchViewController.pdfDocument = pdfdocument
        searchViewController.delegate = self
        
        let nav = UINavigationController(rootViewController: searchViewController)
        self.present(nav, animated: false, completion:nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: OulineTableviewControllerDelegate {
    func oulineTableviewController(_ oulineTableviewController: OulineTableviewController, didSelectOutline outline: PDFOutline) {
        let action = outline.action
        if let actiongoto = action as? PDFActionGoTo {
            pdfview.go(to: actiongoto.destination)
        }
    }
}

extension ViewController: ThumbnailGridViewControllerDelegate {
    func thumbnailGridViewController(_ thumbnailGridViewController: ThumbnailGridViewController, didSelectPage page: PDFPage) {
        pdfview.go(to: page)
    }
}

extension ViewController: SearchTableViewControllerDelegate {
    func searchTableViewController(_ searchTableViewController: SearchTableViewController, didSelectSerchResult selection: PDFSelection) {
        selection.color = UIColor.yellow
        pdfview.currentSelection = selection
        pdfview.go(to: selection)
    }
}
