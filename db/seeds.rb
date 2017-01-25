# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'csv'


songs = CSV.read("./songdata.csv")
# binding.pry

ActiveRecord::Base.connection.execute("TRUNCATE TABLE songs")
i = 0
while i < songs.length - 1

  #1000 at a time
  ActiveRecord::Base.transaction do
    loop do
      i += 1
      Song.create(artist: songs[i][0], name: songs[i][1], link: songs[i][2], lyrics: songs[i][3])
      print "*" if i % 100 == 0
      break if i % 1000 == 0 || i == songs.length - 1
    end
  end
end
