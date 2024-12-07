<%@page import="com.mycompany.biblioteca.resources.DatabaseConnection"%>
<%@ page import="java.sql.*" %>
<%
    // Obtener par�metros desde el request
    String codigo = request.getParameter("codigoIdentificacion");
    String usuario = request.getParameter("usuario");

    // Verificar que los par�metros no sean nulos
    if (codigo == null || codigo.isEmpty()) {
        out.println("Error: C�digo de identificaci�n no recibido.");
        return;
    }

    if (usuario == null || usuario.isEmpty()) {
        out.println("Error: Usuario no recibido.");
        return;
    }

    Connection conn = null;
    PreparedStatement stmt = null;

    try {
        // Conectar a la base de datos
        conn = DatabaseConnection.getConnection();

        // Preparar consulta SQL para insertar el pr�stamo con fechas autom�ticas
        String query = "INSERT INTO prestamos (CodigoIdentificacion, usuario, IniciaPrestamo, FinalizaPrestamo) VALUES (?, ?, NOW(), DATE_ADD(NOW(), INTERVAL 7 DAY))";
        stmt = conn.prepareStatement(query);
        stmt.setString(1, codigo);
        stmt.setString(2, usuario);

        // Ejecutar la consulta
        int rowsInserted = stmt.executeUpdate();

        if (rowsInserted > 0) {
            out.println("Success");
        } else {
            out.println("Error: No se pudo insertar el pr�stamo.");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("Error: " + e.getMessage());
    } finally {
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>
