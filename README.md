# RailsNotice
Short description and motivation.

## Usage
### Set the cable.yml
Should set adapter as redis in development
```yaml
development:
  adapter: redis
  url: redis://localhost:6379/1
```

### Import the js and css in the page which you want show notifications
```erb
<%= javascript_include_tag 'rails_notice/cable', 'data-turbolinks-eval': 'false' %>
<%= stylesheet_link_tag 'rails_notice/cable' %>
```

### View: add link
```erb
<%= link_to notifications_path, class: 'item', remote: true, id: 'notify_show' do %>
  <i class="bell icon"></i>
  <span id="notice_count" style="padding-left: 5px"><%= current_user.unread_count %></span>
<% end %>
```

### Model Setting
```ruby
# which model can receive notifications
class User < ApplicationRecord
  include TheReceivable
end

```

### Controller Setting
```ruby
class ApplicationController < ActionController::Base
  include RailsNoticeController
  
end
```

### Channel Setting
```ruby
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    prepend RailsNoticeConnection

  end
end
```


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'rails_notice'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install rails_notice
```

## License
The gem is available as open source under the terms of the [LGPL License](https://opensource.org/licenses/LGPL-3.0).