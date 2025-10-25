// Booking-related JavaScript functions

let passengerCount = 1;

document.addEventListener('DOMContentLoaded', function() {
    // Only initialize booking pages on booking-related pages
    if (isBookingPage()) {
        initializeBookingPage();
        loadStations();
    }
});

function isBookingPage() {
    const currentPage = window.location.pathname;
    return currentPage.includes('booking') || 
           currentPage.includes('dashboard') ||
           currentPage.includes('schedule') ||
           currentPage.includes('history');
}

// ... rest of your existing booking.js code remains the same