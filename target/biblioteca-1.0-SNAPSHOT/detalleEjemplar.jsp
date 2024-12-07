<%@page import="com.mycompany.biblioteca.resources.DatabaseConnection"%>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Detalle del Ejemplar</title>
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
        #sidebar h3 {
            font-size: 16px;
            margin-bottom: 10px;
            color: #333;
        }
        #sidebar a {
            display: block;
            text-decoration: none;
            color: #007bff;
            margin: 5px 0;
        }
        #sidebar a:hover {
            text-decoration: underline;
        }
        #content {
            width: 75%;
            padding: 20px;
            background: white;
        }
        .card {
            background: white;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
            padding: 20px;
            margin-bottom: 20px;
        }
        .card-header {
            background-color: #e9f7ec;
            color: #2e7d32;
            padding: 10px 20px;
            border-radius: 8px 8px 0 0;
            font-size: 18px;
            font-weight: bold;
            display: flex;
            align-items: center;
        }
        .card-header::before {
            content: '';
            width: 5px;
            height: 100%;
            background-color: #2e7d32;
            margin-right: 10px;
        }
        .btn {
            display: inline-block;
            margin-top: 20px;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            text-align: center;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        .back-button {
            display: inline-block;
            margin-bottom: 20px;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 20px;
            cursor: pointer;
            font-size: 14px;
            text-decoration: none;
            text-align: center;
        }
        .back-button:hover {
            background-color: #0056b3;
        }
        #modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            justify-content: center;
            align-items: center;
        }
        #modal-content {
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.2);
            width: 400px;
        }
        .modal-header {
            font-size: 18px;
            margin-bottom: 20px;
        }
        .modal-field {
            margin-bottom: 10px;
        }
        .modal-field label {
            display: block;
            font-size: 14px;
            margin-bottom: 5px;
        }
        .modal-field input {
            width: 100%;
            padding: 8px;
            font-size: 14px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .modal-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
        .modal-buttons button {
            padding: 10px 20px;
            font-size: 14px;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .modal-buttons .save-btn {
            background-color: #007bff;
            color: white;
        }
        .modal-buttons .cancel-btn {
            background-color: #ccc;
            color: #333;
        }
        #footer {
            margin-top: 20px;
            text-align: center;
            font-size: 12px;
            color: #777;
        }
    </style>
    <script>
        function openModal(codigoIdentificacion) {
            document.getElementById('modal').style.display = 'flex';
            document.getElementById('codigoIdentificacion').value = codigoIdentificacion;
        }

        function closeModal() {
            document.getElementById('modal').style.display = 'none';
        }

        function savePrestamo() {
            const codigo = document.getElementById('codigoIdentificacion').value;
            const usuario = document.getElementById('usuario').value;
            const iniciaPrestamo = document.getElementById('iniciaPrestamo').value;
            const finalizaPrestamo = document.getElementById('finalizaPrestamo').value;

            if (!usuario || !iniciaPrestamo || !finalizaPrestamo) {
                alert("Por favor, completa todos los campos.");
                return;
            }

            const datePattern = /^\d{4}-\d{2}-\d{2}$/;
            if (!datePattern.test(iniciaPrestamo) || !datePattern.test(finalizaPrestamo)) {
                alert("El formato de las fechas debe ser YYYY-MM-DD.");
                return;
            }

            const xhr = new XMLHttpRequest();
            xhr.open('POST', 'guardarPrestamo.jsp', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onload = function () {
                if (xhr.status === 200) {
                    if (xhr.responseText.includes("Success")) {
                        alert("Préstamo creado con éxito.");
                        location.reload();
                    } else {
                        alert("Error al crear el préstamo: " + xhr.responseText);
                    }
                } else {
                    alert("Error al procesar la solicitud.");
                }
            };
            xhr.send(`codigoIdentificacion=${codigo}&usuario=${usuario}&iniciaPrestamo=${iniciaPrestamo}&finalizaPrestamo=${finalizaPrestamo}`);
        }
    </script>
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
            <!-- Botón de regreso -->
            <a href="index.jsp" class="back-button">Volver a Página Principal</a>
            <!-- Card -->
            <div class="card">
                <div class="card-header">
                    Cita Completa
                </div>
                <div class="card-body">
                    <div class="details">
                        <%
                            String codigoIdentificacion = request.getParameter("codigoIdentificacion");
                            String material = request.getParameter("material");

                            Connection conn = null;
                            PreparedStatement stmt = null;
                            ResultSet rs = null;

                            try {
                                conn = DatabaseConnection.getConnection();
                                String query = "";

                                switch (material.toLowerCase()) {
                                    case "cds":
                                        query = "SELECT * FROM cds WHERE CodigoIdentificacion = ?";
                                        break;
                                    case "dvds":
                                        query = "SELECT * FROM dvds WHERE CodigoIdentificacion = ?";
                                        break;
                                    case "libros":
                                        query = "SELECT * FROM libros WHERE CodigoIdentificacion = ?";
                                        break;
                                    case "revistas":
                                        query = "SELECT * FROM revistas WHERE CodigoIdentificacion = ?";
                                        break;
                                    default:
                                        throw new Exception("Material no reconocido: " + material);
                                }

                                stmt = conn.prepareStatement(query);
                                stmt.setString(1, codigoIdentificacion);

                                rs = stmt.executeQuery();

                                if (rs.next()) {
                                    out.println("<p><span class='label'>Código Identificación:</span> " + rs.getString("CodigoIdentificacion") + "</p>");
                                    out.println("<p><span class='label'>Título:</span> " + rs.getString("Titulo") + "</p>");
                                    out.println("<p><span class='label'>Clasificación:</span> " + material + "</p>");
                                    out.println("<p><span class='label'>Ubicación:</span> " + rs.getString("Ubicacion") + "</p>");
                                    out.println("<p><span class='label'>Unidades Disponibles:</span> " + rs.getString("UnidadesDisponibles") + "</p>");
                                } else {
                                    out.println("<p>No se encontraron detalles para este ejemplar.</p>");
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
                <button class="btn" onclick="openModal('<%= codigoIdentificacion %>')">Crear Préstamo</button>
            </div>
        </div>
    </div>

    <!-- Modal -->
    <div id="modal">
        <div id="modal-content">
            <div class="modal-header">Crear Préstamo</div>
            <div class="modal-field">
                <label for="codigoIdentificacion">Código Identificación:</label>
                <input type="text" id="codigoIdentificacion" name="codigoIdentificacion" readonly>
            </div>
            <div class="modal-field">
                <label for="usuario">Usuario:</label>
                <input type="text" id="usuario" name="usuario">
            </div>
            <div class="modal-field">
                <label for="iniciaPrestamo">Fecha de Inicio:</label>
                <input type="date" id="iniciaPrestamo" name="iniciaPrestamo">
            </div>
            <div class="modal-field">
                <label for="finalizaPrestamo">Fecha de Finalización:</label>
                <input type="date" id="finalizaPrestamo" name="finalizaPrestamo">
            </div>
            <div class="modal-buttons">
                <button class="save-btn" onclick="savePrestamo()">Guardar</button>
                <button class="cancel-btn" onclick="closeModal()">Cancelar</button>
            </div>
        </div>
    </div>
    <div id="footer">
        Todos los derechos reservados | Powered by Universidad Don Bosco
    </div>
</body>
</html>
