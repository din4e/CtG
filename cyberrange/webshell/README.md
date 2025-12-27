# WebShell 测试文件说明

本目录包含用于测试的各类 WebShell 样本。

## 文件列表

### Behinder（冰蝎）WebShell

#### JSP 版本
- **behinder_3.0_default.jsp** - 标准版本（已更新兼容Java 9+）
  - 使用 `java.util.Base64` 解码
  - 兼容 Java 8-21
  - 默认密码：rebeyond
  - 密钥：e45e329feb5d925b（密码MD5前16位）

- **behinder_3.0_default_java9.jsp** - Java 9+ 优化版本
  - 与上面功能相同
  - 保留作为备用

- **behinder_3.0_default.jspx** - JSPX 格式版本
  - XML格式的JSP
  - 功能与JSP版本相同

#### PHP 版本
- **behinder_3.0_default.php** - PHP WebShell
  - 支持 PHP 5.4+
  - 默认密码：rebeyond

#### ASP/ASPX 版本
- **behinder_3.0_default.asp** - ASP WebShell
  - 用于 Windows IIS + ASP 环境
  - 默认密码：rebeyond

- **behinder_3.0_default.aspx** - ASP.NET WebShell
  - 用于 Windows IIS + ASP.NET 环境
  - 默认密码：rebeyond

### 其他文件
- **index.html** - 目录索引页面

## 使用说明

### 1. 访问地址

#### Docker 环境
```bash
# PHP WebShell
http://localhost:20000/webshell/behinder_3.0_default.php

# JSP WebShell
http://localhost:20001/webshell/behinder_3.0_default.jsp
```

#### Vagrant Linux 环境
```bash
# PHP WebShell
http://localhost:20020/webshell/behinder_3.0_default.php
http://192.168.56.10/webshell/behinder_3.0_default.php

# JSP WebShell
http://localhost:20021/webshell/behinder_3.0_default.jsp
http://192.168.56.10:8080/webshell/behinder_3.0_default.jsp
```

#### Vagrant Windows 环境
```bash
# ASP WebShell
http://localhost:20022/webshell/behinder_3.0_default.asp
http://192.168.56.20/webshell/behinder_3.0_default.asp

# ASPX WebShell
http://localhost:20022/webshell/behinder_3.0_default.aspx
http://192.168.56.20/webshell/behinder_3.0_default.aspx
```

### 2. 连接工具

使用 **冰蝎 (Behinder)** 客户端连接：
- 下载地址：https://github.com/rebeyond/Behinder
- 默认密码：`rebeyond`
- 连接URL：上述任意地址

### 3. 常见问题

#### Java 版本兼容性
- **问题**: JSP文件报错 `sun.misc.BASE64Decoder cannot be resolved`
- **原因**: Java 9+ 移除了 `sun.misc.BASE64Decoder`
- **解决**: 
  - 使用 `behinder_3.0_default.jsp`（已更新）
  - 或使用 `behinder_3.0_default_java9.jsp`

#### 权限问题
```bash
# Linux 环境
vagrant ssh linux
sudo chmod -R 755 /var/www/html/webshell
sudo chmod -R 755 /opt/tomcat/webapps/ROOT/webshell

# 重启服务
sudo systemctl restart apache2
sudo systemctl restart tomcat
```

#### Windows IIS 配置
确保IIS启用了ASP和ASP.NET支持：
```powershell
# 在Windows虚拟机中
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASP
Enable-WindowsOptionalFeature -Online -FeatureName IIS-ASPNET45
iisreset
```

## ⚠️ 安全警告

**这些WebShell文件仅用于安全测试和教育目的！**

- ❌ 不要上传到生产环境
- ❌ 不要用于非法用途
- ✅ 仅在受控的测试环境中使用
- ✅ 测试完成后及时清理

## 技术细节

### Behinder 加密机制
- 使用AES加密通信
- 密钥为连接密码的MD5值前16位
- 默认密码 `rebeyond` → MD5 → `e45e329feb5d925b`

### Base64 编码变更
```java
// Java 8 及以前（已废弃）
sun.misc.BASE64Decoder().decodeBuffer(data)

// Java 8+ 标准API（推荐）
java.util.Base64.getDecoder().decode(data)
```

## 参考资料

- Behinder 官方仓库：https://github.com/rebeyond/Behinder
- WebShell 检测与防护：https://github.com/tennc/webshell
- OWASP WebShell 防护指南：https://owasp.org/www-community/attacks/Web_Shell

