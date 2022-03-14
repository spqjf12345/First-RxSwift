//
//  AllBoxFlow.swift
//  First-RxSwift
//
//  Created by JoSoJeong on 2022/03/01.
//

import Foundation
import RxFlow

class AllBoxFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    let rootViewController = UINavigationController()
    
    private let service: AppService
    
    init(withService service: AppService){
        self.service = service
    }
    
    func navigate(to step: Step) -> FlowContributors {
        guard let step = step as? AllStep else { return .none }
        print("boxTap flow in step \(step)")
        switch step {
        case .boxTap:
            return navigateToBoxTap()
        case .textIn(let folderId):
            return navigateToTextIn(with: folderId)
        case .linkIn(let folderId):
            return navigateToLinkIn(with: folderId)
        case .makeFolder:
            return navigateToMakeFolder()
        default:
            return .none
        }
    }
    
    private func navigateToBoxTap() -> FlowContributors {
        let vm = AllBoxViewModel(folderUseCase: FolderUseCase(repository: FolderRepository(folderService: FolderService())))
        let vc = UIStoryboard(name: "AllBox", bundle: nil).instantiateViewController(withIdentifier: "AllBoxViewController") as! AllBoxViewController
        
        //rootViewController.pushViewController(vc, animated: true)
        //return .one(flowContributor: .contribute(withNext: vc))
        
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vm))
    }
    
    private func navigateToTextIn (with folderId: Int)  -> FlowContributors {
        let vm = TextInViewModel(folderId: folderId)
        let vc = TextInViewController.instantiate(withViewModel: vm)
        
//        let vc = UIStoryboard(name: "Phrase", bundle: nil).instantiateViewController(withIdentifier: "TextInViewController") as! TextInViewController
//        rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vm))
    }
    
    private func navigateToLinkIn  (with folderId: Int) -> FlowContributors {
        let vc = UIStoryboard(name: "Link", bundle: nil).instantiateViewController(withIdentifier: "LinkInViewController") as! LinkInViewController
        
        rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNext: vc))
    }
    
    private func navigateToMakeFolder() -> FlowContributors {
        let vc = UIStoryboard(name: "AllBox", bundle: nil).instantiateViewController(withIdentifier: "MakeFolderViewController") as! MakeFolderViewController
        print("MakeFolderViewController")
        rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNext: vc))
    }
}
