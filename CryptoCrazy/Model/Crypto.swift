//
//  Crypto.swift
//  CryptoCrazy
//
//  Created by Dilara Akdeniz on 24.09.2024.
//




// https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json verilerimizi bu urlden alıyoruz. Buradaki verileri "JSON Beautifier" ile görüntülersek bir dizi içerisinde 2000 tane veri verildiğini görebiliriz. Bu verilen 2 özelliği var; currency ve price.
// Eğer bu şekilde basit bir verimiz olmasaydı ve çok karşık olsaydı "quicktype.io" websitesinden verimizi yazıp Swift seçerek modeli oluşturtup direkt projemize ekleme yapabiliriz.



import Foundation

struct Crypto : Codable { //JSONDecoder.decode(type: Decodable.Protocol, from: data) Biz verimizi bu yapıda kullanacağız. Bize decode edilebilen bir veri lazım o yüzden Codable Protocolüne confirm ettik.
    let currency : String
    let price : String  //{"currency":"0XBTC","price":"0.19788058"} hem currency hem de price karşısındaki veri string olarak verilmiş.
}


//Decodable - Encodable - Codable

//Encodable protokolü, bir yapının ya da sınıfın dışarıya veri olarak kodlanabileceğini belirtir. Örneğin, bir Swift nesnesini JSON formatına dönüştürmek istiyorsanız bu protokolü kullanabilirsiniz.
//Decodable protokolü ise, dışarıdan alınan bir veriyi (örneğin JSON) çözümleyip bir Swift nesnesine dönüştürmeye yarar. Verileri dış kaynaktan alıp (API, dosya vs.) nesneye çevirmek için kullanılır.
//Bir veri modelinin hem kodlanabilir (Encodable - dışarıya veri yazılabilir) hem de kod çözülebilir(Decodable - dışarıdan veri alınabilir) olmasını istenirse ikisinin birleşimi olan Codable kullanılabilir.
