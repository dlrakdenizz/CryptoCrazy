//
//  CryptoViewModel.swift
//  CryptoCrazy
//
//  Created by Dilara Akdeniz on 24.09.2024.
//

import Foundation
import RxSwift //Bu kısımda Publish Subject yapmak için import edilmesi gerekiyor.
import RxCocoa

//Profesyonel dünyada veriyi alıp View controller kısmına erişmek için kullanılan 3 tane yöntem var : 1)RxSwift 2)Combine Framework 3)Delegate Pattern
//RxSwift projeye entegre etmek için Cocoapods, Carthage veya Swift Package Manager kullanılabilir. SPM en çok kullanılandır.

class CryptoViewModel {
    
    let cryptos : PublishSubject<[Crypto]> = PublishSubject()
    let error : PublishSubject<String> = PublishSubject()
    let loading : PublishSubject<Bool> = PublishSubject() //Veri çekilirken loading animasyonu gözükmesi için kullanılır.
    
    
    func requestData() {
        
        self.loading.onNext(true) //Fonksiyonun en başında true yaparak dönmesini sağlar.
        
        let url = URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json")!
        self.loading.onNext(false) //Veri çekilince animasyon sonlanır.
        Webservice().downloalCurrencies(url: url) { result in
            switch result{
            case .success(let cryptos):
                self.cryptos.onNext(cryptos)
                
            case .failure(let error):
                switch error {
                case .parsingError:
                    self.error.onNext("Parsing Error")
                case .serverError:
                    self.error.onNext("Server Error")
                }
            }
        }
        
        
        
        
    }
    
    
    
    
    
}
