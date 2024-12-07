<%@ page import="java.sql.*" %>
<%@ page import="com.mycompany.biblioteca.resources.DatabaseConnection" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Inicio de Sesión</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f9f9f9;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }
        .login-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            width: 400px;
            text-align: center;
        }
        .login-card img {
            max-width: 120px;
            margin-bottom: 20px;
        }
        .login-card h1 {
            font-size: 24px;
            margin-bottom: 20px;
            color: #333;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group input {
            width: 100%;
            padding: 10px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
        }
        .btn {
            width: 100%;
            padding: 10px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 16px;
            margin-top: 10px;
        }
        .btn:hover {
            background-color: #0056b3;
        }
        .error-message {
            color: red;
            margin-top: 15px;
            font-size: 14px;
        }
    </style>
</head>
<body>
    <div class="login-card">
        <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/Universidad_don_bosco.jpg/405px-Universidad_don_bosco.jpg" alt="Universidad Don Bosco">
        <h1>UDB</h1>
        <form method="post" action="validarLogin.jsp">
            <div class="form-group">
                <input type="text" name="usuario" placeholder="Usuario" required>
            </div>
            <div class="form-group">
                <input type="password" name="password" placeholder="Contraseña" required>
            </div>
            <button type="submit" class="btn">Ingresar</button>
        </form>
        <% 
            String error = request.getParameter("error");
            if (error != null && error.equals("1")) {
        %>
            <div class="error-message">Usuario o contraseña incorrectos</div>
        <% 
            }
        %>
    </div>
</body>
</html>
