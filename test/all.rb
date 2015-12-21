require_relative "../lib/shigeru"

setup do
  Shigeru::Repository.new
end

test 'simple route' do |routes|
  routes.define :users, '/users'
  assert_equal '/users', routes.uri_for(:users)
end

test 'route with a regular parameter' do |routes|
  routes.define :users, '/users/{id}'
  assert_equal '/users/13', routes.uri_for(:users, id: 13)
end

test 'route with a regular parameter that needs to be escaped' do |routes|
  routes.define :users, '/users/{name}'
  assert_equal '/users/Shigeru%20Miyamoto', routes.uri_for(:users, name: 'Shigeru Miyamoto')
end

test 'route with multiple regular parameters' do |routes|
  routes.define :users, '/users/{id1,id2}'
  assert_equal '/users/13,14', routes.uri_for(:users, id1: 13, id2: 14)
end

test 'route with a regular parameter with an explode modifier' do |routes|
  routes.define :users, '/users/{ids*}'
  assert_equal '/users/13,15', routes.uri_for(:users, ids: [13,15])
end

test 'route with a query parameter' do |routes|
  routes.define :users, '/users{?name}'
  assert_equal '/users?name=alice', routes.uri_for(:users, name: 'alice')
end

test 'route with a multiple query parameters' do |routes|
  routes.define :users, '/users{?name,country}'
  assert_equal '/users?name=alice&country=argentina', routes.uri_for(:users, name: 'alice', country: 'argentina')
end

test 'route with a query parameter with an explode modifier' do |routes|
  routes.define :users, '/users{?name*}'
  assert_equal '/users?name=alice&name=bob', routes.uri_for(:users, name: ['alice', 'bob'])
end

test 'route with a path parameter' do |routes|
  routes.define :users, '/users{/id}'
  assert_equal '/users/13', routes.uri_for(:users, id: 13)
end

test 'route with multiple path parameters' do |routes|
  routes.define :users, '/users{/x,y}'
  assert_equal '/users/alice/bob', routes.uri_for(:users, x: 'alice', y: 'bob')
end

test 'route with a path parameter with an explode modifier' do |routes|
  routes.define :users, '/users{/xs*}'
  assert_equal '/users/alice/bob', routes.uri_for(:users, xs: ['alice', 'bob'])
end
