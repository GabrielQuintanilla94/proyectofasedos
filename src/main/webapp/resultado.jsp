<%@page import="com.mycompany.biblioteca.resources.DatabaseConnection"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Resultados Obtenidos</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            margin: 0;
            padding: 0;
        }
        
        
        #navbar {
            background-color: #007bff;
            color: white;
            padding: 10px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        }
        #navbar h1 {
            font-size: 20px;
            margin: 0;
        }
        #navbar .user-info {
            font-size: 14px;
        }
        #navbar .user-info a {
            color: #ffd700;
            text-decoration: none;
            margin-left: 10px;
        }
        
        #container {
            width: 90%;
            margin: 20px auto;
            display: flex;
        }
        #sidebar {
            width: 25%;
            background-color: #f2f2f2;
            padding: 20px;
            border-right: 1px solid #ccc;
        }
        #sidebar img {
            display: block;
            max-width: 100%;
            height: auto;
            margin-bottom: 20px;
            border-radius: 8px;
        }
        #content {
            width: 75%;
            padding: 20px;
        }
        h1 {
            font-size: 24px;
            color: #333;
            text-align: center;
            margin-bottom: 20px;
        }
        .list-group {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }
        .list-group-item {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 15px;
            display: flex;
            flex-direction: column;
        }
        .list-group-item h2 {
            font-size: 18px;
            color: #007bff;
            margin: 0 0 10px;
        }
        .list-group-item p {
            font-size: 14px;
            color: #555;
            margin: 0;
        }
        .list-group-item small {
            font-size: 12px;
            color: #777;
            margin-top: 5px;
        }
        .list-group-item:hover {
            background-color: #f1faff;
        }
        .back-button {
            display: inline-flex;
            align-items: center;
            padding: 10px 15px;
            font-size: 14px;
            font-weight: bold;
            color: #007bff;
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 20px;
            text-decoration: none;
            transition: all 0.3s ease;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }
        .back-button:hover {
            background-color: #e9f7fc;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.15);
            color: #0056b3;
        }
        .back-button svg {
            margin-right: 8px;
            fill: currentColor;
        }
    </style>
</head>
<body>
    <!-- Navbar -->
    <div id="navbar">
        <h1>Mediateca UDB</h1>
        <div class="user-info">
            <% 
                String usuario = (String) session.getAttribute("nombre");
                if (usuario == null) {
                    usuario = "Invitado";
                }
            %>
            Bienvenido, <%= usuario %>
            <% if (!usuario.equals("Invitado")) { %>
                | <a href="logout.jsp">Cerrar sesión</a>
            <% } %>
        </div>
    </div>
    <div id="container">
        <!-- Sidebar -->
        <div id="sidebar">
            <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/Universidad_don_bosco.jpg/405px-Universidad_don_bosco.jpg" alt="Universidad Don Bosco">
            <h3>Vistas</h3>
            <a href="#">Estándar</a>
            <a href="#">MARC</a>
            <h3>Idiomas</h3>
            <a href="#">Español</a>
            <a href="#">English</a>
        </div>
        <!-- Content -->
        <div id="content">
            <!-- Back Button -->
            <a href="index.jsp" class="back-button">
                Pagina principal
            </a>
            <h1>Resultados Obtenidos</h1>
            <div class="list-group">
                <%
                    String codigoIdentificacion = request.getParameter("codigoIdentificacion");
                    String titulo = request.getParameter("titulo");
                    String ubicacion = request.getParameter("ubicacion");
                    String material = request.getParameter("material");
                    String orden = request.getParameter("orden");

                    Connection conn = null;
                    PreparedStatement stmt = null;
                    ResultSet rs = null;

                    try {
                        conn = DatabaseConnection.getConnection();
                        String query = "";

                        if ("todos".equalsIgnoreCase(material)) {
                            query = "SELECT codigoIdentificacion, titulo, ubicacion, 'cds' AS material FROM cds WHERE codigoIdentificacion IS NOT NULL " +
                                    "UNION " +
                                    "SELECT codigoIdentificacion, titulo, ubicacion, 'dvds' AS material FROM dvds WHERE codigoIdentificacion IS NOT NULL " +
                                    "UNION " +
                                    "SELECT codigoIdentificacion, titulo, ubicacion, 'libros' AS material FROM libros WHERE codigoIdentificacion IS NOT NULL " +
                                    "UNION " +
                                    "SELECT codigoIdentificacion, titulo, ubicacion, 'revistas' AS material FROM revistas WHERE codigoIdentificacion IS NOT NULL " +
                                    "ORDER BY " + orden;
                            stmt = conn.prepareStatement(query);
                        } else {
                            query = "SELECT codigoIdentificacion, titulo, ubicacion, ? AS material FROM " + material + " WHERE codigoIdentificacion IS NOT NULL";

                            if (codigoIdentificacion != null && !codigoIdentificacion.isEmpty()) {
                                query += " AND codigoIdentificacion LIKE ?";
                            }
                            if (titulo != null && !titulo.isEmpty()) {
                                query += " AND titulo LIKE ?";
                            }
                            if (ubicacion != null && !ubicacion.isEmpty()) {
                                query += " AND ubicacion LIKE ?";
                            }
                            query += " ORDER BY " + orden;

                            stmt = conn.prepareStatement(query);

                            int index = 1;
                            stmt.setString(index++, material);
                            if (codigoIdentificacion != null && !codigoIdentificacion.isEmpty()) {
                                stmt.setString(index++, "%" + codigoIdentificacion + "%");
                            }
                            if (titulo != null && !titulo.isEmpty()) {
                                stmt.setString(index++, "%" + titulo + "%");
                            }
                            if (ubicacion != null && !ubicacion.isEmpty()) {
                                stmt.setString(index++, "%" + ubicacion + "%");
                            }
                        }

                        rs = stmt.executeQuery();

                        while (rs.next()) {
                            String code = rs.getString("codigoIdentificacion");
                            String title = rs.getString("titulo");
                            String location = rs.getString("ubicacion");
                            String type = rs.getString("material");

                            // Reemplazar valores nulos con texto predeterminado
                            if (location == null || location.trim().isEmpty()) {
                                location = "Sin ubicación";
                            }
                            if (title == null || title.trim().isEmpty()) {
                                title = "Sin título";
                            }

                            out.println("<div class='list-group-item'>");
                            out.println("<h2><a href='detalleEjemplar.jsp?codigoIdentificacion=" + code + "&material=" + type + "'>" + title + "</a></h2>");
                            out.println("<p><strong>Ubicación:</strong> " + location + "</p>");
                            out.println("<small><strong>Material:</strong> " + type + " | <strong>Código Identificación:</strong> " + code + "</small>");
                            out.println("</div>");
                        }

                    } catch (Exception e) {
                        e.printStackTrace();
                        out.println("<p>Error al procesar la consulta: " + e.getMessage() + "</p>");
                    } finally {
                        if (rs != null) rs.close();
                        if (stmt != null) stmt.close();
                        if (conn != null) conn.close();
                    }
                %>
            </div>
        </div>
    </div>
</body>
</html>
