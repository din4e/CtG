# Windows IIS 自动配置脚本
# 用于 Vagrant 虚拟机配置

param(
    [switch]$Verbose
)

# 设置错误处理
$ErrorActionPreference = "Stop"

function Write-Step {
    param([string]$Message)
    Write-Host "[$(Get-Date -Format 'HH:mm:ss')] $Message" -ForegroundColor Cyan
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Error-Custom {
    param([string]$Message)
    Write-Host "✗ $Message" -ForegroundColor Red
}

Write-Host "========================================" -ForegroundColor Yellow
Write-Host "Windows IIS 靶场环境配置脚本" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Yellow
Write-Host ""

try {
    # 1. 安装 IIS
    Write-Step "检查 IIS 安装状态..."
    $iisFeature = Get-WindowsOptionalFeature -Online -FeatureName IIS-WebServerRole
    
    if ($iisFeature.State -ne "Enabled") {
        Write-Step "安装 IIS Web 服务器..."
        
        $features = @(
            "IIS-WebServerRole",
            "IIS-WebServer",
            "IIS-CommonHttpFeatures",
            "IIS-StaticContent",
            "IIS-DefaultDocument",
            "IIS-DirectoryBrowsing",
            "IIS-HttpErrors",
            "IIS-HttpRedirect",
            "IIS-ApplicationInit",
            "IIS-HealthAndDiagnostics",
            "IIS-HttpLogging",
            "IIS-LoggingLibraries",
            "IIS-RequestMonitor",
            "IIS-HttpTracing",
            "IIS-Security",
            "IIS-RequestFiltering",
            "IIS-Performance",
            "IIS-HttpCompressionStatic",
            "IIS-WebServerManagementTools",
            "IIS-ManagementConsole",
            "IIS-ManagementScriptingTools",
            "IIS-ManagementService",
            "IIS-IIS6ManagementCompatibility",
            "IIS-Metabase"
        )
        
        foreach ($feature in $features) {
            try {
                Enable-WindowsOptionalFeature -Online -FeatureName $feature -All -NoRestart -WarningAction SilentlyContinue | Out-Null
            } catch {
                if ($Verbose) {
                    Write-Warning "无法启用功能: $feature"
                }
            }
        }
        
        Write-Success "IIS Web 服务器安装完成"
    } else {
        Write-Success "IIS 已安装"
    }
    
    # 2. 安装 ASP 和 ASP.NET
    Write-Step "配置 ASP 和 ASP.NET 支持..."
    
    $aspFeatures = @(
        "IIS-ASP",
        "IIS-ASPNET",
        "IIS-ASPNET45",
        "IIS-NetFxExtensibility",
        "IIS-NetFxExtensibility45",
        "IIS-ISAPIExtensions",
        "IIS-ISAPIFilter"
    )
    
    foreach ($feature in $aspFeatures) {
        try {
            Enable-WindowsOptionalFeature -Online -FeatureName $feature -All -NoRestart -WarningAction SilentlyContinue | Out-Null
        } catch {
            if ($Verbose) {
                Write-Warning "无法启用功能: $feature"
            }
        }
    }
    
    Write-Success "ASP/ASP.NET 支持配置完成"
    
    # 等待服务启动
    Start-Sleep -Seconds 5
    
    # 3. 配置 IIS
    Write-Step "配置 IIS 应用程序池和网站..."
    Import-Module WebAdministration -ErrorAction SilentlyContinue
    
    # 创建应用程序池
    $appPoolName = "CyberRangeAppPool"
    if (-not (Test-Path "IIS:\AppPools\$appPoolName")) {
        New-WebAppPool -Name $appPoolName -Force | Out-Null
        Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name managedRuntimeVersion -Value "v4.0"
        Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name enable32BitAppOnWin64 -Value $true
        Set-ItemProperty "IIS:\AppPools\$appPoolName" -Name startMode -Value "AlwaysRunning"
        Write-Success "应用程序池创建完成: $appPoolName"
    }
    
    # 4. 复制 WebShell 文件
    Write-Step "部署 WebShell 测试文件..."
    $wwwroot = "C:\inetpub\wwwroot"
    $webshellSource = "C:\vagrant-webshell"
    $webshellDest = "$wwwroot\webshell"
    
    if (Test-Path $webshellSource) {
        if (-not (Test-Path $webshellDest)) {
            New-Item -ItemType Directory -Path $webshellDest -Force | Out-Null
        }
        
        Copy-Item "$webshellSource\*" -Destination $webshellDest -Recurse -Force
        Write-Success "WebShell 文件部署完成"
    } else {
        Write-Warning "WebShell 源目录不存在: $webshellSource"
    }
    
    # 创建测试页面
    $indexPath = "$wwwroot\index.html"
    $indexContent = @"
<!DOCTYPE html>
<html>
<head>
    <title>Cyber Range - Windows IIS</title>
    <meta charset="UTF-8">
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: rgba(255,255,255,0.1);
            padding: 40px;
            border-radius: 10px;
            backdrop-filter: blur(10px);
        }
        h1 {
            text-align: center;
            margin-bottom: 30px;
        }
        .info {
            background: rgba(255,255,255,0.2);
            padding: 20px;
            border-radius: 5px;
            margin-bottom: 20px;
        }
        .info h2 {
            margin-top: 0;
        }
        .links {
            display: grid;
            gap: 10px;
        }
        .link-button {
            display: block;
            background: rgba(255,255,255,0.2);
            padding: 15px;
            text-decoration: none;
            color: white;
            border-radius: 5px;
            transition: all 0.3s;
        }
        .link-button:hover {
            background: rgba(255,255,255,0.3);
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎯 Cyber Range - Windows IIS 靶场</h1>
        
        <div class="info">
            <h2>系统信息</h2>
            <p><strong>操作系统:</strong> Windows 10</p>
            <p><strong>Web服务器:</strong> IIS (Internet Information Services)</p>
            <p><strong>支持语言:</strong> ASP, ASP.NET</p>
            <p><strong>虚拟机IP:</strong> 192.168.56.20</p>
        </div>
        
        <div class="info">
            <h2>访问地址</h2>
            <div class="links">
                <a href="/webshell/" class="link-button">📁 WebShell 测试目录</a>
                <a href="http://192.168.56.20/" class="link-button">🌐 虚拟机直接访问</a>
                <a href="http://localhost:20022/" class="link-button">🔗 端口映射访问</a>
            </div>
        </div>
        
        <div class="info">
            <h2>配置时间</h2>
            <p>$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')</p>
        </div>
    </div>
</body>
</html>
"@
    
    Set-Content -Path $indexPath -Value $indexContent -Encoding UTF8
    Write-Success "测试页面创建完成"
    
    # 5. 配置默认网站
    Write-Step "配置默认网站..."
    if (Test-Path "IIS:\Sites\Default Web Site") {
        Set-ItemProperty "IIS:\Sites\Default Web Site" -Name physicalPath -Value $wwwroot
        Set-ItemProperty "IIS:\Sites\Default Web Site" -Name applicationPool -Value $appPoolName
        
        # 启用目录浏览
        Set-WebConfigurationProperty -Filter /system.webServer/directoryBrowse -Name enabled -Value $true -PSPath "IIS:\Sites\Default Web Site"
        
        Write-Success "默认网站配置完成"
    }
    
    # 6. 设置权限
    Write-Step "配置文件权限..."
    $acl = Get-Acl $wwwroot
    
    # 添加 IIS_IUSRS 完全控制权限
    $permission = New-Object System.Security.AccessControl.FileSystemAccessRule(
        "IIS_IUSRS",
        "FullControl",
        "ContainerInherit,ObjectInherit",
        "None",
        "Allow"
    )
    $acl.AddAccessRule($permission)
    
    # 添加 IUSR 读取权限
    $permission2 = New-Object System.Security.AccessControl.FileSystemAccessRule(
        "IUSR",
        "ReadAndExecute",
        "ContainerInherit,ObjectInherit",
        "None",
        "Allow"
    )
    $acl.AddAccessRule($permission2)
    
    Set-Acl $wwwroot $acl
    Write-Success "文件权限配置完成"
    
    # 7. 配置防火墙
    Write-Step "配置防火墙规则..."
    try {
        New-NetFirewallRule -DisplayName "IIS HTTP" -Direction Inbound -Protocol TCP -LocalPort 80 -Action Allow -ErrorAction SilentlyContinue | Out-Null
        Write-Success "防火墙规则配置完成"
    } catch {
        Write-Warning "防火墙规则可能已存在"
    }
    
    # 8. 重启 IIS
    Write-Step "重启 IIS 服务..."
    iisreset /restart | Out-Null
    Start-Sleep -Seconds 3
    
    # 9. 检查服务状态
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Yellow
    Write-Host "服务状态检查" -ForegroundColor Yellow
    Write-Host "========================================" -ForegroundColor Yellow
    
    $services = @("W3SVC", "WAS")
    foreach ($serviceName in $services) {
        $service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue
        if ($service -and $service.Status -eq "Running") {
            Write-Success "$serviceName 运行正常"
        } else {
            Write-Error-Custom "$serviceName 未运行"
        }
    }
    
    # 10. 显示配置摘要
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    Write-Host "Windows IIS 靶场环境配置完成！" -ForegroundColor Green
    Write-Host "========================================" -ForegroundColor Green
    Write-Host ""
    Write-Host "访问地址:" -ForegroundColor Cyan
    Write-Host "  • 虚拟机直接访问: http://192.168.56.20/" -ForegroundColor White
    Write-Host "  • 端口映射访问:   http://localhost:20022/" -ForegroundColor White
    Write-Host "  • WebShell目录:   /webshell/" -ForegroundColor White
    Write-Host "  • RDP远程桌面:    localhost:33389" -ForegroundColor White
    Write-Host ""
    Write-Host "系统信息:" -ForegroundColor Cyan
    Write-Host "  • IIS版本:        $(Get-ItemProperty 'HKLM:\SOFTWARE\Microsoft\InetStp' | Select-Object -ExpandProperty VersionString)" -ForegroundColor White
    Write-Host "  • .NET Framework: $((Get-ChildItem 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP' -Recurse | Get-ItemProperty -Name Version -ErrorAction SilentlyContinue | Select-Object -First 1).Version)" -ForegroundColor White
    Write-Host "  • 应用程序池:     $appPoolName" -ForegroundColor White
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Green
    
} catch {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "配置过程中发生错误！" -ForegroundColor Red
    Write-Host "========================================" -ForegroundColor Red
    Write-Host "错误信息: $_" -ForegroundColor Red
    Write-Host ""
    
    if ($Verbose) {
        Write-Host "详细错误信息:" -ForegroundColor Yellow
        Write-Host $_.Exception | Format-List -Force
        Write-Host $_.ScriptStackTrace
    }
    
    exit 1
}
