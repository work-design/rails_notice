# TheNotify
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
<%= javascript_include_tag 'the_notify/cable', 'data-turbolinks-eval': 'false' %>
<%= stylesheet_link_tag 'the_notify/cable' %>
```

### View: add link
```erb
<%= link_to notifications_path, class: 'icon item pointer', remote: true, id: 'notify_show' do %>
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
  include TheNotifyController
  
end
```

### Channel Setting
```ruby
module ApplicationCable
  class Connection < ActionCable::Connection::Base
    prepend TheNotifyConnection

  end
end
```


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'the_notify'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install the_notify
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
