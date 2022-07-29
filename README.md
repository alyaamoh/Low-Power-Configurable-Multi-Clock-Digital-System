# Low-Power-Configurable-Multi-Clock-Digital-System
It is in charge of receiving commands through a UART RX to do system functions as register file R/W or doing some processing using ALU block and send result with CRC bits using 4-Bytes frame with UART TX.
![image](https://user-images.githubusercontent.com/82395215/181769968-c8e069ba-7c00-40d0-9419-5375f73a5dc8.png)
## This system contains 9 blocks :
### Clock Domain 1 (REF_CLK):
#### . RegFile
#### . ALU
#### . Clock Gating
#### . SYS_CTRL
### Clock Domain 2 (UART_CLK):
#### . UART_TX
#### . UART_RX
#### . Clock Divider
### Synchronizers:
#### . RST Synchronizer
#### . Data Synchronizer
