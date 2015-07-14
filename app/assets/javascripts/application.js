// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require cocoon
//= require jquery_ujs
//= require turbolinks
//= require qtip2/jquery.qtip.js
//= require_tree .

// Create the tooltips only when document ready
 $(document).ready(function()
 {
     // MAKE SURE YOUR SELECTOR MATCHES SOMETHING IN YOUR HTML!!!
     $('.cannot_enroll').each(function() {
        console.log($(this));
         $(this).qtip({
             content: {
                 text: $(this).attr("data-why-cannot-enroll")
             },
             position: {
                 target: 'mouse', // Position it where the click was...
                 adjust: { mouse: false } // ...but don't follow the mouse
             },
         });
     });
 });