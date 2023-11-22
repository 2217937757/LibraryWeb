<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户注册</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <div class="container">
        <h1>用户注册</h1>
        <form action="RegistResult.jsp" method="post">
            <label for="username">用户名:</label>
            <input type="text" id="username" name="username" required>

            <label for="password">密码:</label>
            <input type="password" id="password" name="password" required>

            <label for="confirmPassword">确认密码:</label>
            <input type="password" id="confirmPassword" name="confirmPassword" required>

            <button type="submit">注册</button>
        </form>
        <p>已有账户？<a href="userLogin.jsp">立即登录</a></p>
        <a href="index.jsp">返回首页</a>
    </div>
</body>
</html>
