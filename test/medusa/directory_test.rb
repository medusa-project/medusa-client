require "test_helper"

#noinspection RubyInstanceMethodNamingConvention
class Medusa::DirectoryTest < MiniTest::Test

  def setup
    # N.B.: for testing, it's best to choose a directory that contains both
    # files and subdirectories
    @instance = ::Medusa::Directory.with_id(460719701)
  end

  # from_json()

  def test_from_json_returns_an_instance
    json = {
        'id'             => 3,
        'uuid'           => '9fe12966-2be0-e43d-fe3b-8bbbe3c99c90',
        'name'           => 'some_dir',
        'parent_id'      => 5,
        'parent_type'    => 'CfsDirectory',
        'files'          => [],
        'subdirectories' => []
    }
    @instance = ::Medusa::Directory.from_json(json)
    assert_equal 3, @instance.id
    #assert_equal 'repositories/1/collections/1/file_groups/1/root', @instance.relative_key TODO: fix this
    assert_equal '9fe12966-2be0-e43d-fe3b-8bbbe3c99c90', @instance.uuid
  end

  # with_id()

  def test_with_id_returns_an_instance
    @instance = ::Medusa::Directory.with_id(460719701)
    assert_equal 460719701, @instance.id
    assert_equal 'repositories/1/collections/1/file_groups/1/root', @instance.relative_key
    assert_equal '1b760655-c504-7fce-f171-76e4234844da', @instance.uuid
  end

  # with_uuid()

  def test_with_uuid_returns_an_instance
    @instance = ::Medusa::Directory.with_uuid('1b760655-c504-7fce-f171-76e4234844da')
    #assert_equal 460719701, @instance.id TODO: fix this
    assert_equal 'repositories/1/collections/1/file_groups/1/root', @instance.relative_key
    assert_equal '1b760655-c504-7fce-f171-76e4234844da', @instance.uuid
  end

  # directories()

  def test_directories_returns_subdirectories
    assert_equal 2, @instance.directories.length
  end

  # directory_tree_url()

  def test_directory_tree_url_returns_the_correct_url
    expected = [::Medusa::Client.configuration[:medusa_base_url].chomp('/'),
                'cfs_directories',
                @instance.id,
                'show_tree.json'].join('/')
    assert_equal expected, @instance.directory_tree_url
  end

  # exists?()

  def test_exists_with_an_existing_directory
    assert @instance.exists?
  end

  def test_exists_with_a_non_existing_directory
    @instance = ::Medusa::Directory.with_id(999999)
    assert !@instance.exists?

    @instance = ::Medusa::Directory.with_uuid('aaaaaaaa')
    assert !@instance.exists?
  end

  # files()

  def test_files_returns_files
    files = @instance.files
    assert_equal 1, files.length
    file = files.first
    assert_equal 3663145025, file.id
  end

  # name()

  def test_name_returns_the_directory_name
    assert_equal 'root', @instance.name
  end

  # parent()

  def test_parent_returns_the_parent_directory
    @instance = ::Medusa::Directory.with_id(2682333542)
    assert_equal 460719701, @instance.parent.id
  end

  def test_parent_returns_nil_for_root_directories
    assert_nil @instance.parent
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
