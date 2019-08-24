$('#q_receiver_type').dropdown();
$('#q_receiver_id').dropdown({
  apiSettings: {
    url: '/receivers/search?q={query}&receiver_type={receiver_type}',
    beforeSend: function(settings) {
      settings.urlData.receiver_type = document.querySelector('select[name="q[receiver_type]"]').value;
      return settings;
    }
  },
  fields: {
    name: 'name',
    value: 'id'
  },
  minCharacters: 2
});
