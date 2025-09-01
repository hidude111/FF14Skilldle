require 'nokogiri'
require 'open-uri'
require 'httparty'
require 'json'

BASE_URL = "https://na.finalfantasyxiv.com/jobguide/"

def scrape_job_actions(class_name)
  url = "#{BASE_URL}#{class_name}/"
  html = URI.open(url).read
  doc = Nokogiri::HTML(html)

  table = doc.at_css("table.job__table")

  rows = table.css("tbody tr")
  actions = []

  rows.each do |row|
    cells = row.css("td")
    next if cells.empty? || cells.size < 8

    # Grab icon (first td usually has an <img>)
    img_tag = cells[0].at_css("img")
    img_src = img_tag ? URI.join(url, img_tag['src']).to_s : nil

    # Clean text (replace <br> with spaces, collapse whitespace)
    cols = cells.map do |c|
      c.text.strip
    end

    action = {
      action_name:     cols[0],
      level_acquired:  cols[1],
      type_of_action:  cols[2],
      cast:            cols[3],
      recast:          cols[4],
      mp_cost:         cols[5],
      radius:          cols[6].gsub(/\s+/, " "),
      effect:          cols[7] || nil,
      class_name:      class_name,
      image:           img_src

    }

    # Normalize dash → nil
    action.each do |k, v|
      action[k] = nil if v.nil? || v == "—" || v == "-"
    end

    actions << action
  end

  actions
end

if __FILE__ == $0
  data = scrape_job_actions("darkknight")
  old_stdout = $stdout
  File.open("darkknight_skills.json", 'w') do |fo|
  $stdout = fo

  # ----
  puts JSON.pretty_generate(data)
  # ----

end
$stdout = old_stdout
end


