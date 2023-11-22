<%@ page import="java.sql.*" %>
<%@ page import="java.text.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<%
    HttpSession userSession = request.getSession();
    Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");

    if (loggedIn == null || !loggedIn) {
        // 用户未登录，重定向到登录页面
        response.sendRedirect("userLogin.jsp");
    }

    String url = "jdbc:mysql://localhost:3306/Library?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String uname = "root";
    String pwd = "root";

    Connection conn = null;
    Statement stmt = null;
    ResultSet rs = null;
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(url, uname, pwd);
    stmt = conn.createStatement();

    // 获取当前用户的用户名
    String username = (String) userSession.getAttribute("username");

    // 查找用户的 ID
    int userId = -1; // 设置一个默认值，表示未找到用户
    String findUserIdQuery = "SELECT id FROM users WHERE username = '" + username + "'";
    ResultSet userIdResult = stmt.executeQuery(findUserIdQuery);
    if (userIdResult.next()) {
        userId = userIdResult.getInt("id");
    }

 // 查询用户借阅信息
    String query;
    if ("admin".equals(username)) {
        // 如果是管理员，查询所有用户的借阅信息，按借阅日期逆序排列
        query = "SELECT b.id as book_id, b.title, b.author, b.type, bo.borrow_date, bo.return_date, u.username as borrow_user " +
                "FROM borrowings bo " +
                "JOIN books b ON bo.book_id = b.id " +
                "JOIN users u ON bo.user_id = u.id " +
                "ORDER BY bo.return_date IS NULL DESC, bo.borrow_date DESC";
    } else {
        // 如果是普通用户，只查询当前用户的借阅信息，按借阅日期逆序排列
        query = "SELECT b.id as book_id, b.title, b.author, b.type, bo.borrow_date, bo.return_date " +
                "FROM borrowings bo " +
                "JOIN books b ON bo.book_id = b.id " +
                "WHERE bo.user_id = " + userId +
                " ORDER BY bo.return_date IS NULL DESC, bo.borrow_date DESC";
    }

    rs = stmt.executeQuery(query);
    
 	// 关闭数据库资源
 	//rs.close();
 	//stmt.close();
 	//conn.close();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>用户借阅预览</title>
    <link rel="stylesheet" type="text/css" href="css/books.css">
</head>
<body>
    <div class="container">
        <h2>用户借阅预览</h2>
        
        <div class="flex-container">
            <div class="welcome">
                <p>
                    	欢迎<%=userSession.getAttribute("username")%>！
                    <a href="userLogin.jsp">退出登录</a>
                    <%
                    if ("admin".equals(username)) {
	                %>
	                 -- <a href="userManagement.jsp">管理账户</a>
	                <%
	                    }
	                %>
                </p>
            </div>
			
            <div class="userBorrowedBooks">
                <a href="books.jsp">图书表</a>
            </div>

            <div class="messages">
                <a href="messages.jsp">留言表</a>
            </div>
        </div>

        <table border="1">
            <tr>
                <th>书籍名称</th>
                <th>作者</th>
                <th>类型</th>
                <th>借阅日期</th>
                <th>归还日期</th>
                <% if ("admin".equals(username)) { %>
                    <th>借阅用户</th>
                <% } %>
                <th>操作</th> <!-- 新添加的列 -->
            </tr>

            <%
	            while (rs.next()) {
	                String title = rs.getString("title");
	                String author = rs.getString("author");
	                String type = rs.getString("type");
	                Date borrowDate = rs.getDate("borrow_date");
	                Date returnDate = rs.getDate("return_date");
	                int bookId = rs.getInt("book_id");
	
	                // 格式化日期
	                SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
	                String formattedBorrowDate = dateFormat.format(borrowDate);
	                String formattedReturnDate = (returnDate != null) ? dateFormat.format(returnDate) : "尚未归还";
	
	                // 检查 borrow_user 是否存在
	                String borrowUser = "";
	                if ("admin".equals(username)) {
	                    borrowUser = rs.getString("borrow_user");
	                }
            %>
            <tr>
			    <td><%= title %></td>
			    <td><%= author %></td>
			    <td><%= type %></td>
			    <td><%= formattedBorrowDate %></td>
			    <td><%= formattedReturnDate %></td>
			    <% if ("admin".equals(username)) { %>
			        <td><%= borrowUser %></td>
			    <% } %>
			    <td>
			        <% if (returnDate == null) { %>
			            <form method="post" action="returnBook.jsp">
			                <input type="hidden" name="book_id" value="<%= bookId %>" />
			                <div class="button-container">
			                    <button type="submit">归还</button>
			                </div>
			            </form>
			        <% } else { %>
			            <span>已归还</span>
			        <% } %>
			    </td>
			</tr>
            <%
                }
            %>
        </table>
    </div>
</body>
</html>
