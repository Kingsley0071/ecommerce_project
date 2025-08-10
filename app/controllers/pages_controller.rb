class PagesController < ApplicationController
  def show
    @page = Page.find_by(title: params[:id].capitalize)
    @breadcrumbs = [
      { name: "Home", path: root_path },
      { name: @page.title, path: page_path(params[:id]) }
    ]
    render :show
  end
end
