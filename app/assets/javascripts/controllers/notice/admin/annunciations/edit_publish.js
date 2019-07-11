$('#receiver_type').dropdown();
$('#tag_ids').dropdown();
document.getElementById('receiver_type').addEventListener('change', function(){
  var search_url = new URL(this.form.action + '/options');
  if (this.value) {
    search_url.searchParams.set('receiver_type', this.value);
    Rails.ajax({url: search_url, type: 'GET', dataType: 'script'});
  }
});
