require "test_helper"

#noinspection RubyInstanceMethodNamingConvention
class Medusa::ClientTest < Minitest::Test

  def setup
    @instance = ::Medusa::Client.instance
  end

  # class_of_uuid()

  def test_class_of_uuid_returns_repository
    uuid = '133cd570-2f1c-0137-6bed-02d0d7bfd6e4-6'
    assert_equal ::Medusa::Repository, @instance.class_of_uuid(uuid)
  end

  def test_class_of_uuid_returns_collection
    uuid = '2f494400-b53e-0136-52a6-0050569601ca-9'
    assert_equal ::Medusa::Collection, @instance.class_of_uuid(uuid)
  end

  def test_class_of_uuid_returns_file_group
    uuid = '7afc3e80-b41b-0134-234d-0050569601ca-7'
    assert_equal ::Medusa::FileGroup, @instance.class_of_uuid(uuid)
  end

  def test_class_of_uuid_returns_directory
    uuid = '7b1f3340-b41b-0134-234d-0050569601ca-8'
    assert_equal ::Medusa::Directory, @instance.class_of_uuid(uuid)
  end

  def test_class_of_uuid_returns_file
    uuid = '6cc533c0-cebf-0134-238a-0050569601ca-3'
    assert_equal ::Medusa::File, @instance.class_of_uuid(uuid)
  end

  def test_class_of_uuid_returns_nil_when_given_an_invalid_ID
    assert !@instance.class_of_uuid('cats')
  end

end
