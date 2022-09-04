# Register 8x16 
### •	A register file consists of 8 registers, each register of 16-bit width. 
### •	The register file has read data bus(RdData), write data bus(WrData) and one address bus (Address) used for both read and write operations.
### •	Each register can be read and written by applying a register address to be accessed.
### •	Only one operation (read or write) can be evaluated at a time. 
### •	Write Operation is done only when WrEn is high. 
### •	Read operation is done only when RdEn is high. 
### •	Read and Write operations are done on positive edge of Clock.
### •	All the registers are cleared using Asynchronous active low Reset signal.
## Block Interface:
![image](https://user-images.githubusercontent.com/82395215/184554226-dc35687c-3bdf-43c7-9cf4-608be50246af.png)

