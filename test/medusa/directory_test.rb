require "test_helper"

#noinspection RubyInstanceMethodNamingConvention
class Medusa::DirectoryTest < MiniTest::Test

  def setup
    # N.B.: for testing, it's best to choose a directory that contains both
    # files and subdirectories
    @instance = ::Medusa::Directory.with_id(1553881)
  end

  # with_id()

  def test_with_id_returns_an_instance
    @instance = ::Medusa::Directory.with_id(1553881)
    assert_equal 1553881, @instance.id
    assert_equal '1337/3495/2630011/access', @instance.relative_key
    assert_equal '3b21b070-5546-0136-4f2e-0050569601ca-0', @instance.uuid
  end

  # with_uuid()

  def test_with_uuid_returns_an_instance
    @instance = ::Medusa::Directory.with_uuid('3b21b070-5546-0136-4f2e-0050569601ca-0')
    #assert_equal 1553881, @instance.id TODO: fix this
    assert_equal '1337/3495/2630011/access', @instance.relative_key
    assert_equal '3b21b070-5546-0136-4f2e-0050569601ca-0', @instance.uuid
  end

  # directories()

  def test_directories_returns_subdirectories
    assert_equal 1, @instance.directories.length
  end

  # files()

  def test_files_returns_files
    files = @instance.files
    assert_equal 1, files.length
    file = files.first
    assert_equal 53912360, file.id
  end

  # name()

  def test_name_returns_the_directory_name
    assert_equal 'access', @instance.name
  end

  # url()

  def test_url_returns_the_correct_url
    expected = [::Medusa::Client.configuration[:medusa_base_url].chomp('/'),
                'cfs_directories',
                @instance.id].join('/')
    assert_equal expected, @instance.url
  end

  # walk_tree()

  def test_walk_tree_works
    dir = ::Medusa::Directory.with_id(111272)
    count = 0
    dir.walk_tree do |node|
      assert !node.nil?
      count += 1
    end
    assert_equal 305, count
  end

end
