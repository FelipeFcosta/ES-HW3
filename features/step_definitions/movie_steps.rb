Given /^the following movies exist:/ do |movies_table|
  movieHashes = movies_table.hashes   # {"title"=>"Aladdin", "rating"=>"G", "release_date"=>"25-Nov-1992"}, {"title"=> "...
  
  movieHashes.each do |movie|
    Movie.create! movie
  end
  
end

Given /I (un)?check the following ratings: (.*)$/ do |uncheck, ratings|
  ratings.split(', ').each do |rating|
    if !uncheck
      page.check("ratings_#{rating}")
    else
      page.uncheck("ratings_#{rating}")
    end
  end
end

Given /I check all ratings/ do
  steps %Q{Given I check the following ratings: #{Movie.all_ratings.join(', ')}}
end

Then /I should see all of the movies/ do
  # page.all("#movies tbody tr").size.should == Movie.all.size
  page.assert_selector('#movies tbody tr', count: Movie.all.size)
end

Then /I should see "(.*)" before "(.*)"$/ do |movie1, movie2|
  pos_movie1 = page.body =~ /#{movie1}/
  pos_movie2 = page.body =~ /#{movie2}/
  assert pos_movie1 < pos_movie2 
end
