require "test_helper"

#noinspection RubyInstanceMethodNamingConvention
class Medusa::RepositoryTest < MiniTest::Test

  def setup
    @instance = ::Medusa::Repository.with_id(22)
  end

  # with_id()

  def test_with_id_returns_an_instance
    @instance = ::Medusa::Repository.with_id(22)
    assert @instance.collections.length > 500
    assert_equal 'prom@illinois.edu', @instance.contact_email
    assert_equal 'illiarch@illinois.edu', @instance.email
    assert_equal 'http://archives.library.illinois.edu', @instance.home_url
    assert_equal 22, @instance.id
    assert_equal 'uofi', @instance.ldap_admin_domain
    assert_equal 'Library Medusa University Archives', @instance.ldap_admin_group
    assert_equal 'University of Illinois Archives', @instance.title
    assert_equal '1319d320-2f1c-0137-6bed-02d0d7bfd6e4-7', @instance.uuid
  end

  # with_uuid()

  def test_with_uuid_returns_an_instance
    @instance = ::Medusa::Repository.with_uuid('1319d320-2f1c-0137-6bed-02d0d7bfd6e4-7')
    assert @instance.collections.length > 500
    assert_equal 'prom@illinois.edu', @instance.contact_email
    assert_equal 'illiarch@illinois.edu', @instance.email
    assert_equal 'http://archives.library.illinois.edu', @instance.home_url
    assert_equal 22, @instance.id
    assert_equal 'uofi', @instance.ldap_admin_domain
    assert_equal 'Library Medusa University Archives', @instance.ldap_admin_group
    assert_equal 'University of Illinois Archives', @instance.title
    assert_equal '1319d320-2f1c-0137-6bed-02d0d7bfd6e4-7', @instance.uuid
  end

  # load()

  def test_load_loads_an_existing_repository
    @instance.load
    assert_equal 'uofi', @instance.ldap_admin_domain
  end

  def test_load_raises_an_error_for_a_non_existing_repository
    repo = ::Medusa::Repository.with_id(999999)
    assert_raises ::Medusa::NotFoundError do
      repo.load
    end
  end

  # url()

  def test_url_returns_the_URL
    assert_equal ::Medusa::Client.configuration[:medusa_base_url] + '/repositories/' +
                     @instance.id.to_s,
                 @instance.url
  end

end

