//
//  DataFetcher.swift
//  LetsSwap
//
//  Created by Ярослав Карпунькин on 17.12.2020.
//

import Foundation
import UIKit

protocol FeedDataFetcher {
    func getFeed(nextBatchFrom: String?,  completion: @escaping(Result<FeedResponse, FeedError>) -> Void)
    func getOrder(orderId: Int, completion: @escaping (Result<OrderResponse, OrderError>) -> Void) 
}

struct NetworkDataFetcher: FeedDataFetcher {
    private var feedItems = [
        FeedItem(orderId: 1, title: "Научу писать продающие тексты для инстаграма", description: "Научу их писать", counterOffer:
                 "В обмен хочу чтобы ты решил за меня линал", isFavourite: false, isFree: false, date: 12341243, photo: Photo(url: "https://sun1-96.userapi.com/impf/rp8UEZB_5hengfB87Qzi9meVkM875iuzFIwZ5Q/WwNcIJ8ubsc.jpg?size=604x604&quality=96&sign=1d87db91f0b06cc7b52225fb2c6e1a24&c_uniq_tag=X1AatY7EmGZL9oypViBmIxmxxwPlTsylQT7dWBYbafs&type=album")),
        FeedItem(orderId: 2, title: "Научу плавать", description: "Занимаюсь плаваньем профессионально 10 лет", counterOffer: "Научите меня играть на гитаре", isFavourite: true, isFree: false, date: 121341325125, photo: Photo(url: "https://sun1-47.userapi.com/impf/jhF1HkqemHBSyQpzbixJUUA4a5pM7t2ZXeFY5Q/H5yX41gW7FU.jpg?size=604x604&quality=96&sign=3b22b36bed952e41df8b58705867ea1d&c_uniq_tag=JoaN0fGYy83-omJ6xJ3hFrjoM_jRJMbP1QcfipDga6Y&type=album")),
        FeedItem(orderId: 10, title: "Научу кататься на борде", description: "Катаю с детства, знаю огромное количество трюков, обожаю фрирайд, люблю экстримальные виды спорта, а также прогать; Увлекаюсь математикой, поэтому по ходу помогу выучить линал; Да когда эта лента уже закончится ", counterOffer: "Научите меня серфить", isFavourite: true, isFree: false, date: 4198267346, photo: nil),
        FeedItem(orderId: 3, title: "Ухаживаю за животными", description: "Уже несколько лет ухаживаю за животными, у самой свой личный зоопарк", counterOffer: "В обмен хочу научиться чему-то новому", isFavourite: false, isFree: true, date: 1234125125, photo: Photo(url: "https://sun1-21.userapi.com/impf/yLgy-99VKts3d6Lv_ahGp4Vdya_pO8DdQMSZ9A/ZxHfNVrUDTo.jpg?size=604x378&quality=96&sign=34946e652c7b500b3ea4c846c3eb61f4&c_uniq_tag=_ulZQOPWGj95ZTm8yVmU_zfmYRRvpEG2YbBGfy2zTBU&type=album")),
        FeedItem(orderId: 4, title: "Делаю профессиональную фотосъемку", description: "Всю жизнь в модельном бизнесе", counterOffer: "Закройте за меня долги в универе..", isFavourite: true, isFree: false, date: 1241523, photo: Photo(url: "https://sun1-30.userapi.com/impf/PXyjEBA29GMv-BrShS9lAwJftKcl1L7zoKwtRw/GmuWSQIRiFE.jpg?size=453x604&quality=96&sign=89fc7b9a09c8cc4df7257e8109ca8255&c_uniq_tag=JpkLKplffEJgiWSHXoOgh7GSreoWWk0y_mB2iAXs1O8&type=album")),
        FeedItem(orderId: 5, title: "Удалю вирусы с вашего компьютеры", description: "Закончил ФКН, вроде научили этому", counterOffer: "Заберите меня отсюда", isFavourite: true, isFree: true, date: 12341255312, photo: Photo(url: "https://sun1-25.userapi.com/impf/gowlNYuJ6OQDSHupa1-vK03ry7ZaXzy_RooNvg/Hy1Bywuju0o.jpg?size=457x604&quality=96&sign=7d955cdaf86929f81f3d12f8b987a058&c_uniq_tag=JeMuDjshv5N9I8zjjwXfZvqt0v2cr7Cpo5-lbDTjum4&type=album")),
        FeedItem(orderId: 6, title: "Научу разбираться в искусстве", description: "Прочитал много книг, хорошо разбира в искусстве", counterOffer: "В обме хочу научиться чему-то новому", isFavourite: false, isFree: true, date: 12345161363, photo: Photo(url: "https://sun1-88.userapi.com/impf/KZGdkJtVB-AQ9imSxU9RbqU-OgWveyknsm7K6g/qTHsmOrwUNo.jpg?size=483x604&quality=96&sign=e86bd8569b831bd154e0d3fb80bd0504&c_uniq_tag=5crVQs-fadyrOqggKl_yhOI1kWZuCLlhm290z_IMgIY&type=album"))
    ]
    func getFeed(nextBatchFrom: String?, completion: @escaping (Result<FeedResponse, FeedError>) -> Void) {
        completion(.success(FeedResponse(items: feedItems, nextFrom: "nextBatch")))
    }
    
    func getOrder(orderId: Int, completion: @escaping (Result<OrderResponse, OrderError>) -> Void) {
        completion(.success(orderWithId1))
    }
    
    private var orderWithId1 = OrderResponse.init(user: PostedUser(userId: 123, photo: Photo(url: "https://sun1-88.userapi.com/impf/KZGdkJtVB-AQ9imSxU9RbqU-OgWveyknsm7K6g/qTHsmOrwUNo.jpg?size=483x604&quality=96&sign=e86bd8569b831bd154e0d3fb80bd0504&c_uniq_tag=5crVQs-fadyrOqggKl_yhOI1kWZuCLlhm290z_IMgIY&type=album"), name: "Настя", lastName: "Якимова", city: "Санкт-Петербург"),
                order: Order.init(orderId: 1, tags: ["IT, интернет", "Бытовые услуги", "Реклама", "Установка техники"], title: "Делаю необычные тату", description: "Ищу моделей для своего портфолио в инстаграм. Можете посмтреть уже готовые работы @okxytatt", counterOffer: "Я бы хотела научиться читать рэп или взять пару уроков по битбоку.", isFree: true, photoAttachments: [Photo(url: "https://sun1-30.userapi.com/impf/PXyjEBA29GMv-BrShS9lAwJftKcl1L7zoKwtRw/GmuWSQIRiFE.jpg?size=453x604&quality=96&sign=89fc7b9a09c8cc4df7257e8109ca8255&c_uniq_tag=JpkLKplffEJgiWSHXoOgh7GSreoWWk0y_mB2iAXs1O8&type=album"), Photo(url: "https://sun1-88.userapi.com/impf/KZGdkJtVB-AQ9imSxU9RbqU-OgWveyknsm7K6g/qTHsmOrwUNo.jpg?size=483x604&quality=96&sign=e86bd8569b831bd154e0d3fb80bd0504&c_uniq_tag=5crVQs-fadyrOqggKl_yhOI1kWZuCLlhm290z_IMgIY&type=album")
                ]))
    
    
}
