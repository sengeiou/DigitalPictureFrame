Description
-------------------
It's a simple application acting as Central communicate with Peripheral in this case digital picture frame via Bluetooth. You can modify what pictures or data you want to see at Frame and send it as JSON format.

Bluetooth Terminology
---------------------
 * **Central**: This is the node that is trying to connect to a data source. Think of this as the *client*.
 * **Peripheral**: This is the node that is providing the primary data source. Think of this as the *server*.
 * **Characteristic**: A characteristic can be considered a variable.
 * **Service**: A group of characteristics live under a Service.

 * Central
   * Scanning for peripherals
   * Connecting to a peripheral
   * Disconnecting from a peripheral
   * Discovering services
   * Discovering service's characteristics
   * Subscribing to a characteristic
   * Sending data to a characteristic
   * Receiving data from a characteristic

 * Peripheral
   * Advertising a service and characteristic
   * Adding service and characteristic to the PeripheralManager
   * Detecting of new subscribers to a characteristics
   * Detecting of unsubscribing

![screen](https://user-images.githubusercontent.com/9807660/34362555-6343e97a-ea3a-11e7-8cd9-d17db2d9a6de.jpg)
![screen](https://user-images.githubusercontent.com/9807660/34362556-635a56c4-ea3a-11e7-84bb-b4135d6fabcf.jpg)
![screen](https://user-images.githubusercontent.com/9807660/34362557-637024d6-ea3a-11e7-900e-b95f411eab9f.jpg)
![screen](https://user-images.githubusercontent.com/9807660/34362558-6387e42c-ea3a-11e7-8e29-6bcb6fa5af78.jpg)
![screen](https://user-images.githubusercontent.com/9807660/34362559-639ea1bc-ea3a-11e7-9e4e-e8e0ea79837d.jpg)
![screen](https://user-images.githubusercontent.com/9807660/34362560-63b55d9e-ea3a-11e7-8861-e3d0b27e5eaf.jpg)
![screen](https://user-images.githubusercontent.com/9807660/34362561-63df40f0-ea3a-11e7-9c1a-588ba3dfb342.jpg)
![screen](https://user-images.githubusercontent.com/9807660/34362562-63fb47be-ea3a-11e7-9fb5-630036bece9f.jpg)
![screen](https://user-images.githubusercontent.com/9807660/34362563-645aa326-ea3a-11e7-8053-0d2b0204818d.jpg)
![screen](https://user-images.githubusercontent.com/9807660/34362564-649e5cba-ea3a-11e7-9886-31431a6fbb51.jpg)
![screen](https://user-images.githubusercontent.com/9807660/34362565-64cef582-ea3a-11e7-9e97-c35d5b798de0.jpg)
