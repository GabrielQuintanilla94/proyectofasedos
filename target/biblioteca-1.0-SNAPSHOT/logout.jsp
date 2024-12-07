<%@ page session="true" %>
<%
    // Invalidar la sesión actual
    session.invalidate();
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Cerrar Sesión</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 0;
            padding: 0;
            background-color: #f9f9f9;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
        }
        .logout-container {
            text-align: center;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            width: 400px;
        }
        .logout-container img {
            max-width: 100px;
            margin-bottom: 20px;
        }
        .logout-container h1 {
            font-size: 24px;
            color: #333;
            margin-bottom: 20px;
        }
        .logout-container p {
            font-size: 16px;
            color: #666;
            margin-bottom: 20px;
        }
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 16px;
            text-decoration: none;
            cursor: pointer;
        }
        .btn:hover {
            background-color: #0056b3;
        }
    </style>
    <script>
        // Redirigir automáticamente al login después de 5 segundos
        setTimeout(() => {
            window.location.href = 'login.jsp';
        }, 5000);
    </script>
</head>
<body>
    <div class="logout-container">
        <img src="https://upload.wikimedia.org/wikipedia/commons/thumb/c/cc/Universidad_don_bosco.jpg/405px-Universidad_don_bosco.jpg" alt="Universidad Don Bosco">
        <h1>Sesión Cerrada</h1>
        <p>Has cerrado sesión exitosamente. Serás redirigido al inicio de sesión en unos momentos.</p>
        <a href="login.jsp" class="btn">Ir al Login</a>
    </div>
</body>
</html>
