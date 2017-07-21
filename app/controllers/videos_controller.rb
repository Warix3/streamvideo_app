require 'mime/types'
class VideosController < ApplicationController
  include Rstreamor
  def index
  end

  def show
    @video = Video.find params[:id]
    # stream @video.profile unless @video
    f = ::File.open(Rails.root.join('app/assets/images/Despacito.mp4'))
    file = CarrierWave::SanitizedFile.new(f)
    file.content_type = MimeMagic.by_magic(f).type
    stream file


    # Gets list of remote files.
    # @list_files = MyDrive.list_files
  end

  def create
    @video = Video.new video_params
    if @video.save
      redirect_to @video
    else
      render :index
    end
  end

  private
  def video_params
    params.require(:video).permit(:profile)
  end
end

class MyDrive
  class << self
    def list_files
      # scope = 'https://www.googleapis.com/auth/androidpublisher'
      service_account_key_path = Rails.root.join("app/lib/server_secret.json")

      # authorizer = Google::Auth::ServiceAccountCredentials.make_creds(
      #   json_key_io: File.open(service_account_key_path),
      #   scope: scope)
      # authorizer.fetch_access_token!

      session = GoogleDrive::Session.from_service_account_key(service_account_key_path)
      session.files
    end
  end
end
