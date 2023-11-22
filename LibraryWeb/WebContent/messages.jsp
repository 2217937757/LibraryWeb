<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="javax.servlet.http.HttpSession" %>
<%
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
    PreparedStatement pstmtInsertMessage = null;
    Statement stmt = null;
    ResultSet rs = null;
    Class.forName("com.mysql.cj.jdbc.Driver");
    conn = DriverManager.getConnection(url, uname, pwd);

    // 获取用户名，假设已经在登录时将用户名存储在会话中
    String username = (String) session.getAttribute("username");

    // 如果用户名不存在，则设置一个默认值或者重定向到登录页面
    if (username == null || username.isEmpty()) {
        // 设置默认用户名
        username = "Guest";
        // 或者重定向到登录页面
        // response.sendRedirect("userLogin.jsp");
    }

    // 插入留言
    if (request.getMethod().equalsIgnoreCase("get")) {
        String content = request.getParameter("content");

        if (content != null && !content.isEmpty()) {
            String insertMessageQuery = "INSERT INTO messages (user_id, content) VALUES ((SELECT id FROM users WHERE username = ?), ?)";
            pstmtInsertMessage = conn.prepareStatement(insertMessageQuery);
            pstmtInsertMessage.setString(1, username);
            pstmtInsertMessage.setString(2, content);
            pstmtInsertMessage.executeUpdate();
        }
    }

    // 获取留言列表，按时间倒序排序
    String selectMessagesQuery = "SELECT m.*, u.username FROM messages m JOIN users u ON m.user_id = u.id ORDER BY m.timestamp DESC";
    stmt = conn.createStatement();
    rs = stmt.executeQuery(selectMessagesQuery);
    
 	// 关闭数据库资源
 	//pstmtInsertMessage.close();
 	//stmt.close();
 	//rs.close();
 	//conn.close();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>留言板</title>
    <!-- 添加您的样式表链接或内联样式 -->
    <link rel="stylesheet" type="text/css" href="css/messages.css">
</head>
<body>
    <div>
        <h2>留言板</h2>
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
		        <a href="userBorrowedBooks.jsp">借阅表</a>
		    </div>
		    
		    <div class="messages">
		        <a href="messages.jsp">留言表</a>
		    </div>
		</div>
        <!-- 留言表单 -->
        <form method="get" action="messages.jsp" autocomplete="off" onsubmit="return validateForm()">
		    <textarea id="content" name="content" rows="4" cols="50" placeholder="在这里留言...（内容不能超过200个字符)"></textarea>
		    <br>
		    <div id="charCount">字符数：0 / 200</div>
		    <br>
		    <input type="submit" value="留言">
		</form>

        <!-- 显示留言列表 -->
        <ul>
            <%
                if (rs != null) {
                    while (rs.next()) {
                        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                        String timestamp = dateFormat.format(rs.getTimestamp("timestamp"));
            %>
                        <li>
                            <div class="username">
                                <span><%= rs.getString("username") %></span>
                                <span><%= timestamp %></span>
                            </div>
                            <div class="content">
                                <%= rs.getString("content") %>
                                <% if ("admin".equals(username)) { %>
							    <!-- 在这里添加管理员操作，例如删除按钮 -->
							    <form method="post" action="deleteMessage.jsp">
							        <input type="hidden" name="message_id" value="<%= rs.getInt("id") %>" />
							        <div class="button-container">
							            <button type="submit">删除</button>
							        </div>
							    </form>
								<% } %>
                            </div>
                        </li>
            <%
                    }
                }
            %>
        </ul>
    </div>
</body>
		<script>
		    function updateCharCount() {
		        var content = document.getElementById("content").value;
		        var charCount = content.length;
		        var maxChar = 200;
		        var charCountElement = document.getElementById("charCount");
		
		        charCountElement.textContent = "字符数：" + charCount + " / " + maxChar;
		
		        // 如果超过限制，可以添加样式或其他处理
		        if (charCount > maxChar) {
		            charCountElement.style.color = "red";
		        } else {
		            charCountElement.style.color = "black";
		        }
		    }
		
		    function validateForm() {
		        var content = document.getElementById("content").value;
		
		        if (content.length > 200) {
		            alert("评论内容不能超过200个字符！");
		            return false;
		        }
		
		        return true;
		    }
		
		    // 在输入时触发更新字符计数
		    document.getElementById("content").addEventListener("input", updateCharCount);
		</script>


</html>