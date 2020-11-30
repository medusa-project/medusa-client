require "test_helper"

#noinspection RubyInstanceMethodNamingConvention
class Medusa::CollectionTest < MiniTest::Test

  def setup
    @instance = ::Medusa::Collection.with_id(1)
  end

  # with_id()

  def test_with_id_returns_an_instance
    @instance = ::Medusa::Collection.with_id(1)
    assert_equal 'https://example.org/', @instance.access_url
    assert_equal 'alexd@illinois.edu', @instance.contact_email
    assert_equal 'This collection contains Mockdusa test content.', @instance.description
    assert_equal '<p>This collection contains Mockdusa test content.</p>', @instance.description_html
    assert_nil @instance.external_id
    assert_equal 2, @instance.file_groups.length
    assert_equal 1, @instance.id
    assert_nil @instance.physical_collection_url
    assert_nil @instance.private_description
    assert @instance.published?
    assert_nil @instance.representative_image
    assert_nil @instance.representative_item
    assert_equal 'Mockdusa Test Collection', @instance.title
    assert_equal '81a13f45-d149-3dd7-f233-53cc395217fa', @instance.uuid
  end

  # with_uuid()

  def test_with_uuid_returns_an_instance
    @instance = ::Medusa::Collection.with_uuid('81a13f45-d149-3dd7-f233-53cc395217fa')
    assert_equal 'https://example.org/', @instance.access_url
    assert_equal 'alexd@illinois.edu', @instance.contact_email
    assert_equal 'This collection contains Mockdusa test content.', @instance.description
    assert_equal '<p>This collection contains Mockdusa test content.</p>', @instance.description_html
    assert_nil @instance.external_id
    assert_equal 2, @instance.file_groups.length
    assert_equal 1, @instance.id
    assert_nil @instance.physical_collection_url
    assert_nil @instance.private_description
    assert @instance.published?
    assert_nil @instance.representative_image
    assert_nil @instance.representative_item
    assert_equal 'Mockdusa Test Collection', @instance.title
    assert_equal '81a13f45-d149-3dd7-f233-53cc395217fa', @instance.uuid
  end

  # exists?()

  def test_exists_with_an_existing_collection
    assert @instance.exists?
  end

  def test_exists_with_a_non_existing_collection
    @instance = ::Medusa::Collection.with_id(999999)
    assert !@instance.exists?

    @instance = ::Medusa::Collection.with_uuid('aaaaaaaa')
    assert !@instance.exists?
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
    repo = @instance.repository
    assert repo.kind_of?(Medusa::Repository)
    assert_equal '40b62a2d-209f-292a-b1fc-4818b3321e6a', repo.uuid
  end

  # url()

  def test_url_returns_the_URL
    assert_equal ::Medusa::Client.configuration[:medusa_base_url] + '/collections/' +
                     @instance.id.to_s,
                 @instance.url
  end

end

