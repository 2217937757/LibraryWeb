<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
%>
<%
    // 获取用户会话
    HttpSession userSession = request.getSession();
    // 检查用户是否已登录
    Boolean loggedIn = (Boolean) session.getAttribute("loggedIn");

    // 如果用户未登录，重定向到登录页面
    if (loggedIn == null || !loggedIn) {
        response.sendRedirect("userLogin.jsp");
    }
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>图书列表</title>
<link rel="stylesheet" type="text/css" href="css/books.css">
</head>
<body>
    <div class="container">
        <h2>图书列表</h2>
        
        <%
		    // 默认当前页面为1
		    int currentPage = 1;
		    // 设置sql分页语句
		    String pagination = "";
		    // 记录数量为10
		    int maxResult = 10;
		    // 偏移量
		    int offset = 0;
		    // 总页数
		    int totalPage = 0;
		    // 获取到当前页面
		    String CurrentPages = request.getParameter("CurrentPages");
		    if (CurrentPages != null && !"".equals(CurrentPages.equals(CurrentPages.trim()))) {
		        currentPage = Integer.parseInt(CurrentPages);
		        // 偏移值
		        offset = (currentPage - 1) * maxResult;
		    }
		    // 分页sql语句
		    pagination = " " + "limit" + " " + offset + "," + maxResult;
		%>
		
		<%
		    if (CurrentPages == null) {
		        currentPage = 1;
		    }
		    // 数据库连接信息
		    String url = "jdbc:mysql://localhost:3306/Library?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
		    String uname = "root";
		    String pwd = "root";
		
		    Connection conn = null;
		    Statement stmt = null;
		    ResultSet rs = null;
		        Class.forName("com.mysql.cj.jdbc.Driver");
		        conn = DriverManager.getConnection(url, uname, pwd);
		        stmt = conn.createStatement();
		
		        String keyword = request.getParameter("keyword");
		        String query = "SELECT * FROM books" + pagination;
		
		        // 模糊查询
		        if (keyword != null && !keyword.isEmpty()) {
		            query = "SELECT * FROM books WHERE title LIKE '%" + keyword + "%' OR author LIKE '%" + keyword
		                    + "%' OR type LIKE '%" + keyword + "%'";
		        }
		
		        // 获取当前用户的用户名
		        String username = (String) userSession.getAttribute("username");
		
		        // 查找用户的 ID
		        int userId = -1; // 设置一个默认值，表示未找到用户
		        String findUserIdQuery = "SELECT id FROM users WHERE username = '" + username + "'";
		        ResultSet userIdResult = stmt.executeQuery(findUserIdQuery);
		        if (userIdResult.next()) {
		            userId = userIdResult.getInt("id");
		        }
		        // 将用户ID保存在会话中
		        userSession.setAttribute("userId", userId);
		
		        // 查询表的所有数据
		        rs = stmt.executeQuery(query);
		
		        // 查询表的总数
		        String sql = "select count(*) as count from books";
		        Statement st = conn.createStatement();
		        ResultSet reqset = st.executeQuery(sql);
		        // 获取总页数
		        if (reqset.next()) {
		            int count = reqset.getInt("count");
		            if (count % maxResult == 0)
		                totalPage = count / maxResult;
		            else
		                totalPage = count / maxResult;
		        }
		        // 关闭数据库资源
                //rs.close();
                //stmt.close();
                //conn.close();
		%>

        <!-- 搜索表单 -->
        <div class="search-container">
            <form method="get" action="books.jsp">
                <label for="keyword">搜索：</label>
                <input type="text" name="keyword" placeholder="输入关键字查询" />
                <input type="submit" value="查询" />
            </form>
        </div>

        <!-- 用户信息和导航栏 -->
        <div class="flex-container">
            <div class="welcome">
                <p>
                    	欢迎<%=userSession.getAttribute("username")%>！
                    <a href="userLogin.jsp">退出登录</a>
                    <%
                    if ("admin".equals(username)) {
                        HttpSession session1=request.getSession();
                        session.setAttribute("CurrentPage", currentPage);
	                %>
	                 -- <a href="userManagement.jsp">管理账户</a>
	                <%
	                    }
	                %>
                </p>
            </div>
			
            <div class="userBorrowedBooks">
                <a href="userBorrowedBooks.jsp">借阅表</a>
            </div>

            <div class="messages">
                <a href="messages.jsp">留言表</a>
            </div>
        </div>

        <!-- 图书列表表格 -->
        <table border="1">
            <tr>
                <th id="id">ID</th>
                <th id="title">书籍名称</th>
                <th id="author">作者</th>
                <th id="type">类型</th>
                <th id="status">状态</th>
                <th id="operation">操作</th>
                <%
                    if ("admin".equals(username)) {
                %>
                <th id="admin">管理员操作</th>
                <%
                    }
                %>
            </tr>

            <!-- 循环展示图书列表 -->
            <%
                while (rs.next()) {
            %>
            <tr>
                <td><%=rs.getInt("id")%></td>
                <td><%=rs.getString("title")%></td>
                <td><%=rs.getString("author")%></td>
                <td><%=rs.getString("type")%></td>
                <td><%=rs.getString("status")%></td>
                <td>
                    <form method="post" action="borrow.jsp">
                        <input type="hidden" name="book_id" value="<%=rs.getInt("id")%>" />
                        <div class="button-container">
                            <%
                                if ("在库".equals(rs.getString("status"))) {
                            %>
                            <button type="submit">借阅</button>
                            <%
                            HttpSession session1=request.getSession();
                            session.setAttribute("CurrentPage", currentPage);
                                } else {
                            %>
                            <span>已借出</span>
                            <%
                                }
                            %>
                        </div>
                    </form>
                </td>

                <!-- 管理员操作列 -->
				<%
				    // 检查用户是否为管理员
				    if ("admin".equals(username)) {
				        // 获取当前会话
				        HttpSession session1 = request.getSession();
				        // 将当前页码存储到会话中
				        session1.setAttribute("CurrentPage", currentPage);
				%>
				<td>
				    <!-- 添加图书表单 -->
				    <form method="post" action="addBook.jsp">
				        <!-- 传递图书ID -->
				        <input type="hidden" name="book_id" value="<%=rs.getInt("id")%>" />
				        <div class="button-container">
				            <!-- 提交添加图书请求 -->
				            <button type="submit">添加</button>
				        </div>
				    </form>
				    <!-- 删除图书表单 -->
				    <form method="post" action="deleteBook.jsp">
				        <!-- 传递图书ID -->
				        <input type="hidden" name="book_id" value="<%=rs.getInt("id")%>" />
				        <div class="button-container">
				            <!-- 提交删除图书请求 -->
				            <button type="submit">删除</button>
				        </div>
				    </form>
				</td>
				<%
				    }
				%>
				<% } %>
        </table>

        <!-- 分页链接 -->
        <a href="books.jsp?CurrentPages=1">首页</a>
        &nbsp;&nbsp;&nbsp;&nbsp;
        <%
            if (currentPage > 1) {
        %>
            <a href="books.jsp?CurrentPages=<%=currentPage - 1%>">上一页</a>
            &nbsp;&nbsp;&nbsp;&nbsp;
        <%
            }
        %>
        <label>第<%= currentPage %>页&nbsp;&nbsp;/&nbsp;&nbsp;共<%=totalPage %>页</label>
        <%
            if (currentPage < totalPage) {
        %>
            <a href="books.jsp?CurrentPages=<%=currentPage + 1%>">下一页</a>
            &nbsp;&nbsp;&nbsp;&nbsp;
        <%
            }
        %>
        <a href="books.jsp?CurrentPages=<%=totalPage%>">尾页</a>
        &nbsp;&nbsp;&nbsp;&nbsp;
        
        <!-- 跳转到指定页数的表单 -->
        <form method="get" action="books.jsp">
            <label for="CurrentPages">跳转到第</label>
            <select name="CurrentPages" >
                <% for (int i = 1; i <= totalPage; i++) { %>
			    <!-- 循环生成下拉框的选项 -->
			    <option value="<%= i %>" <%= i == currentPage ? "selected" : "" %>><%= i %></option>
				<% } %>
            </select>
            <label for="CurrentPages">页</label>
            <input type="submit" value="跳转" />
        </form>
        
        &nbsp;&nbsp;&nbsp;&nbsp;
    </div>
</body>
</html>
