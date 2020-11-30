require "test_helper"

#noinspection RubyInstanceMethodNamingConvention
class Medusa::FileTest < MiniTest::Test
  def setup
    @instance = ::Medusa::File.with_id(3663145025)
  end

  # from_json()

  def test_from_json_returns_an_instance
    json = {
        'id'                => 3,
        'uuid'              => '0d4fa60b-6562-5fd5-27f2-5e25476945bf',
        'name'              => 'hello.txt',
        'content_type'      => 'unknown/unknown',
        'md5_sum'           => '00000000000000000000000000000000',
        'size'              => 15,
        'mtime'             => '2020-01-01T10:05:30Z',
        'relative_pathname'	=> 'dir/dir/hello.txt'
    }
    @instance = ::Medusa::File.from_json(json)
    assert_equal 3, @instance.id
    assert_equal '00000000000000000000000000000000', @instance.md5_sum
    assert_equal 'unknown/unknown', @instance.media_type
    assert_equal Time.parse('2020-01-01T10:05:30Z'), @instance.mtime
    assert_equal 'dir/dir/hello.txt', @instance.relative_key
    assert_equal 15, @instance.size
    assert_equal '0d4fa60b-6562-5fd5-27f2-5e25476945bf', @instance.uuid
  end

  # with_id()

  def test_with_id_returns_an_instance_when_given_an_id
    @instance = ::Medusa::File.with_id(3663145025)
    assert_equal 3663145025, @instance.id
    assert_equal '00000000000000000000000000000000', @instance.md5_sum
    assert_equal 'unknown/unknown', @instance.media_type
    assert_equal Time.parse('2020-01-01T10:05:30Z'), @instance.mtime
    assert_equal 'repositories/1/collections/1/file_groups/1/root/escher_lego.jpg',
                 @instance.relative_key
    assert_equal 28399, @instance.size
    assert_equal 'da572841-80a8-86fb-48eb-6ba18ade48ef', @instance.uuid
  end

  # with_uuid()

  def test_with_uuid_returns_an_instance_when_given_a_uuid
    @instance = ::Medusa::File.with_uuid('da572841-80a8-86fb-48eb-6ba18ade48ef')
    #assert_equal 3663145025, @instance.id TODO: fix this
    assert_equal '00000000000000000000000000000000', @instance.md5_sum
    assert_equal 'unknown/unknown', @instance.media_type
    assert_equal Time.parse('2020-01-01T10:05:30Z'), @instance.mtime
    assert_equal 'repositories/1/collections/1/file_groups/1/root/escher_lego.jpg',
                 @instance.relative_key
    assert_equal 28399, @instance.size
    assert_equal 'da572841-80a8-86fb-48eb-6ba18ade48ef', @instance.uuid
  end

  # exists?()

  def test_exists_with_an_existing_file
    assert @instance.exists?
  end

  def test_exists_with_a_non_existing_file
    @instance = ::Medusa::File.with_id(999999)
    assert !@instance.exists?
  end

  # relative_key()

  def test_relative_key_returns_the_correct_key
    assert_equal 'repositories/1/collections/1/file_groups/1/root/escher_lego.jpg',
                 @instance.relative_key
  end

  # url()

  def test_url_returns_the_correct_url
    assert_equal [::Medusa::Client.configuration[:medusa_base_url].chomp('/'),
                  'cfs_files',
                  @instance.id].join('/'),
                 @instance.url
  end

end
