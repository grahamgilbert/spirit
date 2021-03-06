require 'spec_helper'
require 'shared_examples_http'
require 'cfpropertylist'

PACKAGES_PATH = File.expand_path(__FILE__ + '/../../../ds_repo/Packages')

describe '/packages/sets' do
  def stub_sets
    FileUtils.mkdir_p(File.join(PACKAGES_PATH, 'Package Set 1'))
  end

  before(:each) do
    stub_sets

  end


  describe '/get/all' do
    before do
      get '/packages/sets/get/all', { 'id' => 'W1111GTM4QQ' }
    end

    it_behaves_like 'a binary plist response'
  end

  describe '/get/entry' do
    before do
      get '/packages/sets/get/entry', { 'id' => 'MockPackageSet' }
    end

    it_behaves_like 'a binary plist response'
  end

  describe '/add/entry?id=&pkg= (add package to set)' do
    before do
      post '/packages/sets/add/entry', { 'id' => 'MockPackageSet', 'pkg' => 'Mock.pkg' }
    end

    it_behaves_like 'a successful post'
  end

  describe '/new/entry' do
    before do
      post '/packages/sets/new/entry'
    end

    it_behaves_like 'a successful post'
  end

  describe '/ren/entry?id=&new_id=' do
    before do
      post '/packages/sets/ren/entry', { 'id' => 'MockPackageSet', 'new_id' => 'MockRenamedPackageSet' }
    end

    it_behaves_like 'a successful post'
  end

end