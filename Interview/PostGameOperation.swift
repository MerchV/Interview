//
//  PostGameOperation.swift
//  Interview
//
//  Created by Merch on 2018-02-02.
//  Copyright © 2018 Merch. All rights reserved.
//

import UIKit

class PostGameOperation: BaseOperation {

    private var title: String?
    private var developer: String?
    private var year: String?
    private var image: Data?

    init(coreDataManager: CoreDataManager, title: String?, developer: String?, year: String?, image: Data?) {
        super.init()
        self.coreDataManager = coreDataManager
        self.title = title
        self.developer = developer
        self.year = year
        self.image = image
    }

    override func start() {
        isExecuting = true
        baseUrl.appendPathComponent("Games")
        guard let image = image else { succeeded = false; isFinished = true; return }
        guard let title = title else { succeeded = false; isFinished = true; return }


        let mimeTypeString = (image as NSData).mimeType() ?? "image/jpeg"
        let extensionString = (image as NSData).fileExtension() ?? "jpg"

        let body = NSMutableData()

        body.append("--__MV_BOUNDARY__\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"title\"\r\n\r\n\(title)\r\n".data(using: String.Encoding.utf8)!)



        body.append("--__MV_BOUNDARY__\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(title).\(extensionString)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimeTypeString)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(image)



        body.append("\r\n--__MV_BOUNDARY__--".data(using: String.Encoding.utf8)!)


        var request = URLRequest(url: baseUrl)
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=__MV_BOUNDARY__", forHTTPHeaderField: "Content-Type")


        request.httpBody = body as Data

        URLSession.shared.dataTask(with: request) { [weak self] (data:Data?, response:URLResponse?, error:Error?) in
            guard error == nil else { self?.succeeded = false; self?.isFinished = true; return }
            guard (response as! HTTPURLResponse).statusCode == 200 else { self?.succeeded = false; self?.isFinished = true; return }
            self?.succeeded = true
            self?.isFinished = true

        }.resume()

    }

}
