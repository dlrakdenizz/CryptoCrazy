//
//  Webservice.swift
//  CryptoCrazy
//
//  Created by Dilara Akdeniz on 24.09.2024.
//

import Foundation

class Webservice {
    
    enum CryptoError : Error { //enum ile hata sınıfı oluşturuyoruz aslında. Result bize başarı veya error döndürmeli o yüzden kesinlikle burası Error protokolünü confirm etmeli.
        case serverError //Server kaynaklı bir hata olmuş olabilir.
        case parsingError //Benim parse etmem ile alakalı bir hata olmuş olabilir.
    }
    
    //URLSession kısmında url direkt verebilirdik ama input almak daha profesyonel o yüzden url input aldık ve gelen url'yi dataTask(with: url) kısmına koyduk.
    func downloalCurrencies(url: URL, completion: @escaping (Result<[Crypto], CryptoError>) -> ()) { //Bu kısımda escaping kullanarak clousure oluşturuyoruz. Direkt @escaping (Crypto) -> () diyebiliriz bu durumda bu fonksiyondan Crypto döndüğünde bu kısım çalışır ve bu fonksiyon çalıştırıldığında direkt Crypto hazır olarak elimizde olur ama biz bunun yerine hem Error hem de Crypto dönsün istiyoruz. Çünkü verileri tam olarak alamama ihtimalimiz de var. Result yapısını bu yüzden kullanıyoruz. Result Swift'de başarıyı veya başarısızlığı simgeleyen bir yapıdır.
        
        URLSession.shared.dataTask(with: url) { data, response, error in //Completion Handler kısmı cevap geldikten sonra çalışır. Bizim de amacımız bir completion handler bloğu yazarak cevap geldikten sonra veriyi almak ve view controllerda vs o veriyi kullanmak. Bunun içinde kendi fonksiyonumuz içerisinde completion olarak bir parametre dah açtık.
            
            if let error = error { //if let _ = error şeklinde de yazılabilir
                completion(.failure(.serverError)) //Bu kısım şu şekilde de yazılabilir: completion(Result.failure(CryptoError.serverError))
            } else if let data = data {
                
                let cryptoList = try? JSONDecoder().decode([Crypto].self, from: data) //Crpto sadece currency ve pricedan oluşan bir obje ama JSON bize bundan 2000 tane döndürüyor o yüzden dizi içinde yazdık.
                if let cryptoList = cryptoList {
                    completion(.success(cryptoList))
                } else {
                    completion(.failure(.parsingError))
                }
            }
        }.resume()
    }
    
}



//@esaping NEDİR?
//Swift'te @escaping, bir closure'ın (kod bloğunun) işlev gövdesinin dışına kaçmasına ve daha sonra çalıştırılmasına izin veren bir işaretçidir. Normalde Swift, bir closure'ı bir işlevin içinde tanımladığınızda, bu closure'ın işlevin süresi boyunca geçerli olacağını varsayar. Ancak, closure işlevin tamamlanmasından sonra çalıştırılacaksa veya işlev dışındaki bir değişkene atanacaksa @escaping kullanılması gerekir.
