# 靶场搭建

使用 docker 和 vagrant 启动靶场，支持 php/jsp/jspx/asp/aspx 在 Linux/Windows 下的测试。

## 端口总览

| 环境 | 服务 | 宿主机端口 | 容器/虚拟机端口 | 访问地址 |
|------|------|-----------|----------------|----------|
| Docker | PHP Apache | 20000 | 80 | http://localhost:20000/ |
| Docker | Tomcat | 20001 | 8080 | http://localhost:20001/ |
| Vagrant Linux | Apache PHP | 20020 | 80 | http://localhost:20020/ 或 http://192.168.56.10/ |
| Vagrant Linux | Tomcat | 20021 | 8080 | http://localhost:20021/ 或 http://192.168.56.10:8080/ |
| Vagrant Windows | IIS | 20022 | 80 | http://localhost:20022/ 或 http://192.168.56.20/ |

## 环境说明

### Docker Compose 环境

#### PHP Apache 容器 (cyberrange-php)
- **镜像**: php:8.1-apache
- **端口映射**: `20000 → 80`
- **访问地址**: http://localhost:20000/
- **WebShell目录**: http://localhost:20000/webshell/
- **功能**: PHP webshell 测试，支持各类PHP后门

#### Tomcat Java 容器 (cyberrange-tomcat)
- **镜像**: tomcat:9.0-jdk11
- **端口映射**: `20001 → 8080`
- **访问地址**: http://localhost:20001/
- **WebShell目录**: http://localhost:20001/webshell/
- **功能**: JSP/JSPX webshell 测试，支持Java后门
- **JVM参数**: -Xmx512m -Xms256m

### Vagrant 环境

#### Linux 虚拟机 (Ubuntu 20.04)
- **服务配置**:
  - Apache + PHP 8.x
  - Tomcat 9 + JDK 11
- **网络配置**:
  - 虚拟机IP: `192.168.56.10`
  - Apache端口映射: `20020 → 80`
  - Tomcat端口映射: `20021 → 8080`
- **访问地址**:
  - Apache PHP: http://192.168.56.10/ 或 http://localhost:20020/
  - Tomcat JSP: http://192.168.56.10:8080/ 或 http://localhost:20021/
  - WebShell测试目录: `/webshell/`
- **资源分配**: 2GB RAM, 2 CPU

#### Windows 10 虚拟机
- **服务配置**:
  - IIS (支持 ASP/ASPX)
  - .NET Framework 4.5+
  - ASP.NET 支持
- **网络配置**:
  - 虚拟机IP: `192.168.56.20`
  - IIS端口映射: `20022 → 80`
- **访问地址**:
  - IIS: http://192.168.56.20/ 或 http://localhost:20022/
  - WebShell测试目录: `/webshell/`
- **资源分配**: 4GB RAM, 2 CPU
- **注意**: Windows虚拟机启用GUI界面，首次启动需要较长时间

## 快速开始

### Docker Compose
```bash
docker-compose up -d
```

### Vagrant

**首次启动（推荐）：**
```bash
# 仅启动 Linux 虚拟机（快速，推荐）
vagrant up linux

# 启动 Windows 虚拟机（需要较长时间，10-20分钟）
vagrant up windows
```

**同时启动所有虚拟机：**
```bash
vagrant up
```

**注意事项：**
- Linux虚拟机首次启动约需5-10分钟
- Windows虚拟机首次启动约需10-20分钟，请耐心等待
- Windows虚拟机默认不自动启动（需明确指定`vagrant up windows`）
- 可通过GUI界面查看Windows虚拟机配置进度

## WebShell 测试

所有环境的 WebShell 文件都位于 `/webshell/` 目录下，可通过以下URL访问：

### Docker 环境测试
```bash
# PHP WebShell 测试
curl http://localhost:20000/webshell/

# JSP WebShell 测试
curl http://localhost:20001/webshell/
```

### Vagrant 环境测试
```bash
# Linux Apache PHP 测试
curl http://192.168.56.10/webshell/
# 或使用端口映射
curl http://localhost:20020/webshell/

# Linux Tomcat JSP 测试
curl http://192.168.56.10:8080/webshell/
# 或使用端口映射
curl http://localhost:20021/webshell/

# Windows IIS ASP/ASPX 测试
curl http://192.168.56.20/webshell/
# 或使用端口映射
curl http://localhost:20022/webshell/
```

## 环境管理

### 停止环境
```bash
# Docker Compose
docker-compose down

# Vagrant
vagrant halt linux    # 停止 Linux 虚拟机
vagrant halt windows  # 停止 Windows 虚拟机
```

### 重启环境
```bash
# Docker Compose
docker-compose restart

# Vagrant
vagrant reload linux    # 重启 Linux 虚拟机
vagrant reload windows  # 重启 Windows 虚拟机
```

### 销毁环境
```bash
# Docker Compose
docker-compose down -v  # 删除容器和数据卷

# Vagrant
vagrant destroy linux    # 销毁 Linux 虚拟机
vagrant destroy windows  # 销毁 Windows 虚拟机
```

详细使用说明请参考 [USAGE.md](./USAGE.md)

## 文件说明

