$('#notify_setting_notifiable_type').dropdown({
  placeholder: false,
  onChange: function(value, text, $selectedItem) {
    var search_path = '/admin/notify_settings/columns';
    var search_url = new URL(window.location.origin + search_path);
    search_url.searchParams.set('notifiable_type', value);

    Rails.ajax({ url: search_url, type: 'GET', dataType: 'script' });
  }
});
