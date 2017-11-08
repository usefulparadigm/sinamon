# resources/entries.rb

module Resource
  class Entries < Base

    ## GET /entries - return entries
    get "/entries/?", :provides => :json do
      entries = Entry.page(params[:page] || 1)
      if entries
        entries.to_json
      else
        # json_status 404, "Not found"
        404
      end
    end

    ## GET /entries/:id - return entry with specified id
    get "/entries/:id", :provides => :json do
      # entry = Entry.where(_id: params[:id]).first
      begin
        entry = Entry.find(params[:id])
        entry.to_json
      rescue
        404
      end  
    end

    ## POST /entires/ - create new entry
    post "/entries/?", :provides => :json do
      # new_params = accept_params(params, :title, :body)
      entry = Entry.new(params[:entry])
      if entry.save
        headers["Location"] = "/entries/#{entry.id}"
        # http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html#sec9.5
        status 201 # Created
        entry.to_json
      else
        json_status 400, entry.errors.to_hash
      end
    end

    ## PUT /entries/:id - update an entry
    put "/entries/:id", :provides => :json do
      # new_params = accept_params(params, :name, :status)
      begin
        entry = Entry.find(params[:id])
        if entry.update_attributes(params[:entry])
          entry.to_json
        else
          json_status 400, entry.errors.to_hash
        end
      rescue
        404
      end
    end

    ## DELETE /entries/:id - delete a specific entry
    delete "/entries/:id", :provides => :json do
      begin
        entry = Entry.find(params[:id])
        entry.destroy
        # http://www.w3.org/Protocols/rfc2616/rfc2616-sec9.html#sec9.7
        status 204 # No content
      rescue
        404
      end
    end

  end
end
