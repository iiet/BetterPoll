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
//= require moment
//= require bootstrap-datetimepicker
//= require pickers
//= require moment/pl
//= require_tree .

// Create the tooltips only when document ready
var ready = function()
 {
     // MAKE SURE YOUR SELECTOR MATCHES SOMETHING IN YOUR HTML!!!
     $('.cannot_enroll').each(function() {
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
     $('.instant-enroll[data-user-public-fields]').each(function() {
         $(this).qtip({
             content: {
                 text: $(this).attr("data-user-public-fields")
             },
             position: {
                 my: 'center right',  // Position my top left...
                 at: 'center left', // at the bottom right of...
             },
         });
     });
 };
$(document).ready(ready);
$(document).on('page:load', ready);