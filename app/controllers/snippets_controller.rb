class SnippetsController < ApplicationController
  def new
    @snippet = Snippet.new
  end

  def create
    @snippet = Snippet.new(snippet_params)

    if @snippet.save
      redirect_to snippet_path(@snippet), notice: "Snippet created! Share the link below."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @snippet = Snippet.find_by!(short_code: params[:short_code])
  end

  def raw
    @snippet = Snippet.find_by!(short_code: params[:short_code])
    render plain: @snippet.content, content_type: "text/plain"
  end

  private

  def snippet_params
    params.require(:snippet).permit(:content, :language, :title)
  end
end
