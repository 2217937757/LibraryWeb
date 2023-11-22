<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户注册</title>
</head>
<body>
    <%
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String user_type = "普通用户";

        // 数据库连接信息
        String url = "jdbc:mysql://localhost:3306/Library?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
        String uname = "root";
        String pwd = "root";

        Connection conn = null;
        PreparedStatement checkUsernameStmt = null;
        PreparedStatement insertUserStmt = null;

            // 建立数据库连接
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(url, uname, pwd);

            // 检查用户名是否已存在
            String checkUsernameQuery = "SELECT COUNT(*) FROM users WHERE username=?";
            checkUsernameStmt = conn.prepareStatement(checkUsernameQuery);
            checkUsernameStmt.setString(1, username);
            ResultSet resultSet = checkUsernameStmt.executeQuery();
            resultSet.next();
            int userCount = resultSet.getInt(1);

            if (userCount > 0) {
                out.print("注册失败，当前用户名已存在，重新选用用户名后重试。<a href='userRegister.jsp'>返回注册页面</a>");
            } else {
                // 如果用户名不存在，则执行插入操作
                String insertUserQuery = "INSERT INTO users (username, password, user_type) VALUES (?, ?, ?)";
                insertUserStmt = conn.prepareStatement(insertUserQuery);
                insertUserStmt.setString(1, username);
                insertUserStmt.setString(2, password);
                insertUserStmt.setString(3, user_type);

                int count = insertUserStmt.executeUpdate();
				
                if (count > 0) {
                    response.sendRedirect("userLogin.jsp");
                } else {
                    out.print("注册失败");
                }
            }
    %>
</body>
</html>
