//= require ./messenger.min
//= require ./messenger-theme-future

Messenger.options = {
  extraClasses: 'messenger-fixed messenger-on-bottom messenger-on-right',
  theme: 'air',
  parentLocations: ['footer']
};

App.cable.subscriptions.create('NoticesChannel', {
  collection: function() {
    return $("[data-channel='notices']");
  },
  received: function(data) {
    this.collection().css('color', '#ff7f24');
    this.collection().html(data.body);

    var msg = Messenger().post({
      message: data.body,
      type: 'info',
      showCloseButton: true,
      hideAfter: data.showtime,
      actions: {
        confirm: {
          label: 'Confirm',
          action: function(e){
            var url = '/notifications/' + data.id + '/read';
            Rails.ajax({ url: url, type: 'GET', dataType: 'script' });
            window.location.href = data.link;
          }
        }
      }
    });

    $('#notify_show').css('color', '#ff7f24');
    $('#notice_count').html(data.count);
  },
  connected: function() {
    console.log('Notice channel connected success');
  }
});
