# Medusa::Client

This gem provides a high-level client for accessing Medusa's REST API, for the
purpose of navigating its main entity tree:

```
Repository
     |
     |
     --> Collection
             |
             |
             --> File Group    -------
                     |         |     |
                     |         V     |
                     --> Directory --- 
                             |
                             |
                              --> File
```

## Installation

Add **one** of these lines to your application's Gemfile:

```ruby
gem 'medusa-client', git: 'https://github.com/medusa-project/medusa-client.git', branch: 'my-branch'
gem 'medusa-client', git: 'https://github.com/medusa-project/medusa-client.git', tag: 'my-tag'
gem 'medusa-client', path: '/path/to/my/medusa-client'
```

And then execute:

```sh
$ bundle
```

By default, configuration is obtained from the `MEDUSA_BASE_URL`,
`MEDUSA_USER`, and `MEDUSA_SECRET` environment variables. But you can use Ruby
instead by overriding `Medusa::Client.configuration`, by, for example, adding
the following to `config/initializers/medusa-client.rb`:

```ruby
Medusa::Client.configuration = {
    medusa_base_url: "https://...",
    medusa_user:     "my-user",
    medusa_secret:   "my-secret"
}
```

## Usage

You can obtain a `Medusa::Client` directly, but it's not very useful:

```ruby
client = Medusa::Client.instance

# Get the class of a Medusa resource by UUID
client.class_of_uuid("some medusa UUID")

# Get the URL of a Medusa resource by UUID
client.url_for_uuid("some medusa UUID")
```

Here is an example where we walk across the whole entity graph, starting at its
root (a repository):

```ruby
# Get a repository by its ID
repo = Medusa::Repository.with_id("some database ID")
# ... or by its UUID
repo = Medusa::Repository.with_uuid("some Medusa UUID")

# For each collection in the repository...
repo.collections.each do |collection|
  # And each file group in the collection...
  collection.file_groups.each do |file_group|
    # If the file group is bit-level, get its root directory...
    if file_group.storage_level == 'bit_level'
      root_dir = file_group.directory
      # And all files and directories contained within.
      root_dir.walk_tree do |node|
        puts node.relative_key
      end
    end
  end
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies.

For testing, you must define the following environment variables:

* `MEDUSA_BASE_URL`
* `MEDUSA_USER`
* `MEDUSA_SECRET`

Then, run `rake test` to run the tests. You can also run `bin/console` for an
interactive prompt for experimentation.

## Releasing

TODO: write this

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/medusa-project/medusa-client. If you do submit a pull
request, please include tests for your changes.
