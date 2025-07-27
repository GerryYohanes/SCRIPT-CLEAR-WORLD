# 🔧 SCRIPT AUTO FIND X LETTER AND CLEAR WORLD v1.0 

Script otomatis pembersih dan pengelola world Growtopia dengan fitur lengkap dan efisien. Cocok untuk single bot maupun multi-bot. Dirancang untuk meminimalisir banned dan memaksimalkan produktivitas.

---

## ✨ Fitur Utama

- ✍️ **Custom Nama World**
  - Buat nama world acak dengan huruf atau kombinasi huruf & angka.

- 🔄 **2 Mode Otomatis**
  - **Find & Lock Mode**: Cari world kosong lalu langsung dikunci.
  - **Clear Mode**: Bersihkan world yang sudah terkunci.

- 🌱 **Opsi Simpan Seed**
  - Simpan seed hasil break ke world terpisah (opsional).

- 💰 **Ambil Otomatis**
  - Ambil World Lock & Jammer dari storage world otomatis.

- 🤖 **Multi-Bot Support**
  - Banyak bot bisa bekerja di satu world saat proses pembersihan.

- 🔢 **Limit Bot**
  - Atur jumlah maksimum bot dalam satu world agar efisien dan aman.

- 🛡️ **Anti-Banned Strategy**
  - Gunakan bot berbeda untuk break world yang dikunci, mengurangi risiko banned.

- 🔔 **Webhook Ringan & Custom**
  - Semua aktivitas bot dikirim ke webhook. Format lebih ringan dan mudah dibaca.
  - Bisa diedit sesuai kebutuhan.

- 📄 **Log Lengkap**
  - Setiap world yang dibuat tercatat di file TXT.
  - Status & aktivitas bot dilaporkan via Webhook.

- 🧠 **Deteksi Otomatis**
  - Cek apakah world:
    - Sudah datar atau belum
    - Sudah dikunci atau belum
    - Terdeteksi sebagai world nuked

- 🏁 **Info Progress**
  - Notifikasi jika world sudah selesai dibersihkan
  - Menampilkan uptime bot

- 🌍 **Publikasi Otomatis**
  - Otomatis buka world ke publik dan aktifkan Jammer.

- 🗑️ **Trash Otomatis (Opsional)**
  - Item-item tak berguna bisa langsung ditrash.

- ⏱️ **Delay Bisa Diatur**
  - Atur delay buypack, join world, drop, trash, dan lainnya dengan fleksibel.

---

## 👑 Lock Owner: Penguasa Dunia Otomatis!

🔐 Dunia langsung dikunci otomatis  
🛠️ Semua proses setelahnya berjalan sendiri  
🤖 Minim risiko banned, maksimal efisiensi  
📡 Bot bisa langsung mulai bersih-bersih setelah world dikunci

> "Boss Mode ON – Dunia udah dikunci, biarin bot yang kerja! 💼👷‍♂️"

---

## 📦 Contoh Penggunaan

```lua
-- Mulai script dengan mode Find & Lock
scriptMode = "find_lock"

-- Atau dengan mode Clear World
scriptMode = "clear"
