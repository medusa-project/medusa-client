require "test_helper"

#noinspection RubyInstanceMethodNamingConvention
class Medusa::RepositoryTest < MiniTest::Test

  def setup
    @instance = ::Medusa::Repository.with_id(1)
  end

  # with_id()

  def test_with_id_returns_an_instance
    @instance = ::Medusa::Repository.with_id(1)
    assert_equal 1, @instance.collections.length
    assert_equal 'alexd@illinois.edu', @instance.contact_email
    assert_equal 'alexd@illinois.edu', @instance.email
    assert_equal 'https://github.com/medusa-project/mockdusa', @instance.home_url
    assert_equal 1, @instance.id
    assert_equal 'uofi', @instance.ldap_admin_domain
    assert_equal 'Some Group', @instance.ldap_admin_group
    assert_equal 'Mockdusa Test Repository', @instance.title
    assert_equal '40b62a2d-209f-292a-b1fc-4818b3321e6a', @instance.uuid
  end

  # with_uuid()

  def test_with_uuid_returns_an_instance
    @instance = ::Medusa::Repository.with_uuid('40b62a2d-209f-292a-b1fc-4818b3321e6a')
    assert_equal 1, @instance.collections.length
    assert_equal 'alexd@illinois.edu', @instance.contact_email
    assert_equal 'alexd@illinois.edu', @instance.email
    assert_equal 'https://github.com/medusa-project/mockdusa', @instance.home_url
    assert_equal 1, @instance.id
    assert_equal 'uofi', @instance.ldap_admin_domain
    assert_equal 'Some Group', @instance.ldap_admin_group
    assert_equal 'Mockdusa Test Repository', @instance.title
    assert_equal '40b62a2d-209f-292a-b1fc-4818b3321e6a', @instance.uuid
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

