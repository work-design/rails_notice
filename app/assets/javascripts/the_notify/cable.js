//= require action_cable
//= require_self
//= require_tree ./channels
//= require channels/done

(function() {
  this.App || (this.App = {});

  App.cable = ActionCable.createConsumer('/cable');

}).call(this);
