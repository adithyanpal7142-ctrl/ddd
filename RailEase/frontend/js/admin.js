// Admin-specific JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Only run admin checks on admin pages
    if (window.location.pathname.includes('admin')) {
        initializeAdminDashboard();
    }
});

function initializeAdminDashboard() {
    checkAdminAuth();
    loadDashboardStats();
    initializeAdminForms();
}

function checkAdminAuth() {
    const token = localStorage.getItem('authToken');
    const userType = localStorage.getItem('userType');
    
    // Only redirect if not on login page
    if ((!token || userType !== 'admin') && !window.location.pathname.includes('login.html')) {
        window.location.href = 'login.html';
        return;
    }
}

// ... rest of your existing admin.js code