<%@ page session="true" %>
<%@ page import="java.util.*" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Consulta al catálogo</title>
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
            width: 80%;
            margin: 20px auto;
            display: flex;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            background: white;
        }
        #menu {
            width: 25%;
            background-color: #f2f2f2;
            padding: 20px;
            border-right: 1px solid #ccc;
        }
        #menu img {
            display: block;
            max-width: 100%;
            height: auto;
            margin-bottom: 20px;
            border-radius: 8px;
        }
        #menu h2 {
            font-size: 16px;
            color: #333;
            margin-bottom: 10px;
        }
        #menu a {
            display: block;
            text-decoration: none;
            color: #007bff;
            margin-bottom: 5px;
            font-size: 14px;
        }
        #menu a:hover {
            text-decoration: underline;
        }
        #content {
            width: 75%;
            padding: 20px;
        }
        h1 {
            font-size: 18px;
            color: #333;
            margin-bottom: 10px;
        }
        form label {
            display: block;
            margin-top: 10px;
            font-size: 14px;
            color: #555;
        }
        form input[type="text"], form select {
            width: 100%;
            padding: 5px;
            margin-top: 5px;
            margin-bottom: 10px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        form .radio-group {
            display: flex;
            gap: 15px;
            margin-top: 10px;
        }
        form .radio-group label {
            font-size: 14px;
            color: #555;
        }
        form .btn {
            display: block;
            width: 150px;
            padding: 10px;
            background-color: #007bff;
            color: white;
            text-align: center;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            font-size: 14px;
        }
        form .btn:hover {
            background-color: #0056b3;
        }
        #footer {
            text-align: center;
            font-size: 12px;
            color: #777;
            margin-top: 20px;
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
    <!-- Main Container -->
    <div id="container">
        <div id="menu">
            <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/Universidad_don_bosco.jpg/405px-Universidad_don_bosco.jpg" alt="Universidad Don Bosco">
            <h2>Tipos de búsqueda</h2>
            <a href="#">Básica</a>
            <a href="#">Avanzada</a>
            <h2>Idiomas</h2>
            <a href="#">Español</a>
            <a href="#">Inglés</a>
            <h2>Estudiante</h2>
            <a href="#">Estatus en biblioteca</a>
            <h2>Préstamos</h2>
            <a href="consultarPrestamos.jsp">Consultar Préstamos</a>
        </div>
        <div id="content">
            <h1>Consulta al catálogo</h1>
            <p>Ingrese su consulta y presione [Iniciar consulta]</p>
            <form action="resultado.jsp" method="post">
                <label for="codigoIdentificacion">Código Identificación:</label>
                <input type="text" id="codigoIdentificacion" name="codigoIdentificacion">

                <label for="titulo">Título:</label>
                <input type="text" id="titulo" name="titulo">

                <label for="ubicacion">Ubicación:</label>
                <input type="text" id="ubicacion" name="ubicacion">

                <label for="material">Material:</label>
                <select id="material" name="material">
                    <option value="todos">Todos</option>
                    <option value="cds">CDs</option>
                    <option value="dvds">DVDs</option>
                    <option value="libros">Libros</option>
                    <option value="revistas">Revistas</option>
                </select>

                <label for="idioma">Idioma:</label>
                <select id="idioma" name="idioma">
                    <option value="todos">Todos</option>
                </select>

                <label>Ordenar resultados por:</label>
                <div class="radio-group">
                    <label><input type="radio" name="orden" value="codigoIdentificacion" checked> Código Identificación</label>
                    <label><input type="radio" name="orden" value="titulo"> Título</label>
                    <label><input type="radio" name="orden" value="clasificacion"> Clasificación</label>
                </div>

                <button type="submit" class="btn">Iniciar consulta</button>
            </form>
        </div>
    </div>
    <div id="footer">
        Todos los derechos reservados | Powered by Universidad Don Bosco
    </div>
</body>
</html>
