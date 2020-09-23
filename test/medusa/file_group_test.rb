require "test_helper"

#noinspection RubyInstanceMethodNamingConvention
class Medusa::FileGroupTest < MiniTest::Test

  def setup
    @instance = ::Medusa::FileGroup.with_id(1)
  end

  # with_id()

  def test_with_id_returns_an_instance
    @instance = ::Medusa::FileGroup.with_id(1)
    assert_nil @instance.external_file_location
    assert_equal 1, @instance.id
    assert_equal 'bit_level', @instance.storage_level
    assert_equal 'Content', @instance.title
    assert_equal '5881d456-6dbe-90f1-ac81-7e0bf53e9c84', @instance.uuid
  end

  # with_uuid()

  def test_with_uuid_returns_an_instance
    @instance = ::Medusa::FileGroup.with_uuid('5881d456-6dbe-90f1-ac81-7e0bf53e9c84')
    assert_nil @instance.external_file_location
    assert_equal 1, @instance.id
    assert_equal 'bit_level', @instance.storage_level
    assert_equal 'Content', @instance.title
    assert_equal '5881d456-6dbe-90f1-ac81-7e0bf53e9c84', @instance.uuid
  end

  # collection()

  def test_collection_returns_a_collection
    col = @instance.collection
    assert col.kind_of?(::Medusa::Collection)
    assert_equal 1, @instance.collection.id
  end

  # directory()

  def test_directory_returns_a_directory_for_bit_level_file_groups
    dir = @instance.directory
    assert dir.kind_of?(::Medusa::Directory)
    assert_equal 460719701, @instance.directory.id
  end

  def test_directory_returns_nil_for_external_file_groups
    @instance = ::Medusa::FileGroup.with_id(2)
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
