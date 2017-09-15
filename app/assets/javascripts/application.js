// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require bootstrap-datetimepicker
//= require bootstrap-select
//= require chart
//= require jquery.remotipart
//= require_tree .

$(document).ready(function(){

  var id = ["#task_due_date", "#call_call_datetime", "#event_event_date"];

  for(i = 0; i < id.length; i++){
    $(id[i]).datetimepicker({
      pickerPosition: 'top-left',
      autoclose: true,
      todayHighlight: true,
      format: 'yyyy/mm/dd hh:ii:ss Z'
    });
    $(id[i]).datetimepicker('setStartDate', new Date());
  }

  $("#opportunity_close_date").datetimepicker({
    pickerPosition: 'top-left',
    autoclose: true,
    todayHighlight: true,
    format: 'yyyy/mm/dd hh:ii:00 Z'
  });

  $('.alert').delay(1600).fadeOut();

});
