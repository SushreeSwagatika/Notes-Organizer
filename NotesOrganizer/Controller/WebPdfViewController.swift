//
//  WebPdfViewController.swift
//  NotesOrganizer
//
//  Created by Sushree Swagatika on 06/03/20.
//  Copyright © 2020 Sushree Swagatika. All rights reserved.
//

import UIKit
import PDFKit
import WebKit

class WebPdfViewController: UIViewController {
    
    var showPDF : Bool!
    
    var pdfView = PDFView()
    var pdfURL: URL!
    
    var webView = WKWebView()
    
    var buttonTitle = ""
    
    var note : Note? = nil
    
    @IBOutlet var txtField: UITextField!
    @IBOutlet var webPdfContainerView: UIView!
    @IBOutlet var btnDownload: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        txtField.text = note?.subtitle
        
        if note == nil {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNote))
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveNote))
        }
    }
    
    @objc func addNote(){
        
        let verifyURL = Utility.shared.canOpenURL(ofString: txtField.text!)
        if verifyURL {
            do {
                let name = getPDFName(from: txtField.text!)
                //                let result = Utility.shared.saveNote(str: txtField.text!, forName: name)
                let result = try DataController.shared.addNote(withTitle: name, andSubtitle: txtField.text!, andTemplateType: showPDF ? TemplateType.PDF.rawValue : TemplateType.Webpage.rawValue)
                switch result
                {
                case .success(let message):
                    print(message)
                case .failure(let error):
                    print(error)
                case .none:
                    print("")
                }
            } catch {
                
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc func saveNote() {
        
        let verifyURL = Utility.shared.canOpenURL(ofString: txtField.text!)
        if verifyURL {
            do {
                let currentNote = note!
                currentNote.subtitle = txtField.text!
                let result = try DataController.shared.updateNote(withNoteId: currentNote.noteId!, updatedNote: currentNote)
                switch result
                {
                case .success(let message):
                    print(message)
                case .failure(let error):
                    print(error)
                case .none:
                    print("")
                }
            } catch {
                
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if showPDF {
            pdfView.frame = webPdfContainerView.frame
            view.addSubview(pdfView)
        } else {
            webView.frame = webPdfContainerView.frame
            webView.navigationDelegate = self
            view.addSubview(webView)
        }
    }
    
    @IBAction func downloadButtonPressed(_ sender: Any) {
        if showPDF {
            guard let url = URL(string: txtField.text!) else {
                // show alert
                return
            }
            
            pdfURL = url
            let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
            
            let downloadTask = urlSession.downloadTask(with: pdfURL)
            downloadTask.resume()
        } else {
            let webString = txtField.text!
            guard let webURL = URL(string: webString) else {
                // show alert
                return
            }
            
            let urlRequest = URLRequest(url: webURL)
            webView.load(urlRequest)
            webView.allowsBackForwardNavigationGestures = true
        }
    }
    
    func viewPDF(url: URL) {
        if let document = PDFDocument(url: pdfURL) {
            DispatchQueue.main.async {
                self.pdfView.document = document
            }
        }
    }
    
    func getPDFName(from urlString:String) -> String {
        return urlString.components(separatedBy: "/").last!
    }
    
}

extension WebPdfViewController:  URLSessionDownloadDelegate, WKNavigationDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        
        // copy from tmp to Doc
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            pdfURL = destinationURL
            viewPDF(url: pdfURL)
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
}
