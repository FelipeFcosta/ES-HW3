Given /^the following movies exist:/ do |movies_table|
  movieHashes = movies_table.hashes   # {"title"=>"Aladdin", "rating"=>"G", "release_date"=>"25-Nov-1992"}, {"title"=> "...

  movieHashes.each do |movie|
    Movie.create! movie
  end

end

Given /I check the following ratings: (.*)$/ do |ratings|
  ratings.split(',').each do |rating|
    page.check("ratings_#{rating.strip}")
  end
end

Given /I check all ratings/ do
  steps %Q{Given I check the following ratings: #{Movie.all_ratings.join(', ')}}
end
