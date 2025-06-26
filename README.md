# AES
# 🔐 AES-128 Encryption in Verilog

This project implements an **AES-128 encryption pipeline** in **Verilog HDL**, suitable for **FPGA** or **ASIC** designs. The design is fully **pipelined** and follows the **10-round AES** standard with `SubBytes`, `ShiftRows`, `MixColumns`, and `AddRoundKey` transformations, along with a **key expansion** module.

---

## 📁 Project Structure

- cipher_text_generation.v  — Top-level AES encryption pipeline
- key_expansion.v  — Key schedule (generates all round keys)
- add_round_key.v  — XOR state with round key
- aes_sub_bytes.v — S-Box substitution logic
- row_shift.v  — ShiftRows transformation
- mixcolumns.v  —  MixColumns transformation
- sbox.v   


---

## 🔧 Top-Level Module: `cipher_text_generation`

### 📥 Inputs

- `plaintext [127:0]` — 128-bit input block to encrypt  
- `key [127:0]` — 128-bit AES cipher key  
- `clk` — Clock signal  
- `reset` — Active-high synchronous reset  
- `valid_in` — Input validity flag  

### 📤 Outputs

- `ciphertext [127:0]` — 128-bit encrypted output  
- `valid_output` — Output validity flag  

---

## 🚀 Features

- ✅ Fully **3 stage pipelined** 10-round AES encryption  
- 🔄 Combinational **key expansion**  
- ⏱ Clocked registers for data and key propagation  
- 🧾 Synthesizable on both **FPGA** and **ASIC** platforms  
- 🔒 Based on standard AES-128 encryption flow  

---

## 🧠 AES Flow Breakdown

Each AES round includes the following steps:

1. **SubBytes** — Byte-wise substitution using an S-Box  
2. **ShiftRows** — Cyclic row-wise shifting of the state  
3. **MixColumns** — Mixes the columns of the state (except in the final round)  
4. **AddRoundKey** — XOR of the state with a round key  

---

## 🔁 Pipeline Stages

| Stage | AES Rounds Covered | Registers Used              |
|-------|---------------------|-----------------------------|
| 1     | Rounds 0–3          | `round_keys1`, `block1`, `valid1` |
| 2     | Rounds 4–6          | `round_keys2`, `block2`, `valid2` |
| 3     | Rounds 7–10         | `round_keys3`, `block3`, `valid3` |

---

## 📦 How to Use

1. **Include all required modules** in your project directory:
    - `cipher_text_generation.v`
    - `key_expansion.v`
    - `add_round_key.v`
    - `aes_sub_bytes.v`
    - `row_shift.v`
    - `mixcolumns.v`

2. **Instantiate** the `cipher_text_generation` module in your **top-level module** or **testbench**.

3. **Apply inputs**:
    - Set the `plaintext`, `key`, assert `valid_in`, and toggle `clk`.

4. **Wait for `valid_output`** to go high, then read the `ciphertext`.

---

## 📊 Simulation & Verification

Use any Verilog simulation tool to test the encryption logic:
![image](https://github.com/user-attachments/assets/79975c60-90f2-4b79-bb2b-c9208b3e412d)
![waveform](https://github.com/user-attachments/assets/1950a6ce-85b0-4d52-ac94-2cb1443bfe98)
- 🧪 ModelSim  
- 🧪 Vivado Simulator  
- 🧪 Icarus Verilog + GTKWave  

✅ Validate against **known AES-128 test vectors** from NIST or FIPS publications.

---

## 📜 License

This project is released under the **MIT License** — feel free to use, modify, and distribute.

---

## 👨‍💻 Author

**Aalok Moliya**  
[🔗 GitHub Profile](https://github.com/AalokMoliya)

**Shudhanshu Bhadana**
[🔗 GitHub Profile](https://github.com/SHUDHANSHU-BHADANA)

**Mayank Gangwar**
[🔗 GitHub Profile](https://github.com/MayankGangwar1234)



---




