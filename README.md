# scrolls-rails

## Usage

In `config/production.rb`:

    Scrolls::Rails.setup(Rails.application)
    config.middleware.delete Rails::Rack::Logger
    config.middleware.use Scrolls::Rails::Rack::QuietLogger

By default, your log output will look like this:

    method=GET path=/ format=html controller=home action=show status=200 duration=23.210 view=17.190 db=0.610

You might want to add some custom fields to be logged, so in your controller
(or ApplicationController) you can add some custom keys to the payload hash,
like so:

    def append_info_to_payload(payload)
      super
      payload[:ip] = request.remote_ip
      payload[:user_id] = current_user.id.to_s if current_user
      payload[:user_email] = current_user.email if current_user
    end
    
And then configure `scroll-rails` to log those fields:

    Scrolls::Rails.custom_fields = [:ip, :user_id, :user_email]
