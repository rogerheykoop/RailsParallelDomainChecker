// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap
//= require bootstrap-sprockets
//= require punycode
//= require websocket_rails/main

$( document ).ready(function() {
	$('.datatable').DataTable({
		    "paging": false
	 });

	var dispatcher = new WebSocketRails('localhost:9292/websocket');
	channel = dispatcher.subscribe('searchresults');
	channel.bind('startsearch', function(task) {
		$("#name_" + task[1]).html(punycode.toUnicode(task[0] + "." + task[1]))
	});
	channel.bind('completed_found', function(task) {
		$("#searchres_" + task[1]).html('<i class="fa fa-thumbs-o-down"></i> <span class="label label-danger">Exists</span>');
	});
	channel.bind('completed_notfound', function(task) {
		$("#searchres_" + task[1]).html('<i class="fa fa-thumbs-o-up"></i> <span class="label label-success">Appears free</span>');
	});
});