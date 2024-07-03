<%-- 
    Document   : AñadirInscrito
    Created on : 3 jul 2024, 08:11:49
    Author     : metal
--%>

<%@page import="java.io.BufferedReader"%>
<%@page import="java.io.FileReader"%>
<%@page import="java.io.BufferedWriter"%>
<%@page import="java.io.FileWriter"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.File"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Añadir Información a Archivos</title>
        <link rel="stylesheet" href="../CSS/añadirInscrito.css">
    </head>
    <body>
        <div class="container">
            <div class="form-container">
                <h1>Añadir Información a Archivos</h1>
                <form method="post" action="AñadirInscrito.jsp">
                    <label for="folder">Seleccione una carpeta:</label>
                    <select name="folder" id="folder" onchange="this.form.submit()">
                        <option value="">Seleccione una carpeta</option>
                        <%
                            // Directorio base
                            String baseDir = "D:\\SimposioData\\";
                            File baseFolder = new File(baseDir);
                            if (baseFolder.exists() && baseFolder.isDirectory()) {
                                for (File folder : baseFolder.listFiles()) {
                                    if (folder.isDirectory()) {
                                        String selected = request.getParameter("folder") != null && request.getParameter("folder").equals(folder.getName()) ? "selected" : "";
                                        out.println("<option value='" + folder.getName() + "' " + selected + ">" + folder.getName() + "</option>");
                                    }
                                }
                            }
                        %>
                    </select>
                </form>
                <%
                    String selectedFolder = request.getParameter("folder");
                    if (selectedFolder != null && !selectedFolder.isEmpty()) {
                        File folder = new File(baseDir + selectedFolder);
                        if (folder.exists() && folder.isDirectory()) {
                            out.println("<form method='post' action='AñadirInscrito.jsp'>");
                            out.println("<input type='hidden' name='folder' value='" + selectedFolder + "' />");
                            out.println("<label for='file'>Seleccione un archivo:</label>");
                            out.println("<select name='file' id='file'>");
                            for (File file : folder.listFiles()) {
                                if (file.isFile() && file.getName().endsWith(".txt")) {
                                    out.println("<option value='" + file.getName() + "'>" + file.getName() + "</option>");
                                }
                            }
                            out.println("</select>");
                            out.println("<br><br>");
                            out.println("<label for='content'>Añadir información:</label>");
                            out.println("<textarea id='content' name='content' rows='4' cols='50'></textarea>");
                            out.println("<br><br>");
                            out.println("<button type='submit' name='addContent' value='addContent'>Añadir Información</button>");
                            out.println("</form>");
                        }
                    }

                    if ("addContent".equals(request.getParameter("addContent"))) {
                        String folderName = request.getParameter("folder");
                        String fileName = request.getParameter("file");
                        String contentToAdd = request.getParameter("content");
                        boolean contentExists = false;
                        File file = null; // Declarar file aquí

                        if (folderName != null && fileName != null && contentToAdd != null && !contentToAdd.trim().isEmpty()) {
                            file = new File(baseDir + folderName + "\\" + fileName); // Inicializar file aquí
                            if (file.exists() && file.isFile()) {
                                // Leer el archivo y verificar si el contenido ya existe
                                try ( BufferedReader reader = new BufferedReader(new FileReader(file))) {
                                    String line;
                                    while ((line = reader.readLine()) != null) {
                                        if (line.equals(contentToAdd)) {
                                            contentExists = true;
                                            break;
                                        }
                                    }
                                } catch (IOException e) {
                                    e.printStackTrace();
                                }

                                // Si el contenido no existe, añadirlo
                                if (!contentExists) {
                                    try ( BufferedWriter writer = new BufferedWriter(new FileWriter(file, true))) {
                                        writer.write(contentToAdd);
                                        writer.newLine();
                                        out.println("<p class='success'>La información ha sido añadida y guardada en el archivo " + fileName + ".</p>");
                                    } catch (IOException e) {
                                        e.printStackTrace();
                                        out.println("<p class='error'>Error al guardar la información en el archivo " + fileName + ".</p>");
                                    }
                                } else {
                                    out.println("<p class='success'>La información ya existe en el archivo " + fileName + ".</p>");
                                }
                            } else {
                                out.println("<p class='error'>Archivo no encontrado.</p>");
                            }
                        } else {
                            out.println("<p class='error'>Por favor seleccione un archivo y añada información.</p>");
                        }

                        // Mostrar contenido del archivo
                        if (file != null && file.exists() && file.isFile()) {
                            out.println("</div><div class='file-content'><h2>Contenido del archivo " + fileName + "</h2><pre>");
                            try ( BufferedReader reader = new BufferedReader(new FileReader(file))) {
                                String line;
                                while ((line = reader.readLine()) != null) {
                                    if (line.equals(contentToAdd)) {
                                        out.println("<span class='new-content'>" + line + "</span>");
                                    } else {
                                        out.println(line);
                                    }
                                }
                            } catch (IOException e) {
                                e.printStackTrace();
                            }
                            out.println("</pre>");
                        }
                    }
                %>
            </div>
        </div>
    </body>
</html>
