module Cube
  def self.artists_report
    ActiveRecord::Base.connection.execute(
    "SELECT artist, COUNT(*) AS count FROM songs 
      GROUP BY artist
      ORDER BY artist;")
  end
end
