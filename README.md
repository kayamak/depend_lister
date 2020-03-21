# DependLister

DependLister analyzes belongs_to defined by a model and outputs a list of tables in order with a little dependence.
When You begin the maintenance of the existing project, it may be helpful.

## Installation

To use it, add it to your Gemfile:

```ruby
gem 'depend_lister'
```

and bundle:

```shell
bundle
```

#### Post Installation

Install migrations:

```shell
rake db:migrate
```

## Usage

```shell
rails depend_lister
```

### Example of Result

```shell
$ rails depend_lister
Level	Table	BelongsTo
Lv1	accounts
Lv2	follows	accounts
Lv2	statuses	accounts
Lv2	users	accounts
Lv3	favourites	accounts, statuses
Lv3	mentions	accounts, statuses
Lv3	stream_entries	accounts, statuses
```

You can copy the result and paste to Excel Sheet or Google Spread Sheet.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kayamak/depend_lister. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/kayamak/depend_lister).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the DependLister project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/kayamak/depend_lister).
