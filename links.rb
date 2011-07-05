# get the links from facebook in json format
# https://graph.facebook.com/169773219723405/links?limit=250&access_token=2227470867|2.AQCbRoxLYdKjAmZ0.3600.1308261600.0-100001705300396|9e-AEanNKrYsUgjuTMm0m5mcvM0


#transform the json in csv format

require 'CSV'

a = Array.new
json = JSON.parse(File.open('links.js').read)
jsin = json.values[0]

CSV.open("links.csv", "w") do |csv|

(0..25).each do |i|
  (0..6).each do |j|
    a[j] = jsin[i].values[j]
    end
    csv << a
  end

end
