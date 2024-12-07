<%@page import="com.mycompany.biblioteca.resources.DatabaseConnection"%>
<%@page import="java.sql.*"%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consultar Préstamos</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
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
        h1 {
            font-size: 24px;
            color: #333;
            margin-bottom: 20px;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-bottom: 20px;
        }
        table, th, td {
            border: 1px solid #ddd;
        }
        th, td {
            text-align: left;
            padding: 10px;
        }
        th {
            background-color: #f2f2f2;
            color: #333;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        tr:hover {
            background-color: #f1f1f1;
        }
        .btn {
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 4px;
            cursor: pointer;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        #modal {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            justify-content: center;
            align-items: center;
        }
        .modal-content {
            background: white;
            padding: 20px;
            border-radius: 8px;
            width: 400px;
            text-align: center;
        }
        .modal-content h2 {
            margin-bottom: 20px;
            font-size: 18px;
            color: #333;
        }
        .modal-content label {
            display: block;
            margin: 10px 0 5px;
            text-align: left;
            font-size: 14px;
        }
        .modal-content input {
            width: 100%;
            padding: 8px;
            margin-bottom: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
        }
        .modal-buttons {
            display: flex;
            justify-content: space-between;
            margin-top: 20px;
        }
    </style>
    <script>
        function openModal() {
            document.getElementById('modal').style.display = 'flex';
        }

        function closeModal() {
            document.getElementById('modal').style.display = 'none';
        }

        function savePrestamo() {
            const codigo = document.getElementById('codigoIdentificacion').value;
            const usuario = document.getElementById('usuario').value;
            const iniciaPrestamo = document.getElementById('iniciaPrestamo').value;
            const finalizaPrestamo = document.getElementById('finalizaPrestamo').value;

            if (!codigo || !usuario || !iniciaPrestamo || !finalizaPrestamo) {
                alert("Por favor, completa todos los campos.");
                return;
            }

            const xhr = new XMLHttpRequest();
            xhr.open('POST', 'guardarPrestamo.jsp', true);
            xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
            xhr.onload = function() {
                if (xhr.status === 200) {
                    if (xhr.responseText.includes("Success")) {
                        location.reload();
                    } else {
                        alert("Error: " + xhr.responseText);
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
    <!-- Main Content -->
    <div id="container">
        <div id="sidebar">
            <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/Universidad_don_bosco.jpg/405px-Universidad_don_bosco.jpg" alt="Universidad Don Bosco">
            <h3>Opciones</h3>
            <a href="index.jsp">Inicio</a>
        </div>
        <div id="content">
            <h1>Préstamos Registrados</h1>
            <button class="btn" onclick="openModal()">Adicionar</button>
            <table>
                <thead>
                    <tr>
                        <th># ID</th>
                        <th>Código Identificación</th>
                        <th>Usuario</th>
                        <th>Inicia Préstamo</th>
                        <th>Finaliza Préstamo</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection conn = null;
                        PreparedStatement stmt = null;
                        ResultSet rs = null;

                        try {
                            conn = DatabaseConnection.getConnection();
                            String query = "SELECT * FROM usuarios.prestamos";
                            stmt = conn.prepareStatement(query);
                            rs = stmt.executeQuery();

                            while (rs.next()) {
                                int id = rs.getInt("ID");
                                String codigo = rs.getString("CodigoIdentificacion");
                                String usuarioPrestamo = rs.getString("usuario");
                                String iniciaPrestamo = rs.getString("IniciaPrestamo");
                                String finalizaPrestamo = rs.getString("FinalizaPrestamo");

                                out.println("<tr>");
                                out.println("<td>" + id + "</td>");
                                out.println("<td>" + codigo + "</td>");
                                out.println("<td>" + usuarioPrestamo + "</td>");
                                out.println("<td>" + iniciaPrestamo + "</td>");
                                out.println("<td>" + finalizaPrestamo + "</td>");
                                out.println("</tr>");
                            }

                        } catch (Exception e) {
                            e.printStackTrace();
                            out.println("<tr><td colspan='5'>Error: " + e.getMessage() + "</td></tr>");
                        } finally {
                            if (rs != null) rs.close();
                            if (stmt != null) stmt.close();
                            if (conn != null) conn.close();
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
    <!-- Modal -->
    <div id="modal">
        <div class="modal-content">
            <h2>Adicionar Préstamo</h2>
            <label for="codigoIdentificacion">Código Identificación:</label>
            <input type="text" id="codigoIdentificacion" name="codigoIdentificacion">
            <label for="usuario">Usuario:</label>
            <input type="text" id="usuario" name="usuario">
            <label for="iniciaPrestamo">Fecha de Inicio:</label>
            <input type="date" id="iniciaPrestamo" name="iniciaPrestamo">
            <label for="finalizaPrestamo">Fecha de Finalización:</label>
            <input type="date" id="finalizaPrestamo" name="finalizaPrestamo">
            <div class="modal-buttons">
                <button class="btn" onclick="savePrestamo()">Guardar</button>
                <button class="btn" style="background-color: #ccc; color: #333;" onclick="closeModal()">Cancelar</button>
            </div>
        </div>
    </div>
</body>
</html>
