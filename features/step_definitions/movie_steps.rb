# Completed step definitions for basic features: AddMovie, ViewDetails, EditMovie 

Given /^I am on the RottenPotatoes home page$/ do
  visit movies_path
 end


 When /^I have added a movie with title "(.*?)" and rating "(.*?)"$/ do |title, rating|
  visit new_movie_path
  fill_in 'Title', :with => title
  select rating, :from => 'Rating'
  click_button 'Save Changes'
 end

 Then /^I should see a movie list entry with title "(.*?)" and rating "(.*?)"$/ do |title, rating| 
   result=false
   all("tr").each do |tr|
     if tr.has_content?(title) && tr.has_content?(rating)
       result = true
       break
     end
   end  
  expect(result).to be_truthy
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

 Then /^(?:|I )should see "([^"]*)"$/ do |text|
    expect(page).to have_content(text)
 end
 
 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end
 
# New step definitions to be completed for HW5. 
# Note that you may need to add additional step definitions beyond these
# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
    # Each returned movie will be a hash representing one row of the movies_table
    # The keys will be the table headers and the values will be the row contents.
    # Entries can be directly to the database with ActiveRecord methods
    # Add the necessary Active Record call(s) to populate the database.
  end
end

Then /^I should see "(.*?)" before "(.*?)"$/ do |e1, e2|
    result = false
    if (page.body =~ /#{e1}.*#{e2}/m)
        result = true
    end
    expect(result).to be_truthy
end

When /^I have opted to see movies rated: "(.*?)"$/ do |rating_list|

    # Uncheck all checkboxes
    all('input[type=checkbox]').each do |checkbox|
        if checkbox.checked? then 
            checkbox.click
        end
    end
  
    # check the ones we want
    rating_list.split(', ').each do |x|
       check "ratings_#{x}"
    end
    
    click_button 'Refresh'


  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  
end

Then /^I should see only movies rated: "(.*?)"$/ do |rating_list|
   
   rating_list.split(", ").each do |x| 
        assert true unless page.body =~ /#{x}/m
   end

end

Then /^I should see all of the movies$/ do
    rows = page.all('#movies tr').size - 1  
    result = false
    if (rows == Movie.count())
        result = true
    end
    expect(result).to be_truthy
end




## HELPER FUNCTIONS
When /^(?:|I )press "([^"]*)"$/ do |button|
  click_button(button)
end

When /^(?:|I )follow "([^"]*)"$/ do |link|
  click_link(link)
end

Then /^(?:|I )should see \/([^\/]*)\/$/ do |regexp|
  regexp = Regexp.new(regexp)

  if page.respond_to? :should
    page.should have_xpath('//*', :text => regexp)
  else
    assert page.has_xpath?('//*', :text => regexp)
  end
end