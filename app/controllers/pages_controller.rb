class PagesController < ApplicationController
  def about
    @breadcrumbs = [
      { name: "Home", path: root_path },
      { name: "About" }
    ]
  end

  def show
    @page = Page.find_by(title: params[:id].capitalize)
    @breadcrumbs = [
      { name: "Home", path: root_path },
      { name: @page&.title || params[:id].capitalize, path: page_path(params[:id]) }
    ]
    render :show
  end
end