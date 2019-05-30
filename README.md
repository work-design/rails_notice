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
<%= render 'rails_notice/link' %>
```

### Model Setting
```ruby
# which model can receive notifications
class User < ApplicationRecord
  include RailsNoticeReceivable
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

## License
The gem is available as open source under the terms of the [LGPL-3.0](https://opensource.org/licenses/LGPL-3.0).
