<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
%>

<%
    // 获取当前页的值
    int currentPage = (int) session.getAttribute("CurrentPage");
    HttpSession userSession = request.getSession();
    // 数据库连接信息
    String url = "jdbc:mysql://localhost:3306/Library?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String uname = "root";
    String pwd = "root";
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    // 加载数据库驱动
    Class.forName("com.mysql.cj.jdbc.Driver");
    // 建立数据库连接
    conn = DriverManager.getConnection(url, uname, pwd);

    // 获取要添加的书籍的 ID
    int bookId = Integer.parseInt(request.getParameter("book_id"));

    // 使用 UPDATE 语句将书籍标记为在库状态
    String updateQuery = "UPDATE books SET status = '在库' WHERE id = ?";
    pstmt = conn.prepareStatement(updateQuery);
    pstmt.setInt(1, bookId);
    pstmt.executeUpdate();

    // 重定向到图书列表页面
    response.sendRedirect("books.jsp?CurrentPages=" + currentPage);

    // 关闭资源
    pstmt.close();
    conn.close();
%>
