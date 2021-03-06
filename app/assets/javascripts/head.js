//= require modernizr/modernizr.js

// Add modernizr hires test
// Credits: https://github.com/joaocunha/modernizr-retina-test
Modernizr.addTest('hires', function() {
    // starts with default value for modern browsers
    var dpr = window.devicePixelRatio ||

    // fallback for IE
        (window.screen.deviceXDPI / window.screen.logicalXDPI) ||

    // default value
        1;

    return !!(dpr > 1);
});
