<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户登录</title>
    <link rel="stylesheet" type="text/css" href="css/style.css">
</head>
<body>
    <div class="container">
        <h1>用户登录</h1>
        <form action="LoginResult.jsp" method="post">
            <label for="username">用户名:</label>
            <input type="text" id="username" name="username" required>

            <label for="password">密码:</label>
            <input type="password" id="password" name="password" required>

            <button type="submit">登录</button>
        </form>
        <p>还没有账户？<a href="userRegister.jsp">立即注册</a></p>
        <a href="index.jsp">返回首页</a>
    </div>
</body>
</html>
