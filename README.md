InstaLeave
==========
 
This is a small Sinatra app to have all your Instagram pictures downloaded.

You'll need Ruby ruby-1.9.3-p194 or up and Bundler.

Register a client with Instagram at http://instagram.com/developer/clients/manage/

Fill in these fields with:

Website:            http://localhost:3001/

OAuth redirect_uri: http://localhost:3001/redirect

Write your client key and secret in instaleave.rb

> `gem install bundler`

> `bundle`

> `rackup -p 3001`

open http://localhost:3001, authorize with Instagram and let it download all your orders into ./media.