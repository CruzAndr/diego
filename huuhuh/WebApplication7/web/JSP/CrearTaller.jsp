<%-- 
    Document   : CrearTaller
    Created on : 3 jul 2024, 08:12:11
    Author     : metal
--%>

<%-- 
    Document   : CrearTaller
    Created on : 20 jun. 2024, 10:00:02
    Author     : Diego
--%>


<%@ page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="Arbol.Arbol"%>
<%@page import="Arbol.Persona"%>
<%@page import="Utilidades.Archivo"%>


<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Crear Carpeta y Archivo TXT</title>
        <link rel="stylesheet" href="../CSS/CrearTaller.css">
    </head>
    <body>
        <h1>Crear Carpeta y Archivo TXT</h1>
        <form method="post" action="CrearTaller.jsp">
            <label for="folderName">Nombre de la Carpeta:</label>
            <input type="text" id="folderName" name="folderName" required><br><br>
            <label for="fileName">Nombre del Archivo TXT:</label>
            <input type="text" id="fileName" name="fileName" required><br><br>
            <label for="name">Nombre del Taller:</label>
            <input type="text" id="name" name="name" required><br><br>
            <label for="nameADS">Profesor Encargado:</label>
            <input type="text" id="nameADS" name="nameADS" required><br><br>
            <label for="numero">Número de Aula:</label>
            <input type="text" id="numero" name="numero" required><br><br>
            <label for="cupoMAXI">Cupo Máximo:</label>
            <input type="text" id="cupoMAXI" name="cupoMAXI" required><br><br>
            <input type="submit" value="Crear">
        </form>

        <%
            String folderName = request.getParameter("folderName");
            String fileName = request.getParameter("fileName");
            String nombreTaller = request.getParameter("name");
            String profesorEncargado = request.getParameter("nameADS");
            String numeroAula = request.getParameter("numero");
            String cupoMaximo = request.getParameter("cupoMAXI");

            if (folderName != null && fileName != null && nombreTaller != null && profesorEncargado != null && numeroAula != null && cupoMaximo != null) {
                String basePath = "D:\\SimposioData\\";
                String folderPath = basePath + folderName;
                java.io.File folder = new java.io.File(folderPath);
                if (!folder.exists()) {
                    folder.mkdirs();
                }

                String filePath = folderPath + java.io.File.separator + fileName + ".txt";
                java.io.File file = new java.io.File(filePath);
                if (!file.exists()) {
                    file.createNewFile();
                }

                // Guardar datos en el árbol
                Arbol arbol = new Arbol();
                Persona nuevaPersona = new Persona(nombreTaller);
                arbol.insertarNodo(nuevaPersona);

                // Guardar los datos en el archivo
                Archivo archivo = new Archivo();
                boolean bandera = archivo.guardarUsuario(nombreTaller, profesorEncargado, numeroAula, cupoMaximo);

                if (bandera) {
                    out.println("<p>Carpeta y archivo creados exitosamente.</p>");
                    out.println("<p>Datos insertados correctamente en el archivo.</p>");
                } else {
                    out.println("<p>Error al insertar los datos en el archivo.</p>");
                }

                out.println("<p>Ruta de la carpeta: " + folderPath + "</p>");
                out.println("<p>Ruta del archivo: " + filePath + "</p>");
            }
        %>
    </body>
</html>
