require './lib/cube'

class SongsController < ApplicationController
 # %%% Had to use the following command to fix issue with very common words breaking pagination over page 201
 # %%% curl -XPUT "http://localhost:9200/songs/_settings" -d '{ "index" : { "max_result_window" : 500000 } }'


  def data

    @results = Cube.artists_report
    respond_to do |format|
      format.html { }
      format.json {
        root = {name: "root", children: []}
        # artists = ActiveRecord::Base.connection.execute("
        #   SELECT DISTINCT artists FROM songs;")
        @results.each do |artist|
          artists_hash = {name: artist["artist"], size: artist["count"].to_i}
          # @results.each do |result|
          #   # fill up employee data
          #   if result["artist"] == artist["artist"]
          #     artists_hash[:children] << {name: result["artist"], size: result["score"].to_f}
          #   end
          # end
          root[:children] << artists_hash
        end
        render json: root
      }
    end
  end
  def index
    respond_to do |format|
      format.html {
        if !params[:lyrics].blank?
          @songs = Song.search(query:{query_string:{query: params[:lyrics]}}, size: 5000).paginate(page: params[:page], per_page: 50)
        elsif !params[:artist].blank?
          @songs = Song.where(artist: params[:artist]).paginate(page: params[:page], per_page: 100).order("name ASC")
        else
          @songs = Song.where("score IS NOT NULL").order("score DESC").paginate(page: params[:page], per_page: 50)
        end
      }
      format.json {
        render json: Song.search(params[:q]).map{|song| song._source.name}
      }
    end
  end

  def show
    @song = Song.find_by(id: params[:id])
    @lyrics = @song.lyrics.gsub(/\n/, "<br/>")
    @song.update(score: (@song.score || 0) + 1)
    UserMailer.confirmation.deliver_later
  end
end
