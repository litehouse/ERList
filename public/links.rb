#require 'FasterCSV'
<%
a = Array.new
json = JSON.parse(File.open('links.js').read)
jsin = json.values[0]

FasterCSV.open("links.csv", "w") do |csv|

(0..25).each do |i|
  (0..6).each do |j|
    a[i][j] = jsin[i].values[j]
    csv << a
    end
  end

end
%>