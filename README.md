AES
🔐 AES-128 Encryption & Decryption in Verilog
This project implements AES-128 encryption and AES-128 decryption pipelines in Verilog HDL, suitable for FPGA or ASIC designs. The design is fully pipelined and follows the 10-round AES standard, including all transformations and a key expansion module.

📁 Project Structure
cipher_text_generation.v — Top-level AES encryption pipeline

cipher_text_recovery.v — Top-level AES decryption pipeline

key_expansion.v — Key schedule (generates all round keys)

add_round_key.v — XOR state with round key

aes_sub_bytes.v — S-Box substitution logic

inv_sbox.v — Inverse S-Box substitution logic

row_shift.v — ShiftRows transformation

inv_shiftrows.v — Inverse ShiftRows transformation

mixcolumns.v — MixColumns transformation

inv_mixcolumns.v — Inverse MixColumns transformation

sbox.v — AES S-box lookup table

🔧 Top-Level Modules
1️⃣ Encryption — cipher_text_generation
Inputs:

plaintext [127:0] — 128-bit input block to encrypt

key [127:0] — 128-bit AES cipher key

clk — Clock signal

reset — Active-high synchronous reset

valid_in — Input validity flag

Outputs:

ciphertext [127:0] — 128-bit encrypted output

valid_output — Output validity flag

2️⃣ Decryption — cipher_text_recovery
Inputs:

ciphertext [127:0] — 128-bit block to decrypt

key [127:0] — 128-bit AES cipher key

clk — Clock signal

reset — Active-high synchronous reset

valid_in — Input validity flag

Outputs:

plaintext [127:0] — 128-bit recovered plaintext

valid_output — Output validity flag

🚀 Features
✅ Fully 4-segment pipelined 10-round AES encryption & decryption

🔄 Combinational key expansion for round key generation

⏱ Clocked registers for data and key propagation

🔄 Encryption and Decryption use the same key expansion (round keys reversed for decryption)

🧾 Synthesizable on both FPGA and ASIC platforms

🔒 Based on standard AES-128 encryption & decryption flow (FIPS-197)

🧠 AES Flow Breakdown
Encryption:
SubBytes

ShiftRows

MixColumns

AddRoundKey

Decryption:
InvShiftRows

InvSubBytes

AddRoundKey

InvMixColumns

🔁 Pipeline Segments
Segment	AES Rounds Covered
1	key expansion & round 0
2	Rounds 1–3
3	Rounds 4–6
4	Rounds 7–10

📦 How to Use
Include all required modules in your project:

Copy
Edit
cipher_text_generation.v
cipher_text_recovery.v
key_expansion.v
add_round_key.v
aes_sub_bytes.v
inv_sbox.v
row_shift.v
inv_shiftrows.v
mixcolumns.v
inv_mixcolumns.v
sbox.v
Instantiate either cipher_text_generation (encryption) or cipher_text_recovery (decryption) in your top-level module or testbench.

Apply inputs and monitor valid_output for results.

📊 Simulation & Verification
Test with NIST AES-128 test vectors for both encryption & decryption.

Recommended simulation tools:

🧪 ModelSim

🧪 Vivado Simulator

🧪 Icarus Verilog + GTKWave

📜 License
This project is released under the MIT License — you can freely use, modify, and distribute.

👨‍💻 Authors
Aalok Moliya
🔗 GitHub Profile

Shudhanshu Bhadana
🔗 GitHub Profile

Mayank Gangwar
🔗 GitHub Profile# AES
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

- ✅ Fully **4 segment pipelined** 10-round AES encryption  
- 🔄 Combinational **key expansion**  
- ⏱ Clocked registers for data and key propagation  
- 🧾 Synthesizable on both **FPGA** and **ASIC** platforms  
- 🔒 Based on standard AES-128 encryption flow  

---

## 🧠 AES Flow Breakdown

Each AES round includes the following steps:

1. **SubBytes** — Byte-wise substitution using an S-Box  
2. **ShiftRows** — Cyclic row-wise shifting of the state  
3. **MixColumns** — Multiplication with a predefined matrix
4. **AddRoundKey** — XOR of the state with a round key  

---

## 🔁 Pipeline Segments

| Segment | AES Rounds Covered 
|-------|---------------------|
| 1     | key expansion and round 0 | 
| 2     | Rounds 1-3                | 
| 3     | Rounds 4-6                | 
| 4     | round 7-10                |

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




