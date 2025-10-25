// Main JavaScript file for RailEase

document.addEventListener('DOMContentLoaded', function() {
    initializeApp();
});

function initializeApp() {
    // Only check login status on non-auth pages
    if (!isAuthPage()) {
        checkLoginStatus();
    }
    
    // Initialize forms
    initializeForms();
    
    // Initialize date pickers
    initializeDatePickers();
}

function isAuthPage() {
    // Check if current page is login or register
    const currentPage = window.location.pathname;
    return currentPage.includes('login.html') || 
           currentPage.includes('register.html') ||
           currentPage.includes('index.html');
}

function checkLoginStatus() {
    const token = localStorage.getItem('authToken');
    const userType = localStorage.getItem('userType');
    
    if (token) {
        updateNavigation(userType);
    }
    // REMOVED THE REDIRECT LOGIC - don't force redirects
}

function updateNavigation(userType) {
    const loginBtn = document.querySelector('.btn-login');
    const registerBtn = document.querySelector('.btn-register');
    
    if (loginBtn && registerBtn) {
        if (userType === 'admin') {
            loginBtn.innerHTML = '<a href="admin_dashboard.html">Admin Dashboard</a>';
            registerBtn.style.display = 'none';
        } else {
            loginBtn.innerHTML = '<a href="user_dashboard.html">My Account</a>';
            registerBtn.style.display = 'none';
        }
    }
}

function initializeForms() {
    // Login form handler - ONLY if on login page
    if (window.location.pathname.includes('login.html')) {
        const loginForm = document.getElementById('loginForm');
        if (loginForm) {
            loginForm.addEventListener('submit', handleLogin);
        }
    }
    
    // Registration form handler - ONLY if on register page
    if (window.location.pathname.includes('register.html')) {
        const registerForm = document.getElementById('registerForm');
        if (registerForm) {
            registerForm.addEventListener('submit', handleRegistration);
        }
    }
    
    // PNR form handler
    const pnrForm = document.getElementById('pnrForm');
    if (pnrForm) {
        pnrForm.addEventListener('submit', handlePnrCheck);
    }
    
    // Search form handler
    const searchForm = document.getElementById('searchForm');
    if (searchForm) {
        searchForm.addEventListener('submit', handleTrainSearch);
    }
}

// REST OF THE FILE REMAINS THE SAME...
async function handleLogin(event) {
    event.preventDefault();
    
    const formData = new FormData(event.target);
    const loginData = {
        email: formData.get('email'),
        password: formData.get('password')
    };
    
    try {
        const response = await fetch('/api/auth/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(loginData)
        });
        
        const result = await response.json();
        
        if (result.success) {
            localStorage.setItem('authToken', result.token);
            localStorage.setItem('userType', result.userType);
            localStorage.setItem('userId', result.userId);
            
            if (result.userType === 'admin') {
                window.location.href = 'admin_dashboard.html';
            } else {
                window.location.href = 'user_dashboard.html';
            }
        } else {
            showNotification(result.message, 'error');
        }
    } catch (error) {
        showNotification('Login failed. Please try again.', 'error');
        console.error('Login error:', error);
    }
}

// ... rest of your existing main.js code