App.cable.subscriptions.create('NoticesChannel', {
  collection: function() {
    return $("[data-channel='notices']");
  },
  received: function(data) {
    this.collection().css('color', '#ff7f24');
    this.collection().html(data.body);
    Messenger().post({
      message: data.body,
      type: 'info',
      showCloseButton: true,
      hideAfter: 60
    });
    $('#notify_show').css('color', '#ff7f24');
    $('#notice_count').html(data.count);
  },
  connected: function() {
    console.log('Notice channel connected success');
  }
});
