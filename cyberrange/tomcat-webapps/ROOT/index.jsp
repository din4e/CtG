<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>靶场环境 - Tomcat</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
            padding: 40px;
            max-width: 600px;
            width: 100%;
        }
        h1 {
            color: #333;
            margin-bottom: 20px;
            text-align: center;
            font-size: 2.5em;
        }
        .info {
            background: #f8f9fa;
            border-left: 4px solid #f5576c;
            padding: 15px;
            margin: 20px 0;
            border-radius: 5px;
        }
        .info h2 {
            color: #f5576c;
            font-size: 1.2em;
            margin-bottom: 10px;
        }
        .info p {
            color: #666;
            line-height: 1.6;
            margin: 5px 0;
        }
        .links {
            margin-top: 30px;
        }
        .link-item {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 15px 25px;
            margin: 10px 0;
            border-radius: 10px;
            text-decoration: none;
            display: block;
            text-align: center;
            transition: transform 0.3s, box-shadow 0.3s;
        }
        .link-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(245, 87, 108, 0.5);
        }
        .status {
            display: inline-block;
            padding: 5px 15px;
            background: #28a745;
            color: white;
            border-radius: 20px;
            font-size: 0.9em;
            margin-top: 10px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>🎯 靶场环境</h1>
        
        <div class="info">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                <h2 style="margin: 0;">🚀 Tomcat 环境</h2>
                <span class="status">✓ 运行中</span>
            </div>
            <p><strong>服务器：</strong>Apache Tomcat 9.0</p>
            <p><strong>端口：</strong>20001</p>
            <p><strong>Java 版本：</strong><%= System.getProperty("java.version") %></p>
            <p><strong>操作系统：</strong><%= System.getProperty("os.name") %></p>
            <p><strong>Servlet 版本：</strong><%= application.getMajorVersion() %>.<%= application.getMinorVersion() %></p>
            <p><strong>服务器时间：</strong><%= new java.util.Date() %></p>
        </div>

        <div class="info">
            <h2>📋 环境说明</h2>
            <p>这是一个用于测试的 Tomcat 靶场环境。</p>
            <p>WebShell 文件位于 <code>/webshell</code> 目录下。</p>
            <p>支持 JSP、JSPX 文件执行。</p>
        </div>

        <div class="links">
            <a href="/webshell/" class="link-item">
                📁 访问 WebShell 目录
            </a>
        </div>
    </div>
</body>
</html>

