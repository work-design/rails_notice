//= require rails_com/fetch_xhr_script
$('#notify_setting_notifiable_type').dropdown({
  placeholder: false,
  onChange: function(value, text, $selectedItem) {
    var search_path = '/admin/notify_settings/columns';
    var search_url = new URL(window.location.origin + search_path);
    search_url.searchParams.set('notifiable_type', value);

    var params = {
      credentials: 'same-origin',
      headers: {
        'Accept': 'application/javascript',
        'X-CSRF-Token': document.head.querySelector("[name=csrf-token]").content
      }
    };
    fetch_xhr_script(search_url, params);
  }
});