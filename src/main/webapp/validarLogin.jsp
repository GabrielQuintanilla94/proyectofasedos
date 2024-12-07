<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.biblioteca.resources.DatabaseConnection" %>
<%
    // Obtener datos enviados por el formulario
    String usuario = request.getParameter("usuario");
    String password = request.getParameter("password");

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        // Conexión a la base de datos
        conn = DatabaseConnection.getConnection();

        // Consulta SQL para validar usuario y contraseña
        String query = "SELECT * FROM usuarios WHERE usuario = ? AND password = ?";
        stmt = conn.prepareStatement(query);
        stmt.setString(1, usuario);
        stmt.setString(2, password);

        rs = stmt.executeQuery();

        if (rs.next()) {
            // Credenciales válidas: redirigir a index.jsp
            session.setAttribute("usuario", rs.getString("usuario"));
            session.setAttribute("nombre", rs.getString("nombre"));
            session.setAttribute("id_tipo", rs.getInt("id_tipo"));
            response.sendRedirect("index.jsp");
        } else {
            // Credenciales inválidas: mostrar error
            response.sendRedirect("login.jsp?error=1");
        }
    } catch (Exception e) {
        e.printStackTrace();
        response.sendRedirect("login.jsp?error=1");
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
