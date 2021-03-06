require 'browser'

class Shortener::ShortenedUrlsController < ActionController::Base

  def show
    browser = Browser.new(request.user_agent, accept_language: request.env['HTTP_ACCEPT_LANGUAGE'])
    track   = Shortener.exclude_bots ? !browser.bot? : true

    token = ::Shortener::ShortenedUrl.extract_token(params[:id])
    url   = ::Shortener::ShortenedUrl.fetch_with_token(token: token,
                                                       additional_params: permitted_params,
                                                       track: track)
    redirect_to url[:url], status: :moved_permanently
  end

  private

  def permitted_params
    params.permit!.except(:controller, :action, :id)
  end
end
