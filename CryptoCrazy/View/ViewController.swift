//
//  ViewController.swift
//  CryptoCrazy
//
//  Created by Dilara Akdeniz on 24.09.2024.
//



// MVVM(Model-View-ViewModel) yazılım geliştirme mimari düzenidir. Şu ana kadar yapılan applerde her şeyi view controller içerisine yazdık ama bu çok doğru değildir. Çünkü view controller içerisine her şeyi gömmek demek hem VC'ı çok şişirmek hem değişiklik yapılmak istendiğinde tüm kod içerisinde bu değişikliği yapmaya çalışmak hem de unit test kısımlarında zorlanmak demektir.
//MVVM'de Model'den kasıt sınıf ya da struct kısmıdır. View kullanıcının göreceği ön yüzdür. View Model ise business logic ve view kısmının ayrılmasını sağlayan köprüdür. Buna business logic ve presentation ayrılması denir.

//RxSwift ise Swift için geliştirilmiş Reactive Programming'in doğru yapılmasına olanak tanıyan bir araçtır. Reative Programming örneğin view model kısmında değişiklik olduğunda view kısmının ekstra kod yazılmadan otomatik olarak güncellemesini sağlamaktır. (Publisher subscriber - Örneğin youtubeda bir kanala üyeysen yeni video bildirim olarak düşer.Bunun gibi view model'de olabilecek değişiklikleri publish edeceğiz ve buna subscribe olan view'ler değişiklik olduğunda bundan haberdar olacaklar.) (Bunun yerine Apple tarafından üretinelen Combine kütüphanesi de kullanılabilir.)



import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var indicatorView: UIActivityIndicatorView! //View'a activity indicator ekledik. Bu veriler çekilirken gösterilecek olan loading işaretidir. Storyboardda eklendikten sonra özelliklerden Hides When Stopped kısmı seçilmelidir ki gerek olmadığında gözükmesin.
    
    var cryptoList = [Crypto]()
    
    let cryptoVM = CryptoViewModel() //View Model initialize edildi
    let disposeBag = DisposeBag() //RxSwiftten türetilen bir yapıdır. observe ve subscribe işlemleri bittikten sonra hafizada yer tutulmasını önlemek için kullanılan çöp torbası denebilir.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        // JSONSerialization() - İnternette istek attığımızda bize dönen veriyi anlamlandırmak için bu yapıyı kullanmıştık. Ama bunu profesyonel bir şekilde yapmak için bu yapı değil JSONDecoder() yapısını kullanmak gerekir.
        
        /*
        let url = URL(string: "https://raw.githubusercontent.com/atilsamancioglu/K21-JSONDataSet/master/crypto.json")!
        Webservice().downloalCurrencies(url: url) { result in
            switch result{
            case .success(let cryptos):
                self.cryptoList = cryptos
                DispatchQueue.main.async { //URLSession bu işlemi arka planda yapmaya çalışır ama biz ön yüzde bir cryptoList'i göstermeye çalışıyoruz. Biz de DispatchQueue kullanarak main threadde bu işlemi yaptırmış olduk.
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
        */
        //Yukarıdaki kısım ile normalde direkt uygulama çalışır ama bu primitive bir halde. Profesyonel bir şekilde bunu yapmak için View Model'de bu kısmı yazıyoruz.
        
        
        setupBindings()
        cryptoVM.requestData() //View Model içerisindeki fonksiyon. Çağırınca veriler indiriliyor.
        
        
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        var content = cell.defaultContentConfiguration()
        content.text = cryptoList[indexPath.row].currency
        content.secondaryText = cryptoList[indexPath.row].price
        cell.contentConfiguration = content
        return cell
    }
    
    
    private func setupBindings() { //Publish Subject kısmı için oluşturulan fonksiyon. View Model'de bulunan veriler değişirse ne olacak bu kısım için fonksiyon yazılıyor.
        
        cryptoVM
            .loading
            .bind(to: self.indicatorView.rx.isAnimating) //bind Datayı direkt olarak görünüme bağlama özelliğine sahiptir. rx ise RxSwiftten gelen bir özelliktir. bind(to : Bool) -> Hangi görünüme bağlanacak?
            .disposed(by: disposeBag)
        
        cryptoVM
            .error
            .observe(on: MainScheduler.asyncInstance) //Bu kısım DispatchQueue yerine kullanılabilen RxSwift'de olan bir yapıdır.
            .subscribe { errorString in //.subscribe(onNext: <#T##((String) -> Void)?##((String) -> Void)?##(String) -> Void#>) bizden String istiyor. Error kısmında errorString vermiştik onu alıyoruz.
                print(errorString)
            }
            .disposed(by: disposeBag)
        
        cryptoVM
            .cryptos
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { cryptos in
                self.cryptoList = cryptos
                self.tableView.reloadData()
            }.disposed(by: disposeBag)
            
        
    }


}

