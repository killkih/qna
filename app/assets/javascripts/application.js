//= require jquery3
//= require rails-ujs
//= require popper
//= require turbolinks
//= require bootstrap-sprockets
//= require activestorage
//= require cocoon
//= require gist-embed.min
//= require action_cable
//= require_tree .

var App = App || {};
App.cable = ActionCable.createConsumer();
