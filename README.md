[![CI Status](https://github.com/wendelscardua/dotini/workflows/CI/badge.svg?branch=main)](https://github.com/wendelscardua/dotini/actions?query=workflow%3ACI+branch%3Amain)
[![Gem Version](https://badge.fury.io/rb/dotini.svg)](https://badge.fury.io/rb/dotini)
[![Documentation](http://img.shields.io/badge/docs-rdoc.info-blue.svg)](http://www.rubydoc.info/github/wendelscardua/dotini)

# Dotini

Dotini allows [INI files](https://en.wikipedia.org/wiki/INI_file) to be parsed, created,
modified and written, preserving existing comments.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dotini'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install dotini

## Usage

### Reading an INI file

Given this INI file:

```ini
[main]
username = foo
; this is a color
; the color is nice
color = red

[personal]
color = cyan
path = /tmp ; TODO: change later
```

It can be read with:

```ruby
  ini_file = Dotini::IniFile.load(filename, options) # options are not required

  ini_file['main']['color'].value # => 'red'
  ini_file['main']['color'].prepended_comments # => ['; this is a color', '; the color is nice']
  ini_file['personal']['path'].value # => '/tmp'
  ini_file['personal']['path'].inline_comment # => '; TODO: change later'
```

These are the available options:

- `comment_character` (default: `';'`)
- `key_pattern` (default: `Dotini::IniFile::DEFAULT_KEY_PATTERN`)
- `value_pattern` (default: `Dotini::IniFile::DEFAULT_VALUE_PATTERN`)

### Creating a new INI file

```ruby
  ini_file = Dotini::IniFile.new
  ini_file['profile default']['color'] = 'blue'
  ini_file['preferences']['width'] = 42
```

### Saving the INI file

Given the INI file above, it can be turned into a string:

```ruby
  ini_file.to_s # => "[profile default]\ncolor = blue\n[preferences]\nwidth = 42\n"
```

...or it can be written to a IO stream:

```ruby
  File.open('new-file.ini', 'wb') do |file|
    ini_file.write(file)
  end
```

### Converting the INI file to a hash

```ruby
  ini_file.to_h # => { 'profile default' => { 'color' => 'blue' }, 'preferences' => { 'width' => '42' } }
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/wendelscardua/dotini. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/wendelscardua/dotini/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Dotini project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/dotini/blob/main/CODE_OF_CONDUCT.md).
