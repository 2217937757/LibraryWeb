<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String url = "jdbc:mysql://localhost:3306/Library?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String uname = "root";
    String pwd = "root";

    Connection conn = null;
    PreparedStatement pstmtUpdateStatus = null;
    PreparedStatement pstmtUpdateReturnDate = null;

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, uname, pwd);

        // 获取来自userBorrowedBooks.jsp的书籍ID
        int bookId = Integer.parseInt(request.getParameter("book_id"));

        // 更新books表中的状态为"在库"
        String updateStatusQuery = "UPDATE books SET status = '在库' WHERE id = ?";
        pstmtUpdateStatus = conn.prepareStatement(updateStatusQuery);
        pstmtUpdateStatus.setInt(1, bookId);
        pstmtUpdateStatus.executeUpdate();

        // 更新borrowings表中的归还日期
        String updateReturnDateQuery = "UPDATE borrowings SET return_date = ? WHERE book_id = ? AND return_date IS NULL";
        pstmtUpdateReturnDate = conn.prepareStatement(updateReturnDateQuery);
        pstmtUpdateReturnDate.setDate(1, new java.sql.Date(System.currentTimeMillis()));
        pstmtUpdateReturnDate.setInt(2, bookId);
        pstmtUpdateReturnDate.executeUpdate();

        // 这里可以添加其他操作或重定向到其他页面
        response.sendRedirect("userBorrowedBooks.jsp");
        
        //关闭数据库资源
        pstmtUpdateStatus.close();
        pstmtUpdateReturnDate.close();
        conn.close();
%>