- `docker-compose.yml` - Docker Compose 配置文件
- `Vagrantfile` - Vagrant 虚拟机配置文件
- `windows-setup.ps1` - Windows IIS 自动配置脚本
- `webshell/` - 测试用的 webshell 文件目录
- `html/` - PHP Apache 根目录（包含 index.php）
- `tomcat-webapps/ROOT/` - Tomcat 根目录（包含 index.jsp）

## 常见问题

### Docker 相关

**Q: Docker容器无法启动？**
```bash
# 检查端口占用
netstat -ano | findstr "20000"
netstat -ano | findstr "20001"

# 查看容器日志
docker-compose logs php-apache
docker-compose logs tomcat
```

**Q: 如何查看容器状态？**
```bash
docker-compose ps
docker-compose logs -f  # 实时查看日志
```

### Vagrant 相关

**Q: Vagrant虚拟机启动失败？**
```bash
# 查看详细日志
vagrant up linux --debug

# 检查VirtualBox是否正常安装
VBoxManage --version

# 重新加载虚拟机配置
vagrant reload linux --provision
```

**Q: 无法访问虚拟机服务？**
```bash
# 检查虚拟机状态
vagrant status

# SSH进入虚拟机检查服务
vagrant ssh linux
systemctl status apache2
systemctl status tomcat

# Windows虚拟机检查IIS
vagrant rdp windows
```

**Q: Windows虚拟机首次启动很慢？**
- 正常现象，Windows虚拟机需要初始化系统和安装IIS组件
- 预计需要10-20分钟完成首次配置
- 可以通过GUI界面查看进度
- 配置脚本会自动输出详细的进度信息

**Q: 文件同步失败？**
```bash
# 重新加载并同步
vagrant reload linux --provision
vagrant reload windows --provision

# 检查共享文件夹
vagrant ssh linux -c "ls -la /tmp/webshell"
```

**Q: Tomcat下载失败？**
- 脚本已配置镜像源备份
- 如果仍失败，可SSH进入虚拟机手动下载：
```bash
vagrant ssh linux
cd /opt
sudo wget https://mirrors.tuna.tsinghua.edu.cn/apache/tomcat/tomcat-9/v9.0.65/bin/apache-tomcat-9.0.65.tar.gz
```

**Q: JSP文件报错 `sun.misc.BASE64Decoder cannot be resolved`？**
- 这是Java版本兼容性问题
- Java 9+ 已移除 `sun.misc.BASE64Decoder`
- 解决方案：
  - 方案1：使用 `behinder_3.0_default_java9.jsp`（推荐）
  - 方案2：原始的 `behinder_3.0_default.jsp` 已更新为使用 `java.util.Base64`
- 重启Tomcat使更改生效：
```bash
vagrant ssh linux
sudo systemctl restart tomcat
```

### 网络相关

**Q: 端口冲突怎么办？**
- Docker: 修改 `docker-compose.yml` 中的端口映射（默认20000-20001）
- Vagrant: 修改 `Vagrantfile` 中的端口映射（默认20020-20022）
- 例如将 `20020:80` 改为 `20030:80`

**Q: 虚拟机IP无法访问？**
```bash
# 检查网络适配器
VBoxManage list hostonlyifs

# 重新配置网络
vagrant reload linux
```

## 性能优化建议

- **Docker环境**: 适合快速测试和CI/CD集成，资源占用小
- **Vagrant Linux**: 更接近真实生产环境，适合深度测试
- **Vagrant Windows**: 资源需求较高，建议至少8GB主机内存

## 快速参考卡片

### 启动命令
```bash
# Docker（推荐快速测试）
docker-compose up -d

# Vagrant Linux（完整环境）
vagrant up linux

# Vagrant Windows（ASP/ASPX测试）
vagrant up windows
```

### 访问地址
| 环境 | 地址 |
|------|------|
| Docker PHP | http://localhost:20000/ |
| Docker Tomcat | http://localhost:20001/ |
| Vagrant Linux Apache | http://localhost:20020/ 或 http://192.168.56.10/ |
| Vagrant Linux Tomcat | http://localhost:20021/ 或 http://192.168.56.10:8080/ |
| Vagrant Windows IIS | http://localhost:20022/ 或 http://192.168.56.20/ |

### 管理命令
```bash
# 查看状态
docker-compose ps           # Docker
vagrant status             # Vagrant

# 停止
docker-compose stop        # Docker
vagrant halt               # Vagrant（所有虚拟机）

# 重启
docker-compose restart     # Docker
vagrant reload --provision # Vagrant（重新配置）

# 删除
docker-compose down -v     # Docker
vagrant destroy -f         # Vagrant
```

### 故障排查
```bash
# 查看日志
docker-compose logs -f php-apache    # Docker PHP
docker-compose logs -f tomcat        # Docker Tomcat
vagrant ssh linux -c "journalctl -xe" # Vagrant Linux

# SSH连接
vagrant ssh linux                    # Linux虚拟机
vagrant rdp windows                  # Windows虚拟机（RDP）

# 重新配置
vagrant reload linux --provision     # 重新执行配置脚本
vagrant reload windows --provision
```

## 🎯 最佳实践

1. **首次使用建议**：先用Docker环境快速测试，确认功能正常
2. **开发测试**：使用Vagrant Linux获得完整的Linux环境
3. **Windows测试**：需要测试ASP/ASPX时再启动Windows虚拟机
4. **资源管理**：不使用时及时停止虚拟机释放资源
5. **备份重要数据**：虚拟机销毁前确保备份测试数据