# RV32I 5级流水线CPU

基于RISC-V RV32I指令集的5级流水线处理器。

## 架构

- 5级流水线：IF / ID / EX / MEM / WB

- 哈佛结构：指令存储器与数据存储器独立

- 数据冒险：Forwarding + Load-Use Stall

- 控制冒险：Flush

## 指令支持

R型：add, sub, and, or, slt

I型：addi, andi, ori, slti, lw

S型：sw

U型：lui

B型：beq, bne

J型：jal, jalr

## 关键特性

- 流水线寄存器：IF/ID, ID/EX, EX/MEM, MEM/WB（全部时序逻辑）

- 前递单元：MEM→EX, WB→EX 两级前递

- 冒险检测：Load-Use自动stall一周期

- 寄存器堆：先写后读，异步读同步写

## 文件结构

pc.v — 程序计数器

imem.v — 指令存储器

IF_ID.v — IF/ID流水线寄存器

decoder.v — 指令译码

regfile.v — 寄存器堆

control.v — 控制单元

hazard_detection.v — 冒险检测

ID_EX.v — ID/EX流水线寄存器

forwarding.v — 前递单元

alu.v — 算术逻辑单元

EX_MEM.v — EX/MEM流水线寄存器

dmem.v — 数据存储器

MEM_WB.v — MEM/WB流水线寄存器

top.v — 顶层模块

top_tb.v — 测试平台

## 仿真

使用Vivado或Icarus Verilog仿真，测试程序包含16条指令，验证Forwarding、Load-Use Stall、分支跳转等功能。

## 综合

使用Yosys综合，SkyWater 130nm标准单元库。

## 后续计划

- 异常处理（ecall, ebreak, mret）

- CSR寄存器

- 乘除法扩展（M扩展）

- AXI4-Lite总线接口

## License

MIT License
