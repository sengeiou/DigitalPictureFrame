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
