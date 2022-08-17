# UART Receiver
#### A Universal Asynchronous Receiver/Transmitter (UART) is a block of circuitry responsible for implementing serial communication.
#### UART is Full Duplex protocol (data transmission in both directions simultaneously)
![image](https://user-images.githubusercontent.com/82395215/185259313-63de468e-8ae6-451d-8623-57a20c5e6086.png)
#### Transmitting UART converts parallel data from the master device (eg. CPU) into serial form and transmit in serial to receiving UART.
#### Receiving UART will then convert the serial data back into parallel data for the receiving device.
![image](https://user-images.githubusercontent.com/82395215/185259419-8ba137c2-657e-48ac-80cf-c79e75311a30.png)
## Block Interface:
![image](https://user-images.githubusercontent.com/82395215/185259479-39e15695-51e1-48ca-81cc-6beb7d6eee79.png)
## Expected Received Frames:
#### Data Frame (in case of Parity is enabled & Parity Type is even/odd)
![image](https://user-images.githubusercontent.com/82395215/185259906-f83fe6cc-7d6e-4023-8b73-10332d940151.png)
#### Data Frame (in case of Parity is not Enabled)
