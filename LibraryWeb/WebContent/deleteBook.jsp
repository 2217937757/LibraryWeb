<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
%>

<%
    //获取当前页的值
    int CurrentPage = (int) session.getAttribute("CurrentPage");
    HttpSession userSession = request.getSession();
    
    String url = "jdbc:mysql://localhost:3306/Library?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String uname = "root";
    String pwd = "root";

    Connection conn = null;
    PreparedStatement pstmt = null;
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(url, uname, pwd);

    // 获取要删除的书籍的 ID
    int bookId = Integer.parseInt(request.getParameter("book_id"));

    // 使用 UPDATE 语句将书籍标记为已删除状态
    String updateQuery = "UPDATE books SET status = '不在库中' WHERE id = ?";
    pstmt = conn.prepareStatement(updateQuery);
    pstmt.setInt(1, bookId);
    pstmt.executeUpdate();

    // 可以添加一些成功消息的处理，例如重定向到图书列表页面
    response.sendRedirect("books.jsp?CurrentPages="+CurrentPage);
    
	// 关闭数据库资源
	pstmt.close();
	conn.close();
%>
