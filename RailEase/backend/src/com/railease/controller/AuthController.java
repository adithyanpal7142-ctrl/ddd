package com.railease.controller;

import com.railease.model.User;
import com.railease.dao.UserDAO;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AuthController extends HttpServlet {
    private UserDAO userDAO;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        String action = request.getParameter("action");
        String jsonResponse = "";

        if (action == null) {
            jsonResponse = "{\"success\": false, \"message\": \"Action parameter is required\"}";
        } else {
            switch (action) {
                case "login":
                    jsonResponse = loginUser(request);
                    break;
                case "register":
                    jsonResponse = registerUser(request);
                    break;
                case "logout":
                    jsonResponse = logoutUser(request);
                    break;
                default:
                    jsonResponse = "{\"success\": false, \"message\": \"Invalid action\"}";
            }
        }

        out.print(jsonResponse);
        out.flush();
    }

    private String loginUser(HttpServletRequest request) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");

        try {
            User user = userDAO.authenticateUser(username, password);
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("user", user);
                session.setAttribute("userId", user.getId());
                session.setAttribute("userType", user.getUserType());

                return gson.toJson(new Response(true, "Login successful", user));
            } else {
                return gson.toJson(new Response(false, "Invalid credentials", null));
            }
        } catch (Exception e) {
            e.printStackTrace();
            return gson.toJson(new Response(false, "Login failed: " + e.getMessage(), null));
        }
    }

    private String registerUser(HttpServletRequest request) {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String email = request.getParameter("email");
        String userType = request.getParameter("userType");
        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");

        try {
            User user = new User();
            user.setUsername(username);
            user.setPassword(password);
            user.setEmail(email);
            user.setUserType(userType != null ? userType : "customer");
            user.setFirstName(firstName);
            user.setLastName(lastName);

            boolean success = userDAO.registerUser(user);
            if (success) {
                return gson.toJson(new Response(true, "Registration successful", null));
            } else {
                return gson.toJson(new Response(false, "Registration failed", null));
            }
        } catch (Exception e) {
            e.printStackTrace();
            return gson.toJson(new Response(false, "Registration failed: " + e.getMessage(), null));
        }
    }

    private String logoutUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        return gson.toJson(new Response(true, "Logout successful", null));
    }

    // Inner class for JSON response
    class Response {
        private boolean success;
        private String message;
        private Object data;

        public Response(boolean success, String message, Object data) {
            this.success = success;
            this.message = message;
            this.data = data;
        }

        // Getters and setters
        public boolean isSuccess() { return success; }
        public void setSuccess(boolean success) { this.success = success; }
        public String getMessage() { return message; }
        public void setMessage(String message) { this.message = message; }
        public Object getData() { return data; }
        public void setData(Object data) { this.data = data; }
    }
}