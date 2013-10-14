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
   assert result
 end

 When /^I have visited the Details about "(.*?)" page$/ do |title|
   visit movies_path
   click_on "More about #{title}"
 end

Then /^(?:|I )should see "([^"]*)"$/ do |text|
  if page.respond_to? :should
    page.should have_content(text)
  else
    assert page.has_content?(text)
  end
end

 When /^I have edited the movie "(.*?)" to change the rating to "(.*?)"$/ do |movie, rating|
  click_on "Edit"
  select rating, :from => 'Rating'
  click_button 'Update Movie Info'
 end


# New step definitions to be completed for HW3. 
# Note that you may need to add additional step definitions beyond these


# Add a declarative step here for populating the DB with movies.

Given /the following movies have been added to RottenPotatoes:/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
  #flunk "Unimplemented"
end

When /^I have opted to see movies rated: "(.*?)"$/ do |arg1|
  opts=arg1.upcase.gsub(/[\s]/, '').split(',') 
  Movie.all_ratings.each do |rating|
    if opts.include? (rating)
      check "ratings_#{rating}"
    else
      uncheck "ratings_#{rating}"
    end
  end
  click_button 'Refresh'
  # HINT: use String#split to split up the rating_list, then
  # iterate over the ratings and check/uncheck the ratings
  # using the appropriate Capybara command(s)
  #flunk "Unimplemented"
end

Then /^I should see only movies rated "(.*?)"$/ do |arg1|
  opts=arg1.upcase.gsub(/[\s]/, '').split(',')
  
  #get the content of table id = 'movies'
  t_content=page.find_by_id('movies').all('td')
  #the number of attriburs each row has
  n_attr=t_content.length/page.find_by_id('movies').find('tbody').all('tr').length
  
  if !t_content 
    flunk "Movies table NOT FOUND!Please define it with id='movies'."
  else
    #check the ratings in the movie list
    i=1
    while i<=t_content.length
      if !opts.include?(t_content[i].text)
        flunk "Unexpected rating #{t_content[i].text} Found!"
      else
        i+=n_attr#get the index of next rating
      end
    end
  end
end

Then /^I should see all of the movies$/ do
  n_movies_on_page=page.find_by_id('movies').find('tbody').all('tr').length
  n_movies_in_db=Movie.count
  if n_movies_in_db!=n_movies_on_page
    flunk "Some movies are missed!"
  end
end



