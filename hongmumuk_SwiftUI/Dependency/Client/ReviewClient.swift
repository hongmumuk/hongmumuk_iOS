//
//  ReviewClient.swift
//  hongmumuk_SwiftUI
//
//  Created by Dongwan Ryoo on 7/28/25.
//

import Alamofire
import Dependencies
import SwiftUI

struct ReviewClient {
    var postReview: @Sendable (_ token: String, _ model: WriteReviewModel, _ images: [UIImage]) async throws -> Bool
}

extension ReviewClient: DependencyKey {
    static var liveValue: ReviewClient = .init(
        postReview: { token, model, images in
            let url = "\(Constant.baseUrl)/api/review/create"

            let multipartFormData: (MultipartFormData) -> Void = { formData in
                // 1️⃣ JSON 본문 추가
                if let jsonData = try? JSONEncoder().encode(model) {
                    formData.append(
                        jsonData,
                        withName: "newReviewDto",
                        mimeType: "application/json"
                    )
                }

                // 2️⃣ 이미지 배열 추가
                for image in images {
                    if let data = image.jpegData(compressionQuality: 0.1) {
                        let uuid = UUID().uuidString
                        formData.append(
                            data,
                            withName: "multipartFiles",
                            fileName: "\(uuid).jpg",
                            mimeType: "image/jpeg"
                        )
                    }
                }
            }

            let request = AF.upload(
                multipartFormData: multipartFormData,
                to: url,
                method: .post,
                headers: [
                    "Authorization": "Bearer \(token)"
                ]
            )

            let response = try await request
                .serializingDecodable(ResponseModel<WriteReviewModel>.self)
                .value

            guard response.isSuccess else {
                throw WriteReviewError(rawValue: response.code) ?? .unknown
            }

            return true
        }
    )
}

extension DependencyValues {
    var reviewClient: ReviewClient {
        get { self[ReviewClient.self] }
        set { self[ReviewClient.self] = newValue }
    }
}
