# routes/entries.rb

namespace '/entries' do

  before do
    content_type :json
  end

  # GET /entries
  get '/?' do
    @entries = Entry.all
    @entries.to_json
  end

  # POST /entries
  post '/?' do
    @entry = Entry.new(params[:entry])
    @entry.save
    status 201
    @entry.to_json
  end

  # GET /entries/:id
  get '/:id' do
    @entry = Entry.find(params[:id])
    @entry.to_json
  end

  # PUT /entries/:id
  put '/:id' do
    @entry = Entry.find(params[:id])
    @entry.update_attributes!(params[:entry])
    @entry.to_json
  end  

  # DELETE /entries/:id
  delete '/:id' do
    @entry = Entry.find(params[:id])
    status 202
    @entry.destroy
  end  

end
