
import UIKit
import AVKit
import AVFoundation
import ZKProgressHUD
import AssetsLibrary
import Photos

class BackgroundVideoColorController: UIViewController {
    @IBOutlet weak var collBgColor: UICollectionView!
    @IBOutlet weak var videoView: UIView!
    
    var arr2 = [ModelBackgroundColor]()
    var playerController = AVPlayerViewController()
    var str = ""
    var path:NSURL!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collBgColor.register(UINib(nibName: "BackgroundColorViewCell", bundle: nil), forCellWithReuseIdentifier: "BackgroundColorViewCell")
        arr2.append(ModelBackgroundColor(uiColor: UIColor.init(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)))
        arr2.append(ModelBackgroundColor(uiColor: UIColor.init(red: 221/255, green: 221/255, blue: 221/255, alpha: 1)))
        arr2.append(ModelBackgroundColor(uiColor: UIColor.init(red: 204/255, green: 204/255, blue: 204/255, alpha: 1)))
        arr2.append(ModelBackgroundColor(uiColor: UIColor.init(red: 187/255, green: 187/255, blue: 187/255, alpha: 1)))
        arr2.append(ModelBackgroundColor(uiColor: UIColor.init(red: 170/255, green: 170/255, blue: 170/255, alpha: 1)))
        arr2.append(ModelBackgroundColor(uiColor: UIColor.init(red: 153/255, green: 153/255, blue: 153/255, alpha: 1)))
        arr2.append(ModelBackgroundColor(uiColor: UIColor.init(red: 136/255, green: 136/255, blue: 136/255, alpha: 1)))
        arr2.append(ModelBackgroundColor(uiColor: UIColor.init(red: 119/255, green: 119/255, blue: 119/255, alpha: 1)))
        arr2.append(ModelBackgroundColor(uiColor: UIColor.init(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)))
        arr2.append(ModelBackgroundColor(uiColor: UIColor.init(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)))
        arr2.append(ModelBackgroundColor(uiColor: UIColor.init(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)))
        arr2.append(ModelBackgroundColor(uiColor: UIColor.init(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)))
        arr2.append(ModelBackgroundColor(uiColor: UIColor.init(red: 102/255, green: 102/255, blue: 102/255, alpha: 1)))
        
        let player = AVPlayer(url: path as URL)
        
        playerController.player = player
        playerController.view.frame.size.height = videoView.frame.size.height
        playerController.view.frame.size.width = videoView.frame.size.width
        playerController.showsPlaybackControls = false
        playerController.view.frame = CGRect(x: 0, y: 0, width: videoView.frame.width, height:  videoView.frame.height)
        
        self.videoView.addSubview(playerController.view)
        playerController.player?.play()

    }
    @IBAction func back(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func save(_ sender: Any) {
        
        let alert = UIAlertController(title: "Save?", message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .default, handler: ({action in
        })))
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: ({action in
            
            self.playerController.player?.pause()
            func createUrlInApp(name: String ) -> URL {
                return URL(fileURLWithPath: "\(NSTemporaryDirectory())\(name)")
            }
            
            func removeFileIfExists(fileURL: URL) {
                do {
                    try FileManager.default.removeItem(at: fileURL)
                } catch {
                    print(error.localizedDescription)
                    return
                }
            }
            guard let filePath = self.path else {
                debugPrint("Video not found")
                return
            }
            
            let furl = createUrlInApp(name: "MM.MOV")
            removeFileIfExists(fileURL: furl)
            
            
            let a = "-i \(filePath)  -aspect 1:1 -vf \"pad=iw:ih*2:iw/1:ih/2:color=\(self.str)\" \(furl)"
            
            DispatchQueue.main.async {
                ZKProgressHUD.show()
            }
            let serialQueue = DispatchQueue(label: "serialQueue")
            serialQueue.async {
                MobileFFmpeg.execute(a)
                CustomPhotoAlbum.sharedInstance.saveVideo(url: furl)
                DispatchQueue.main.async {
                    ZKProgressHUD.dismiss()
                    ZKProgressHUD.showSuccess()
                }
            }
        })))
        present(alert, animated: true, completion: nil)
    }
}

extension BackgroundVideoColorController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arr2.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BackgroundColorViewCell", for: indexPath) as! BackgroundColorViewCell
        let data = arr2[indexPath.row]
        cell.initView(uiColor: data.uiColor )
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:collectionView.frame.width/10, height: collectionView.frame.width)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        playerController.view.backgroundColor = arr2[indexPath.row].uiColor
        switch indexPath.row {
        case 0: str = "eeeeee"
        case 1: str = "dddddd"
        case 2: str = "cccccc"
        case 3: str = "bbbbbb"
        case 4: str = "aaaaaa"
        case 5: str = "999999"
        case 6: str = "888888"
        case 7: str = "777777"
        case 8: str = "666666"
            
        default:
            print(indexPath.row)
        }
        
    }
  
}

