require 'spec_helper'

describe AuthorsController do
  describe 'GET show' do
    let(:matz) { Author.create! name: 'Matz' }
    it 'assigns the requested author as @author' do
      get :show, :id => matz.id
      assigns(:author).should eq(matz)
    end
  end
end
