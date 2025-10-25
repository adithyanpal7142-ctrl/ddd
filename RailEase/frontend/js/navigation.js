// Handle navigation for multi-page app
document.addEventListener('DOMContentLoaded', function() {
    // Prevent default link behavior and handle navigation
    document.addEventListener('click', function(e) {
        if (e.target.tagName === 'A' && e.target.href) {
            const link = e.target;
            const href = link.getAttribute('href');
            
            // Only handle internal .html links
            if (href.endsWith('.html') && !href.startsWith('http')) {
                e.preventDefault();
                window.location.href = href;
            }
        }
    });

    // Add active class to current page link
    const currentPage = window.location.pathname.split('/').pop();
    const navLinks = document.querySelectorAll('nav a, .nav a');
    
    navLinks.forEach(link => {
        const linkHref = link.getAttribute('href');
        if (linkHref === currentPage || (currentPage === '' && linkHref === 'index.html')) {
            link.classList.add('active');
        }
    });
});