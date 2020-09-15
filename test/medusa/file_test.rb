require "test_helper"

#noinspection RubyInstanceMethodNamingConvention
class Medusa::FileTest < MiniTest::Test
  def setup
    @instance = ::Medusa::File.with_id(240067872391336)
  end

  # with_id()

  def test_with_id_returns_an_instance_when_given_an_id
    @instance = ::Medusa::File.with_id(240067872391336)
    assert_equal 240067872391336, @instance.id
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
    #assert_equal 240067872391336, @instance.id TODO: fix this
    assert_equal '00000000000000000000000000000000', @instance.md5_sum
    assert_equal 'unknown/unknown', @instance.media_type
    assert_equal Time.parse('2020-01-01T10:05:30Z'), @instance.mtime
    assert_equal 'repositories/1/collections/1/file_groups/1/root/escher_lego.jpg',
                 @instance.relative_key
    assert_equal 28399, @instance.size
    assert_equal 'da572841-80a8-86fb-48eb-6ba18ade48ef', @instance.uuid
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
