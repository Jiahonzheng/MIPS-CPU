# 数字电子技术 - 单周期非流水线处理器

> 郑佳豪 16305204
>
> 基于 `MIPS` 指令集的单周期非流水线处理器

## 目录说明

- `dist/` ：`Vivado` 工程文件压缩包
- `report/` ：项目报告
- `src/` ：实现文件，需添加至 `Design Sources`
- `test/` ：测试文件，用于测试单周期处理器是否能正常工作
- `testbench/` ：仿真文件，需添加至 `Simulation Sources`

## 运行

考虑到 `Vivado` 版本问题，这里提供了两种运行本项目的方式。

注意：**使用 `Vivado` 模拟运行时，请务必将 `InstructionMemory.v` 的 `readmemh` 路径修改为 `test/ROM.txt` 的绝对路径，注意 `/` 符号的使用**。

### 方式一

解压 `dist/` 下的压缩文件，使用 `Vivado` 打开工程文件，本项目使用了 `Vivado 2018.3` 版本，可能对旧版本不兼容。若出现兼容问题，请使用方法二。

### 方式二

- 新建 `Vivado` 工程
- 添加 `src/` 下的所有文件至 `Design Sources`
- 添加 `testbench` 下的所有文件至 `Simulation Sources`
