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
![image](https://user-images.githubusercontent.com/82395215/185468679-640262dc-b61a-4bc3-98ec-244e243110e1.png)
## Expected Output:
![image](https://user-images.githubusercontent.com/82395215/185469278-3f1443ab-416a-405d-8387-f5e4ed55fd46.png)
## Over-sampling:
#### 1. Over-sampling by 4: This means that the clock speed of UART_RX is 4 times the speed of UART_TX.
![image](https://user-images.githubusercontent.com/82395215/185469436-dcfd05d6-8fcb-431f-a0e8-b865013e5f8f.png)
#### 2. Over-sampling by 8: This means that the clock speed of UART_RX is 8 times the speed of UART_TX.
![image](https://user-images.githubusercontent.com/82395215/185469542-fc6fd76a-ddda-4a56-aadc-7a2aa0b348ce.png)
## Block Diagram:
![image](https://user-images.githubusercontent.com/82395215/185469613-fea8db59-485b-445f-8e14-e2a11e4687e8.png)

