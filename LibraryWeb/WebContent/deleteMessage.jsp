<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String url = "jdbc:mysql://localhost:3306/Library?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String uname = "root";
    String pwd = "root";

    Connection conn = null;
    PreparedStatement pstmtDeleteMessage = null;

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, uname, pwd);

        // 获取要删除的留言的ID
        int messageId = Integer.parseInt(request.getParameter("message_id"));

        // 使用ID从数据库中删除留言记录
        String deleteMessageQuery = "DELETE FROM messages WHERE id = ?";
        pstmtDeleteMessage = conn.prepareStatement(deleteMessageQuery);
        pstmtDeleteMessage.setInt(1, messageId);
        pstmtDeleteMessage.executeUpdate();

        // 重定向到留言板页面
        response.sendRedirect("messages.jsp");
        
        // 关闭数据库资源
        pstmtDeleteMessage.close();
        conn.close();
%>
