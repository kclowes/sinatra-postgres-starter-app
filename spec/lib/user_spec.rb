require 'spec_helper'

require 'sequel'


describe 'User Repository' do
before do
  @usertable = DB[:users]
end

  it 'it can create a user' do
    id = @usertable.insert(email: "email", password: "password", admin: false)
    expect(@usertable.where[:id => id]).to eq({id: id, email: "email", password: "password", admin: false})
  end
end