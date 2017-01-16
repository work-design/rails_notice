//= require action_cable
//= require ./messenger.min
//= require ./messenger-theme-future
//= require_self
//= require_tree ./channels

(function() {
  this.App || (this.App = {});

  App.cable = ActionCable.createConsumer('/cable');

}).call(this);

Messenger.options = {
  extraClasses: 'messenger-fixed messenger-on-bottom messenger-on-right',
  theme: 'air'
};