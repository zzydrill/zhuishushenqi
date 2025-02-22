//
//  ZSMyViewModel.swift
//  zhuishushenqi
//
//  Created by yung on 2018/10/20.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import AdSupport
import ZSAPI
import RxSwift

class ZSMyViewModel: NSObject, ZSRefreshProtocol {
    
    var refreshStatus: Variable<ZSRefreshStatus> = Variable(.none)
    
    let webService = ZSMyService()
    
    let loginService = ZSLoginService()
    
    var account:ZSAccount?
    
    var coin:ZSCoin?
    
    var detail:ZSUserDetail?
    
    var bind:ZSUserBind?
    
    var useableVoucher:[ZSVoucher] = []
    var unuseableVoucher:[ZSVoucher] = []
    var expiredVoucher:[ZSVoucher] = []
    
    func fetchAccount(token:String ,completion:@escaping ZSBaseCallback<ZSAccount>) {
        webService.fetchAccount(token: token) { [weak self](account) in
            guard let sSelf = self else { return }
            sSelf.account = account
            completion(account)
        }
    }

    func fetchCoin(token:String, completion:@escaping ZSBaseCallback<ZSCoin>) {
        webService.fetchCoin(token: token) { [weak self](coin) in
            guard let sSelf = self else { return }
            sSelf.coin = coin
            completion(coin)
        }
    }
    
    func fetchDetail(token:String, completion:@escaping ZSBaseCallback<ZSUserDetail>) {
        webService.fetchDetail(token: token) { [weak self](detail) in
            guard let sSelf = self else { return }
            sSelf.detail = detail
            completion(detail)
        }
    }
    
    func fetchUserBind (token:String, completion:@escaping ZSBaseCallback<ZSUserBind>) {
        webService.fetchUserBind(token: token) { [weak self](bind) in
            guard let sSelf = self else { return }
            sSelf.bind = bind
            completion(bind)
        }
    }
    
    func fetchLogout(token:String, completion:@escaping ZSBaseCallback<[String:Any]>) {
        webService.fetchLogout(token: token) { (json) in
            completion(json)
        }
    }
    
    func fetchSMSCode(param:[String:String]?, completion:@escaping ZSBaseCallback<[String:Any]>) {
        let mobile = param?["mobile"] ?? ""
        let randstr = param?["Randstr"] ?? ""
        let ticket = param?["Ticket"] ?? ""
        let captchaType = param?["captchaType"] ?? ""
        let type = param?["type"] ?? ""
        let api = ZSAPI.SMSCode(mobile: mobile, Randstr: randstr, Ticket: ticket, captchaType: captchaType, type: type)
        loginService.fetchSMSCode(url: api.path, parameter: api.parameters) { (json) in
            completion(json)
        }
    }
    
    func mobileLogin(mobile:String, smsCode:String, completion:@escaping ZSBaseCallback<ZSQQLoginResponse>) {
        let version = "2"
        let platform_code = "mobile"
        let idfa = ASIdentifierManager.shared().advertisingIdentifier.uuidString
        let api = ZSAPI.mobileLogin(mobile: mobile, idfa: idfa, platform_code: platform_code, smsCode: smsCode, version: version)
        loginService.mobileLgin(urlString: api.path, param: api.parameters) { (json) in
            completion(json)
        }
    }
    
    func fetchNicknameChange(nickname:String, token:String, completion:@escaping ZSBaseCallback<[String:Any]>) {
        let api = ZSAPI.nicknameChange(nickname: nickname, token: token)
        webService.fetchNicknameChange(url: api.path, param: api.parameters) { (json) in
            completion(json)
        }
    }
    
//    https://api.zhuishushenqi.com/voucher?token=xAk9Ac8k3Jj9Faf11q8mBVPQ&type=useable&start=0&limit=20
    func fetchVoucher(token:String, type:String, start:Int, limit:Int, completion:@escaping ZSBaseCallback<[ZSVoucher]>) {
        let api = QSAPI.voucherList(token: token, type: type, start: start, limit: limit)
        webService.fetchVoucherList(url: api.path, param: api.parameters) { [weak self](vouchers) in
            guard let sSelf = self else { return }
            if type == "useable" {
                sSelf.useableVoucher = vouchers ?? []
            } else if type == "unuseable" {
                sSelf.unuseableVoucher = vouchers ?? []
            } else {
                sSelf.expiredVoucher = vouchers ?? []
            }
            sSelf.refreshStatus.value = .headerRefreshEnd
            completion(vouchers)
        }
    }
    
    func fetchMoreVoucher(token:String, type:String, start:Int, limit:Int, completion:@escaping ZSBaseCallback<[ZSVoucher]>) {
        let api = QSAPI.voucherList(token: token, type: type, start: start, limit: limit)
        webService.fetchVoucherList(url: api.path, param: api.parameters) { [weak self](vouchers) in
            guard let sSelf = self else { return }
            if type == "useable" {
                sSelf.useableVoucher.append(contentsOf: vouchers ?? [])
            } else if type == "unuseable" {
                sSelf.unuseableVoucher.append(contentsOf: vouchers ?? [])
            } else {
                sSelf.expiredVoucher.append(contentsOf: vouchers ?? [])
            }
            sSelf.refreshStatus.value = .footerRefreshEnd
            completion(vouchers)
        }
    }
    
}
