# I18nTyml

Use this gem to find the missing translation by parsing I18n.t, and write missing values to yml file.

It should be used with [i15r](https://github.com/balinterdi/i15r)

The idea and part code is borrowed from (http://willbradley.name/2013/03/21/rails_localization_i18n_tools/)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'i18n_tyml', :github => 'wingice/i18n_tyml'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install i18n_tyml
 


## Usage

cd your project home

```
1. i15r app/views/xxxx/xxx.html.erb
2. i18n_tyml app/views/xxxx/xxx.html.erb
```

## Contributing

1. Fork it ( https://github.com/wingice/i18n_tyml/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
