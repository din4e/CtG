# 靶场使用说明

## Docker Compose 方式

### 启动服务

```bash
cd cyberrange
docker-compose up -d
```

### 访问地址

- **Linux PHP 环境**: http://localhost:20000/webshell/
- **Linux Tomcat Java 环境**: http://localhost:20001/webshell/

### 停止服务

```bash
docker-compose down
```

### 查看日志

```bash
docker-compose logs -f
```

## Vagrant 方式

### 前置要求

1. 安装 [VirtualBox](https://www.virtualbox.org/)
2. 安装 [Vagrant](https://www.vagrantup.com/)

### 启动 Linux 虚拟机

```bash
cd cyberrange
vagrant up linux
```

访问地址：
- **Apache PHP**: http://192.168.56.10/webshell/
- **Tomcat JSP**: http://192.168.56.10:8080/webshell/

### 启动 Windows 10 虚拟机

```bash
vagrant up windows
```

访问地址：
- **IIS ASP/ASPX**: http://192.168.56.20/webshell/

**注意**: Windows 虚拟机需要较长时间启动，首次启动会自动下载 Windows 10 镜像（约 4GB）。

### 同时启动所有虚拟机

```bash
vagrant up
```

### 停止虚拟机

```bash
# 停止所有
vagrant halt

# 停止特定虚拟机
vagrant halt linux
vagrant halt windows
```

### 销毁虚拟机

```bash
# 销毁所有
vagrant destroy

# 销毁特定虚拟机
vagrant destroy linux
vagrant destroy windows
```

### SSH 连接到 Linux 虚拟机

```bash
vagrant ssh linux
```

## 测试文件说明

webshell 目录包含以下测试文件：

- `behinder_3.0_default.php` - PHP webshell
- `behinder_3.0_default.jsp` - JSP webshell
- `behinder_3.0_default.jspx` - JSPX webshell
- `behinder_3.0_default_java9.jsp` - Java 9+ JSP webshell
- `behinder_3.0_default.asp` - ASP webshell
- `behinder_3.0_default.aspx` - ASPX webshell

## 端口映射

### Docker Compose
- 20000 → PHP Apache (容器内 80)
- 20001 → Tomcat (容器内 8080)

### Vagrant
- Linux: 192.168.56.10 (80, 8080)
- Windows: 192.168.56.20 (80)
- 本地端口转发: 20000 → Linux 80, 20001 → Linux 8080, 20002 → Windows 80

## 故障排除

### Docker 相关问题

1. **端口冲突**: 如果 20000 或 20001 端口被占用，修改 `docker-compose.yml` 中的端口映射
2. **权限问题**: 确保 webshell 目录有正确的读取权限

### Vagrant 相关问题

1. **Windows 虚拟机启动慢**: 首次启动需要下载镜像，请耐心等待
2. **网络问题**: 确保 VirtualBox 网络适配器正常工作
3. **IIS 配置**: 如果 Windows 虚拟机中 IIS 未正确配置，可以手动运行 `windows-setup.ps1` 脚本

