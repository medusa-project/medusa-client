require "test_helper"

#noinspection RubyInstanceMethodNamingConvention
class Medusa::FileTest < MiniTest::Test
  def setup
    @instance = ::Medusa::File.with_id(13353741)
  end

  # with_id()

  def test_with_id_returns_an_instance_when_given_an_id
    @instance = ::Medusa::File.with_id(13353741)
    assert_equal 13353741, @instance.id
    assert_equal '458ebd49e5bcf6c0feddf6f17cb48c26', @instance.md5_sum
    assert_equal 'image/tiff', @instance.media_type
    assert_equal Time.parse('2008-06-18T16:18:48Z'), @instance.mtime
    assert_equal '67/2412/preservation/11100008b.tif', @instance.relative_key
    assert_equal 36880324, @instance.size
    assert_equal '4d35ff40-1eab-0134-1d73-0050569601ca-f', @instance.uuid
  end

  # with_uuid()

  def test_with_uuid_returns_an_instance_when_given_a_uuid
    @instance = ::Medusa::File.with_uuid('4d35ff40-1eab-0134-1d73-0050569601ca-f')
    @instance.load
    assert_equal 13353741, @instance.id
    assert_equal '458ebd49e5bcf6c0feddf6f17cb48c26', @instance.md5_sum
    assert_equal 'image/tiff', @instance.media_type
    assert_equal Time.parse('2008-06-18T16:18:48Z'), @instance.mtime
    assert_equal '67/2412/preservation/11100008b.tif', @instance.relative_key
    assert_equal 36880324, @instance.size
    assert_equal '4d35ff40-1eab-0134-1d73-0050569601ca-f', @instance.uuid
  end

  # relative_key()

  def test_relative_key_returns_the_correct_key
    @instance.load
    assert_equal '67/2412/preservation/11100008b.tif', @instance.relative_key
  end

  # url()

  def test_url_returns_the_correct_url
    assert_equal [::Medusa::Client.configuration[:medusa_base_url].chomp('/'),
                  'cfs_files',
                  @instance.id].join('/'),
                 @instance.url
  end

end
