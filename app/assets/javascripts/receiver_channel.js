import consumer from 'rails_ui/cable'

consumer.subscriptions.create('ReceiverChannel', {

  collection() {
    return $("[data-channel='notices']")
  },

  received(data) {
    //this.collection().css('color', '#ff7f24')
    //this.collection().html(data.body)
    // Messenger().post({
    //   message: data.body,
    //   type: 'info',
    //   showCloseButton: true
    // })
    document.getElementById('notify_show').classList.add('has-text-danger')
    document.getElementById('notice_count').innerText = data.count
  },

  connected() {
    console.debug('ReceiverChannel connected ')
  },

  disconnected() {
    console.debug('ReceiverChannel disconnected')
  }

})
