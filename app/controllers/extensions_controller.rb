class ExtensionsController < ApplicationController
  before_action :set_extension, only: [:show, :edit, :update, :destroy]

  # GET /extensions
  def index
    @extensions = Extension.all
  end

  # GET /extensions/1
  def show
  end

  # GET /extensions/new
  def new
    @extension = Extension.new
  end

  # GET /extensions/1/edit
  def edit
  end

  # POST /extensions
  def create
    @extension = Extension.new(extension_params)

    if @extension.save
      redirect_to extensions_url, notice: 'Extension was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /extensions/1
  def update
    if @extension.update(extension_params)
      redirect_to extensions_url, notice: 'Extension was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /extensions/1
  def destroy
    @extension.destroy
    redirect_to extensions_url, notice: 'Extension was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_extension
      @extension = Extension.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def extension_params
      params.require(:extension).permit([:name])
    end
end
