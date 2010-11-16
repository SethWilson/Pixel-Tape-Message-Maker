$LOAD_PATH << File.join(Dir.getwd,'lib')
require 'rubygems'
require 'sinatra'
require 'RMagick'
require 'GeneratePixelTapeMessage'
require 'haml'

get '/' do
  if request.xhr?
    "Hello, AJAX!"
  else 
   haml :index
 end
end

get '/label/:text/:size' do

  content_type 'image/jpg'
  puts params[:text].to_s.upcase
  img = GeneratePixelTapeMessage.new(params[:text].to_s.upcase)
  
  i = img.generate_label(params[:size])
  
  i.format = 'jpg'
  i.to_blob
end

get '/multiline/line1/*/line2/*/line3/*/' do 

  puts params[:splat].inspect

end


get '/download/:text/:size' do

  content_type 'image/jpg'
  img = GeneratePixelTapeMessage.new(params[:text].to_s.upcase)
  
  i = img.generate_label(params[:size])
  
  i.format = 'jpg'
  send_data i,
    :type => 'image/jpeg',
    :disposition => 'attachment'
  #i.to_blob
end
