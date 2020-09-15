# Medusa::Client

[API Documentation](https://medusa-project.github.com/medusa-client/)

This gem provides a high-level client for navigating Medusa's main entity tree
using its REST API.

```
Medusa::Repository
     |
     |
     --> Medusa::Collection
             |
             |
             --> Medusa::FileGroup     -------
                     |                 |     |
                     |                 V     |
                     --> Medusa::Directory --- 
                             |
                             |
                              --> Medusa::File
```

## Installation

Add one of these lines to your application's Gemfile:

```ruby
gem 'medusa-client', git: 'https://github.com/medusa-project/medusa-client.git'
gem 'medusa-client', path: '/path/to/medusa-client'
```

And then invoke:

```sh
$ bundle
```

By default, configuration is obtained from the `MEDUSA_BASE_URL`,
`MEDUSA_USER`, and `MEDUSA_SECRET` environment variables. But you can also
assign a configuration hash to `Medusa::Client.configuration` via Ruby. Here is
an example involving a Rails initializer:

```ruby
# Put this in config/initializers/medusa-client.rb
Medusa::Client.configuration = {
    medusa_base_url: "https://...",
    medusa_user:     "my-user",
    medusa_secret:   "my-secret"
}
```

## Usage

`Medusa::Client` is responsible for all of the communication with Medusa, but
it's mostly used behind-the-scenes. Still, it can do a little on its own:

```ruby
client = Medusa::Client.instance

# Get the class of a Medusa resource by UUID
client.class_of_uuid("some medusa UUID")

# Get the URL of a Medusa resource by UUID
client.url_for_uuid("some medusa UUID")
```

More likely you will want to use the higher-level classes to navigate the
entity tree. Here is an example where we walk across a whole tree, starting at
its root, which is a `Medusa::Repository`:

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

## Documentation

To update the documentation on GitHub Pages, invoke
`bundle exec rake publish_docs`.

## Testing

The tests are written to interface with the content in
[Mockdusa](https://github.com/medusa-project/mockdusa). (Repository ID 1
contains all of the test content.)

Mockdusa can be run locally or in Docker (see below). Assuming that it's
running locally, you would have to define the following environment variables
before running the tests:

* `MEDUSA_BASE_URL=http://localhost:4567`
* `MEDUSA_USER=medusa`
* `MEDUSA_SECRET=secret`

Finally, `bundle exec rake test` runs the tests.

You can also run the tests in Docker using docker-compose:

```sh
# Get credentials to access ECR from which the Mockdusa image will be pulled
$ aws login
$ docker-compose up --build --exit-code-from medusa-client
```
