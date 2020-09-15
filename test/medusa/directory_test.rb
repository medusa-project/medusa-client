require "test_helper"

#noinspection RubyInstanceMethodNamingConvention
class Medusa::DirectoryTest < MiniTest::Test

  def setup
    # N.B.: for testing, it's best to choose a directory that contains both
    # files and subdirectories
    @instance = ::Medusa::Directory.with_id(30193726375172)
  end

  # with_id()

  def test_with_id_returns_an_instance
    @instance = ::Medusa::Directory.with_id(30193726375172)
    assert_equal 30193726375172, @instance.id
    assert_equal 'repositories/1/collections/1/file_groups/1/root', @instance.relative_key
    assert_equal '1b760655-c504-7fce-f171-76e4234844da', @instance.uuid
  end

  # with_uuid()

  def test_with_uuid_returns_an_instance
    @instance = ::Medusa::Directory.with_uuid('1b760655-c504-7fce-f171-76e4234844da')
    #assert_equal 30193726375172, @instance.id TODO: fix this
    assert_equal 'repositories/1/collections/1/file_groups/1/root', @instance.relative_key
    assert_equal '1b760655-c504-7fce-f171-76e4234844da', @instance.uuid
  end

  # directories()

  def test_directories_returns_subdirectories
    assert_equal 2, @instance.directories.length
  end

  # files()

  def test_files_returns_files
    files = @instance.files
    assert_equal 1, files.length
    file = files.first
    assert_equal 240067872391336, file.id
  end

  # name()

  def test_name_returns_the_directory_name
    assert_equal 'root', @instance.name
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
    dir_count  = 0
    file_count = 0
    @instance.walk_tree do |node|
      if node.kind_of?(::Medusa::Directory)
        dir_count += 1
      else
        file_count += 1
      end
    end
    assert_equal 4, dir_count
    assert_equal 4, file_count
  end

end
