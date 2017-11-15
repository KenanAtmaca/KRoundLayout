# KRoundLayout
İOS Filter Setup Layout View

![alt tag](https://user-images.githubusercontent.com/16580898/32839345-2bff0e16-ca25-11e7-91ff-9ff179909226.png)

#### Use

```Swift
   roundLayer = KRoundLayout()
   roundLayer.frame = CGRect(x: view.frame.width / 2 - 45, y: view.frame.height - 130, width: 90, height: 90)
   roundLayer.images = [#imageLiteral(resourceName: "l2"),#imageLiteral(resourceName: "l2"),#imageLiteral(resourceName: "l2"),#imageLiteral(resourceName: "l2"),#imageLiteral(resourceName: "l2"),#imageLiteral(resourceName: "l2")]
   roundLayer.titles = ["Talini","Caramel","Hootlin","Scarlet","Iris","Ain"]
   roundLayer.delegate = self
   roundLayer.selectColor = UIColor.white
   roundLayer.action = {
            // code
      }
   view.addSubview(roundLayer)
```

#### Delegate

```Swift
  extension mainVC: KRoundLayoutDelegate {
    func getItem(item: (UIImage, Int)) {
        print(item.1)
    }
 }
```

#### Show & Hide Collections

```Swift
 roundLayer.show()
 roundLayer.hide()
```




## License
Usage is provided under the [MIT License](http://http//opensource.org/licenses/mit-license.php). See LICENSE for the full details.
