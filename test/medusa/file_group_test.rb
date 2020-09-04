require "test_helper"

#noinspection RubyInstanceMethodNamingConvention
class Medusa::FileGroupTest < MiniTest::Test

  def setup
    @instance = ::Medusa::FileGroup.with_id(2412)
  end

  # with_id()

  def test_with_id_returns_an_instance
    @instance = ::Medusa::FileGroup.with_id(2412)
    assert_nil @instance.external_file_location
    assert_equal 2412, @instance.id
    assert_equal 'bit_level', @instance.storage_level
    assert_equal 'Content', @instance.title
    # TODO: update Medusa and uncomment this
    #assert_equal 'b3576c20-1ea8-0134-1d77-0050569601ca-6', @instance.uuid
  end

  # with_uuid()

  def test_with_uuid_returns_an_instance
    @instance = ::Medusa::FileGroup.with_uuid('b3576c20-1ea8-0134-1d77-0050569601ca-6')
    assert_nil @instance.external_file_location
    assert_equal 2412, @instance.id
    assert_equal 'bit_level', @instance.storage_level
    assert_equal 'Content', @instance.title
    # TODO: update Medusa and uncomment this
    #assert_equal 'b3576c20-1ea8-0134-1d77-0050569601ca-6', @instance.uuid
  end

  # collection()

  def test_collection_returns_a_collection
    col = @instance.collection
    assert col.kind_of?(::Medusa::Collection)
    assert_equal 67, @instance.collection.id
  end

  # directory()

  def test_directory_returns_a_directory_for_bit_level_file_groups
    dir = @instance.directory
    assert dir.kind_of?(::Medusa::Directory)
    assert_equal 499313, @instance.directory.id
  end

  def test_directory_returns_nil_for_external_file_groups
    @instance = ::Medusa::FileGroup.with_id(141)
    assert_nil @instance.directory
  end

  # url()

  def test_url_returns_the_correct_url
    assert_equal [::Medusa::Client.configuration[:medusa_base_url].chomp('/'),
                  'file_groups',
                  @instance.id].join('/'),
                 @instance.url
  end

end
