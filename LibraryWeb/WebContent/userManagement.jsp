<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // 获取用户会话
    HttpSession userSession = request.getSession();
    // 检查用户是否已登录
    Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");

    // 如果用户未登录，重定向到登录页面
    if (loggedIn == null || !loggedIn) {
        response.sendRedirect("userLogin.jsp");
    }
    
    // 数据库连接信息
    String url = "jdbc:mysql://localhost:3306/Library?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String uname = "root";
    String pwd = "root";
    // 获取当前用户的用户名
    String currentUsername = (String) userSession.getAttribute("username");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户管理</title>
    <!-- 可以添加样式链接等 -->
    <link rel="stylesheet" type="text/css" href="css/books.css">
</head>
    
<body>
<div class="container">
    <h2>用户管理</h2>

    <%-- 查看用户列表 --%>
    <div class="flex-container">
        <div class="welcome">
            <p>
                欢迎<%=currentUsername%>！
                <a href="userLogin.jsp">退出登录</a>
            </p>
        </div>
        
        <div class="userBorrowedBooks">
            <a href="books.jsp">图书表</a>
            <a href="userBorrowedBooks.jsp">借阅表</a>
        </div>

        <div class="messages">
            <a href="messages.jsp">留言表</a>
        </div>
    </div>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>用户名</th>
            <th>用户密码</th>
            <th>用户类型</th>
            <th>操作</th>
        </tr>
        <%
            Connection conn = null;
            Statement stmt = null;
            ResultSet rs = null;
            
            // 建立数据库连接
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, uname, pwd);
            stmt = conn.createStatement();

            // 查询用户列表
            String query = "SELECT * FROM users";
            rs = stmt.executeQuery(query);

            // 遍历结果集，显示用户列表
            while (rs.next()) {
                int id = rs.getInt("id");
                String password = rs.getString("password");
                String userType = rs.getString("user_type");
        %>
        <tr>
            <td><%= id %></td>
            <td><%= rs.getString("username") %></td>
            <td><%= password %></td>
            <td><%= userType %></td>
            
    
            <td>
                <!-- 添加删除用户的表单 -->
                <form method="post" action="deleteUser.jsp">
                    <input type="hidden" name="id" value="<%= id %>" />
                    
                    <button type="submit" >删除</button>
                </form>
                <% 
                }
                %>
            </td>
        </tr>
    </table>
</div>
</body>
</html>
