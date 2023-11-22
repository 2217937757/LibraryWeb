<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"
%>
<%
    //获取当前页的值
    int CurrentPage=(int)session.getAttribute("CurrentPage");
    HttpSession userSession = request.getSession();
    
    Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");
    if (loggedIn == null || !loggedIn) {
        // 用户未登录，重定向到登录页面
        response.sendRedirect("userLogin.jsp");
    }
%>
<%
    String url = "jdbc:mysql://localhost:3306/Library?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String uname = "root";
    String pwd = "root";

    Connection conn = null;
    PreparedStatement pstmtUpdateStatus = null;
    PreparedStatement pstmtInsertBorrowing = null;

        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(url, uname, pwd);

        // 获取来自books.jsp的书籍ID
        int bookId = Integer.parseInt(request.getParameter("book_id"));

        // 更新books表中的状态为"借出"
        String updateStatusQuery = "UPDATE books SET status = '不在库中' WHERE id = ?";
        pstmtUpdateStatus = conn.prepareStatement(updateStatusQuery);
        pstmtUpdateStatus.setInt(1, bookId);
        pstmtUpdateStatus.executeUpdate();

        // 获取当前用户的用户ID
        int userId = (int) userSession.getAttribute("userId");

        // 插入借阅记录到borrowings表中
        String insertBorrowingQuery = "INSERT INTO borrowings (user_id, book_id, borrow_date) VALUES (?, ?, ?)";
        pstmtInsertBorrowing = conn.prepareStatement(insertBorrowingQuery);
        pstmtInsertBorrowing.setInt(1, userId); // 使用动态获取的用户ID
        pstmtInsertBorrowing.setInt(2, bookId);
        pstmtInsertBorrowing.setDate(3, new java.sql.Date(System.currentTimeMillis()));
        pstmtInsertBorrowing.executeUpdate();

        // 这里可以添加其他操作或重定向到其他页面
        response.sendRedirect("books.jsp?CurrentPages="+CurrentPage);
    
		// 释放资源
        pstmtUpdateStatus.close();
        pstmtInsertBorrowing.close();
        conn.close();
%>
