# Low Power Configurable Multi Clock Digital System
It is in charge of receiving commands through a UART RX to do system functions as register file R/W or doing some processing using ALU block and send result with CRC bits using 4-Bytes frame with UART TX.
![image](https://user-images.githubusercontent.com/82395215/181769968-c8e069ba-7c00-40d0-9419-5375f73a5dc8.png)
## This system contains 10 blocks :
### Clock Domain 1 (REF_CLK):
1. RegFile
2. ALU
3. Clock Gating
4. SYS_CTRL
### Clock Domain 2 (UART_CLK):
1. UART_TX
2. UART_RX
3. Clock Divider
### Synchronizers:
1. RST Synchronizer
2. Data Synchronizer
3. Bit Synchronizer
## Supported Operations: 
### ALU Operations: 
#### 1. Addition.         
#### 2. Subtraction.      
#### 3. Multiplication.   
#### 4. Division.             
#### 5. AND.
#### 6. OR.
#### 7. NAND.
#### 8. NOR.
#### 9. XOR.
#### 10. XNOR.
#### 11. CMP: A = B.
#### 12. CMP: A > B.
#### 13. SHIFT: A >> 1.
#### 14. SHIFT: A << 1.
### Register File Operations:
#### 1. Register File Write.
#### 2. Register File read.
## Supported Commands:
### 1. Register File Write command (3 frames):
![image](https://user-images.githubusercontent.com/82395215/184890451-98d705d5-b0ec-4bf0-8f70-97abaa23a506.png)
### 2. Register File Read command (2 frames):
![image](https://user-images.githubusercontent.com/82395215/184890606-5985a7f2-3ae1-4f3a-8922-94c531c1e801.png)
### 3. ALU Operation command with operand (4 frames):
![image](https://user-images.githubusercontent.com/82395215/184890734-8052e602-c5b1-43f3-a3cd-39ecdf7b6e55.png)
### 4. ALU Operation command with No operand (2 frames):
![image](https://user-images.githubusercontent.com/82395215/184890865-b7f0d515-9607-4484-ba23-32e0613c66d2.png)
## System Specifications:
#### 1. Reference clock (REF_CLK) is 50 MHz.
#### 2. UART clock (UART_CLK) is 9.6 KHz.
#### 3. Div_ratio is 8.
#### 4. Clock Divider is always on (clock divider enable = 1).
## Sequence of Operation: 
#### 1. Initially configuration operations are performed through Register file write operations in addresses (0x2, 0x3).
#### 2. The Master (Testbench) start to send different commands (RegFile Operations, ALU operations).
#### 3. Our system will receive the command frames through UART_RX, it sent to the SYS_CTRL block to be processed.
#### 4. Once the operation of the command is performed using ALU/RegFile, SYS_CTRL sends the result to the master through UART_TX.
#### 5. Register File Address Range for normal write/read operations (From 0x4 to 0x15).
#### 6. Register File Addresses reserved for configurations and ALU operands (From 0x0 to 0x3).
