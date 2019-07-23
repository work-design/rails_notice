// Must require rails/cable first
ApplicationCable.subscriptions.create('ReceiverChannel', {
  collection: function() {
    return document.getElementById('notify_show');
  },
  received: function(data) {
    // this.collection().style.color = '#ff7f24';
    // this.collection().innerHTML = data.body;
    $('body').toast({
      message: data.body,
      type: 'info',
      showCloseButton: true
    });
    document.getElementById('notify_show').style.color = '#ff7f24';
    document.getElementById('notice_count').innerHTML = data.count;
  },
  connected: function() {
    console.log('connected success');
  }
});
