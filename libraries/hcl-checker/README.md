# Hcl::Checker

**Hashicorp Configuration Language** syntax checker and parser.

Parser originally created by [Sikula](https://github.com/sikula) and available
at [Ruby HCL Repository](https://github.com/sikula/ruby-hcl). Only works with
[HCL Version 1](https://github.com/hashicorp/hcl).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hcl-checker'
```

And then execute:

  $ bundle

Or install it yourself as:

  $ gem install hcl-checker

## Usage

Load HCL string:

```hcl
hcl_string = 'provider "aws" {
    region = "${var.aws_region}"
    access_key = "${var.aws_access_key}"
    secret_key = "${var.aws_secret_key}"
}

# This is a awesome comment
resource "aws_vpc" "default" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags {
    Name = "Event Store VPC"
  }
}'
```

You can validate the `hcl_string` contents with `valid?` method. This will
return `true` if is a valid HCL or `false` if not.

```hcl
2.3.2 :014 > HCL::Checker.valid? hcl_string
 => true
```

You can parse the `hcl_string` into a `Hash` with `parse` method.

```hcl
2.3.2 :015 > HCL::Checker.parse(hcl_string)
 => {"provider"=>{"aws"=>{"region"=>"${var.aws_region}", "access_key"=>"${var.aws_access_key}", "secret_key"=>"${var.aws_secret_key}"}}, "resource"=>{"aws_vpc"=>{"default"=>{"cidr_block"=>"10.0.0.0/16", "enable_dns_hostnames"=>true, "tags"=>{"Name"=>"Event Store VPC"}}}}}
```

If after a `parse` you got `false` you can check `last_error` with:

```hcl
2.4.2 :063 > HCL::Checker.last_error
 => "Parse error at  \"eec8b16c-ee89-4ea0-bdcc-d094300a42e8\" , (invalid token: ,)"
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run
`rake spec` to run the tests. You can also run `bin/console` for an interactive
prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To
release a new version, update the version number in `version.rb`, and then run
`bundle exec rake release`, which will create a git tag for the version, push
git commits and tags, and push the `.gem` file to
[rubygems.org](https://rubygems.org).

### Building grammar

```ruby
$ bundle exec rake build_grammar
Building Lexer....done
Building Parser....done
```

## Contributing

Bug reports and pull requests are welcome on GitHub at
<https://github.com/mfcastellani/hcl-checker>. This project is intended to be a
safe, welcoming space for collaboration, and contributors are expected to adhere
to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT
License](https://opensource.org/licenses/MIT).
