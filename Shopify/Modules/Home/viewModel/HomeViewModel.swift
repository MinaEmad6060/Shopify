//
//  HomeViewModel.swift
//  Shopify
//
//  Created by Mina Emad on 17/06/2024.
//

import Foundation


class HomeViewModel: HomeViewModelProtocol{
//    var competitionsViewData: [CompetitionsViewData]?
//    var networkManager: NetworkManagerProtocol?
//
//    var bindCompetitionsToViewController : (()->())? = {}
//    var bindTeamsToViewController: (() -> ())?
//    
//    init(){
//        networkManager = NetworkManager()
//    }
//    
//    func getCompetitionsFromNetworkService(){
//        let url = networkManager?.setUrlFormat(baseUrl: Constants.baseUrl, request: "competitions", id: "", query: "") ?? ""
//        competitionsViewData = [CompetitionsViewData]()
//        networkManager?.getFootballDetailsFromApi(url:  url, headers: Constants.headers) {[weak self]  (footballCompetitions: FootballCompetitions) in
//            var competition = CompetitionsViewData()
//            if let competitionList = footballCompetitions.competitions {
//                for i in 0..<competitionList.count {
//                    competition.image = competitionList[i].emblemUrl
//                    competition.longName = competitionList[i].name
//                    competition.shortName = competitionList[i].area?.name
//                    competition.id = competitionList[i].id
//                    self?.competitionsViewData?.append(competition)
//                }
//                self?.bindCompetitionsToViewController?()
//            }
//        }
//    }
}
