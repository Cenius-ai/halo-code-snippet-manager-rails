class HomeController < ApplicationController
  def index
    @snippets = Snippet.recent
  end
end
