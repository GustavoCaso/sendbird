# Sendbird

Sendbird is a ruby Wrapper for the Sendbird [API](https://docs.sendbird.com/platform)

## Installation

```ruby
gem 'sendbird'
```

## Requirements

You must provide:
  - Your list of applications, been the Applications name and its Api Key.
  - Your username and password.
You can find your applications list [here](https://dashboard.sendbird.com).
By setting a default, will set the api_key in the request where need, if not you will have to provide a app parameter to every method call.


Rails way:
```ruby
Sendbird.config do |c|
  c.applications = {app_name: 'API_KEY'}
  c.user = 'username'
  c.password = 'password'
  c.default_app = 'app_name'
end
```

Ruby way:
```ruby
Sendbird.applications = {app_name: 'API_KEY'}
Sendbird.user = 'username'
Sendbird.password = 'password'
Sendbird.default_app = 'app_name'
```

## Usage

## Api

There are two types of classes inside the Wrapper the one ending with Api, like `Sendbird::UserApi` or `Sendbird::MessageApi`, this classes act like simple wrapper for the Sendbird api.

The Sendbird Api is quite big, to understand how to work with this gem, just remember that every event from the api map to a class method from that Api class.

Example:
```ruby
body = {
    "user_id" => "string",
    "nickname" => "string",
    "profile_url" => "string",
    "issue_access_token" => "boolean"
}
Sendbird::UserApi.create(body)
```

All methods that accept a variables in the uri, they will argument in order for the method, and all request arguments or parameters, are the last arguments as hash.

Example for event [Message send](https://docs.sendbird.com/platform#messages):
```ruby
request_body = {
    "message_type" => "MESG",
    "user_id" => "string",
    "message" => "string",
    "data" => "string",
    "mark_as_read" => "boolean"
}
Sendbird::MessageApi.send('group_channels', 'group_channels_url', request_body)
```

Example for event [User list](https://docs.sendbird.com/platform#messages):
```ruby
request_parameters = {
    "token" => "string",
    "limit" => "int",
    "user_ids" => "string"
}
Sendbird::UserApi.list(request_parameters)
```

Example for sending a message to a different app:
```ruby
request_parameters = {
  "token" => "string",
  "limit" => "int",
  "user_ids" => "string",
  "app" => 'string' # This app has to be in the configuration
}
Sendbird::UserApi.list(request_parameters)
```

All methods return a `Sendbird::Response` with have the next methods:
#### body
  Returns the parsed body of the request
#### status
  Returns the status code of the request
#### error_code
  Returns the error_code from the request, if their is one
#### error_message
  Returns the error_message from the request, if their is one


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/sendbird. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
