# api/entries.rb
require 'grape'

module API
  class Entries < Grape::API

    resource :entries do

      # GET /entries
      get do
        Entry.page(params[:page] || 1)
      end
    
      # POST /entries
      post do
        Entry.create(params[:entry])
      end

      # GET /entries/:id
      get ':id' do
        Entry.find(params[:id])
      end

      # PUT /entries/:id
      put ':id' do
        Entry.find(params[:id]).update_attributes(params[:entry])
      end  

      # DELETE /entries/:id
      delete ':id' do
        Entry.find(params[:id]).destroy
      end  

    end
  end
end
