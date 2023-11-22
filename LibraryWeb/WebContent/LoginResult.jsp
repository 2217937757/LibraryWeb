<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
    <%
    String username=request.getParameter("username");
    String pwd2=request.getParameter("password");
    //1.导入驱动 ：将驱动拷贝到对应目录下
    //2.加载驱动
    Class.forName("com.mysql.cj.jdbc.Driver");
    //3.获取连接语句Connection
    String url="jdbc:mysql://localhost:3306/Library?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8";
    String uname="root";
    String pwd="root";
    Connection conn=DriverManager.getConnection(url,uname,pwd);
    //4.执行SQL语句Statement
    String sql ="SELECT * FROM  users where username=? and password=?";
    PreparedStatement pstat=conn.prepareStatement(sql);
    pstat.setString(1, username);
    pstat.setString(2, pwd2);
    ResultSet rs=pstat.executeQuery();
    //5.处理结果keyword
    if(rs.next()){
        //获取数据  
        String name=rs.getString("username");
        out.print("登录成功，欢迎您:"+name);
     	// 设置会话属性表示用户已登录
        HttpSession userSession = request.getSession();
        session.setAttribute("loggedIn", true);
        // 将用户名存储到会话中
        session.setAttribute("username", name);
        response.sendRedirect("books.jsp");
    }else
        out.print("登录失败，请检查用户名或密码后<a href='userLogin.jsp'>重试</a>。");
    //6.关闭资源释放
    rs.close();
    pstat.close();
    conn.close();
    %>
</body>
</html>