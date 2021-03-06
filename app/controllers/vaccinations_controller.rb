class VaccinationsController < ApplicationController
  # GET /vaccinations
  # GET /vaccinations.xml
  def index
    @vaccinations = Vaccination.find(:all)
    @vaccinations.sort! {|x, y| x.name <=> y.name}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vaccinations }
    end
  end

  # GET /vaccinations/1
  # GET /vaccinations/1.xml
  def show
    @vaccination = Vaccination.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vaccination }
    end
  end

  # GET /vaccinations/new
  # GET /vaccinations/new.xml
  def new
    @vaccination = Vaccination.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vaccination }
    end
  end

  # GET /vaccinations/1/edit
  def edit
    @vaccination = Vaccination.find(params[:id])
  end

  # POST /vaccinations
  # POST /vaccinations.xml
  def create
    @vaccination = Vaccination.new(params[:vaccination])  
    respond_to do |format|
      if @vaccination.save
        flash[:notice] = 'Vaccination was successfully created.'
        
        APP_LOGGER_LOG.info "VACCINATION CREATED - " + @vaccination[:name] + 
          " by USER " + self.current_user[:login]
        
        format.html { redirect_to(@vaccination) }
        format.xml  { render :xml => @vaccination, :status => :created, :location => @vaccination }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vaccination.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vaccinations/1
  # PUT /vaccinations/1.xml
  def update
    @vaccination = Vaccination.find(params[:id])

    respond_to do |format|
      if @vaccination.update_attributes(params[:vaccination])
        flash[:notice] = 'Vaccination was successfully updated.'
        
        APP_LOGGER_LOG.info "VACCINATION UPDATED - " + @vaccination[:name] + 
          " by USER " + self.current_user[:login]
        
        format.html { redirect_to(@vaccination) }
        format.xml  { render :xml => @vaccination }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vaccination.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vaccinations/1
  # DELETE /vaccinations/1.xml
  def destroy
    @vaccination = Vaccination.find(params[:id])
    @vaccination.destroy
    
    APP_LOGGER_LOG.info "VACCINATION DELETED - " + @vaccination[:name] + 
      " by USER " + self.current_user[:login]

    respond_to do |format|
      format.html { redirect_to(vaccinations_url) }
      format.xml  { head :ok }
    end
  end
end
