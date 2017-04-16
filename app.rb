require('pry')
require("bundler/setup")
require('pg')

DB = PG.connect({:dbname => "shoes_development"})
  Bundler.require(:default)
  Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }
  also_reload("lib/*.rb")

get('/') do
  # average_rating= @brand.ratings.average("score").to_f
  @brands = Brand.all()
  @ratings = Rating.all
  @stores = Store.all
  @add_new_store = params[:add_new_store]
  @topbrands = DB.exec("select brands.* ,avg(score) from ratings join brands on (brands.id = ratings.brand_id) group by brands.id order by avg(score) desc;")
  erb(:index)
end

get ('/brand/:id/view/?') do
  @brand=Brand.find(Integer(params.fetch('id')))
  @average_rating= @brand.ratings.average("score").to_f
  @stores = Store.all()
  erb(:brand_view)
end

get ('/stores') do
  @stores = Store.all()
  erb(:stores)
end

get ('/store/:id') do
  store_id=Integer(params.fetch("id"))
  @store = Store.find(store_id)
  erb(:store)
end

delete ('/store') do
  store_id=Integer(params.fetch("store_id"))
  store = Store.find(store_id)
  store.destroy
  redirect("/stores")
end

post ('/brand') do
  name = params.fetch('name')
  images = params.fetch('images')
  brand = Brand.create({:name => name, :images => images})
  redirect ('/')
end

post ('/store') do
  brand_id = Integer(params.fetch('brand_id'))
  brand= Brand.find(brand_id)
  store_id = Integer(params.fetch('store_id'))
  store = Store.find(store_id)
  BrandsStore.create(brand: brand, store: store)
  redirect("/brand/#{brand_id}/view/?")
end

patch('/store') do
  store = Store.find(params.fetch('id').to_i)
  name = params.fetch('name')
  address = params.fetch('address')
  store.update({:name => name, :address=> address})
  redirect("/stores")
end

post ('/store/new') do
  store_name = params.fetch('store')
  store = Store.create({:name=>store_name})
  redirect("/")
end

delete ('/brands_store') do
  brand_id=Integer(params.fetch("brand_id"))
  store_id=Integer(params.fetch("store_id"))
  brands_store = DB.exec("DELETE FROM brands_stores WHERE brand_id=#{brand_id} AND store_id=#{store_id};")
  redirect("/brand/#{brand_id}/view/?")
end

post ('/rating') do
  brand_id = Integer(params.fetch('brand_id'))
  name = params.fetch('user_name')
  rating = Integer(params.fetch('rating'))
  ing = Rating.create({:name => name,:score=>rating,:brand_id => brand_id})
  redirect("/brand/#{brand_id}/view/?")
end
