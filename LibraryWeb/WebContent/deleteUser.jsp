<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>删除用户</title>
</head>
<body>
    <%
        String url = "jdbc:mysql://localhost:3306/Library?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
        String uname = "root";
        String pwd = "root";

        Connection conn = null;
        // 检查借阅情况
        PreparedStatement pstmtCheckBorrowings = null;
        // 删除借阅记录
        PreparedStatement pstmtDeleteBorrowings = null;
     	// 删除留言记录
        PreparedStatement pstmtDeletemessages = null;
        // 删除用户
        PreparedStatement pstmtDeleteUser = null;
        ResultSet rs = null;

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, uname, pwd);

        // 获取要删除的用户的ID和用户类型
        int userId = Integer.parseInt(request.getParameter("id"));
        String userType = "";  // 初始化用户类型

        // 如果用户ID为1，禁止删除
        if (userId == 1) {
            out.println("无法删除管理员用户。<a href='userManagement.jsp'>返回用户管理</a>");
        } else {
                // 检查用户是否有未归还的书籍
                String checkBorrowingsQuery = "SELECT COUNT(*) FROM borrowings WHERE user_id = ? AND return_date IS NULL";
                pstmtCheckBorrowings = conn.prepareStatement(checkBorrowingsQuery);
                pstmtCheckBorrowings.setInt(1, userId);
                rs = pstmtCheckBorrowings.executeQuery();
                rs.next();
                int count = rs.getInt(1);

                if (count > 0) {
                    // 有未归还的书籍，禁止删除
                    out.println("无法删除，该用户还有未归还的书籍。<a href='userManagement.jsp'>返回用户管理</a>");
                } else {
                    // 删除用户之前，删除与用户相关的借阅记录
                    String deleteBorrowingsQuery = "DELETE FROM borrowings WHERE user_id = ?";
                    pstmtDeleteBorrowings = conn.prepareStatement(deleteBorrowingsQuery);
                    pstmtDeleteBorrowings.setInt(1, userId);
                    pstmtDeleteBorrowings.executeUpdate();
                    
                 // 删除用户之前，删除与用户相关的借阅记录
                    String deletemessagesQuery = "DELETE FROM messages WHERE user_id = ?";
                    pstmtDeletemessages = conn.prepareStatement(deletemessagesQuery);
                    pstmtDeletemessages.setInt(1, userId);
                    pstmtDeletemessages.executeUpdate();

                    // 删除用户
                    String deleteUserQuery = "DELETE FROM users WHERE id = ?";
                    pstmtDeleteUser = conn.prepareStatement(deleteUserQuery);
                    pstmtDeleteUser.setInt(1, userId);
                    pstmtDeleteUser.executeUpdate();

                    // 不自动跳转，显示删除成功信息
                    out.println("用户删除成功。<a href='userManagement.jsp'>返回用户管理</a>");
                }
            }

%>
</body>
</html>
