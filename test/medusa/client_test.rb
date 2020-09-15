require "test_helper"

#noinspection RubyInstanceMethodNamingConvention
class Medusa::ClientTest < Minitest::Test

  def setup
    @instance = ::Medusa::Client.instance
  end

  # class_of_uuid()

  def test_class_of_uuid_returns_repository
    uuid = '40b62a2d-209f-292a-b1fc-4818b3321e6a'
    assert_equal ::Medusa::Repository, @instance.class_of_uuid(uuid)
  end

  def test_class_of_uuid_returns_collection
    uuid = '81a13f45-d149-3dd7-f233-53cc395217fa'
    assert_equal ::Medusa::Collection, @instance.class_of_uuid(uuid)
  end

  def test_class_of_uuid_returns_file_group
    uuid = '5881d456-6dbe-90f1-ac81-7e0bf53e9c84'
    assert_equal ::Medusa::FileGroup, @instance.class_of_uuid(uuid)
  end

  def test_class_of_uuid_returns_directory
    uuid = '1b760655-c504-7fce-f171-76e4234844da'
    assert_equal ::Medusa::Directory, @instance.class_of_uuid(uuid)
  end

  def test_class_of_uuid_returns_file
    uuid = 'da572841-80a8-86fb-48eb-6ba18ade48ef'
    assert_equal ::Medusa::File, @instance.class_of_uuid(uuid)
  end

  def test_class_of_uuid_returns_nil_when_given_an_invalid_ID
    assert !@instance.class_of_uuid('cats')
  end

end
