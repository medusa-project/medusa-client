require "test_helper"

#noinspection RubyInstanceMethodNamingConvention
class Medusa::CollectionTest < MiniTest::Test

  def setup
    @instance = ::Medusa::Collection.with_id(55)
  end

  # with_id()

  def test_with_id_returns_an_instance
    @instance = ::Medusa::Collection.with_id(55)
    assert_equal 'https://digital.library.illinois.edu/collections/8116a380-e3fb-012f-c5b6-0019b9e633c5-c',
                 @instance.access_url
    assert_nil @instance.contact_email
    assert @instance.description.start_with?('This collection is')
    assert @instance.description_html.start_with?('<p>This collection is')
    assert_equal '3501042', @instance.external_id
    assert_equal 4, @instance.file_groups.length
    assert_equal 55, @instance.id
    assert_equal 'https://archives.library.illinois.edu/archon/index.php?p=collections/controlcard&id=5008',
                 @instance.physical_collection_url
    assert_equal '', @instance.private_description
    assert @instance.published?
    assert_equal '', @instance.representative_image
    assert_equal '7dc8e560-0b13-0134-1d55-0050569601ca-f',
                 @instance.representative_item
    assert_equal 'French World War I Posters', @instance.title
    assert_equal '8116a380-e3fb-012f-c5b6-0019b9e633c5-c', @instance.uuid
  end

  # with_uuid()

  def test_with_uuid_returns_an_instance
    @instance = ::Medusa::Collection.with_uuid('8116a380-e3fb-012f-c5b6-0019b9e633c5-c')
    assert_equal 'https://digital.library.illinois.edu/collections/8116a380-e3fb-012f-c5b6-0019b9e633c5-c',
                 @instance.access_url
    assert_nil @instance.contact_email
    assert @instance.description.start_with?('This collection is')
    assert @instance.description_html.start_with?('<p>This collection is')
    assert_equal '3501042', @instance.external_id
    assert_equal 4, @instance.file_groups.length
    assert_equal 55, @instance.id
    assert_equal 'https://archives.library.illinois.edu/archon/index.php?p=collections/controlcard&id=5008',
                 @instance.physical_collection_url
    assert_equal '', @instance.private_description
    assert @instance.published?
    assert_equal '', @instance.representative_image
    assert_equal '7dc8e560-0b13-0134-1d55-0050569601ca-f',
                 @instance.representative_item
    assert_equal 'French World War I Posters', @instance.title
    assert_equal '8116a380-e3fb-012f-c5b6-0019b9e633c5-c', @instance.uuid
  end

  # load()

  def test_load_loads_an_existing_collection
    @instance.load

  end

  def test_load_raises_an_error_for_a_non_existing_collection
    col = ::Medusa::Collection.with_id(999999)
    assert_raises ::Medusa::NotFoundError do
      col.load
    end
  end

  # repository()

  def test_repository_returns_a_repository
    @instance.load
    repo = @instance.repository
    assert repo.kind_of?(Medusa::Repository)
    assert_equal '1319d320-2f1c-0137-6bed-02d0d7bfd6e4-7', repo.uuid
  end

  # url()

  def test_url_returns_the_URL
    assert_equal ::Medusa::Client.configuration[:medusa_base_url] + '/collections/' +
                     @instance.id.to_s,
                 @instance.url
  end

end

