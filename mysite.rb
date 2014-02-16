#!/usr/bin/ruby1.9.3
require "sinatra"
require "pg"
set :bind, '0.0.0.0'
db1 = `echo $DB1_PORT`.scan(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/).first
nginx2 = `echo $NGINX2_PORT`.scan(/\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}/).first
db = PGconn.new(:host => db1, :dbname => "postgres", :user => "postgres")


get '/article' do
  time = Time.new
  array = Array.new
  `curl #{nginx2}/users`.split("\n").each do |user|
          array.push("<a href='/#{user}/article'>#{user}</a>")
  end
  array.unshift(Time.new - time)
  array.join("\n")
end
get '/:user/article' do |user|
  article = db.exec("SELECT * FROM article WHERE user_name='#{user}'").values.join("\n")
end
