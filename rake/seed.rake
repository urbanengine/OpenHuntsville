################################## OVERVIEW ##################################
#
#
##############################################################################

require 'csv'

EXPERT_FULL_NAME           = 0
EXPERT_FIRST_NAME          = 1
EXPERT_LAST_NAME           = 2
EXPERT_FIRST_SPECIALTY     = 3
EXPERT_SECOND_SPECIALTY    = 4
EXPERT_THIRD_SPECIALTY     = 5
EXPERT_COMPANY             = 6
EXPERT_TWITTER             = 7
EXPERT_LINKEDIN            = 8
EXPERT_URL                 = 9
EXPERT_OTHER_INFO          = 10
EXPERT_IMAGE_URL           = 11

CSV_PATH = File.dirname(__FILE__) + '/seed_experts.csv'

namespace :seed do

  desc "seed the database with MVP data"
  task :experts => ['pakyow:stage'] do
    #     Seed facilities and resources for HISL.
    CSV.foreach(CSV_PATH, { :headers => true, :skip_blanks => true }) do |row|
        people = People.new

        people.first_name = row[EXPERT_FIRST_NAME]
        people.last_name = row[EXPERT_LAST_NAME]
        people.password = "test"
        people.password_confirmation = "test"
        cat_string = row[EXPERT_FIRST_SPECIALTY]
        unless row[EXPERT_SECOND_SPECIALTY].nil?
            if row[EXPERT_SECOND_SPECIALTY].length > 0
                cat_string.concat(",")
                cat_string.concat(row[EXPERT_SECOND_SPECIALTY])
            end
        end
        unless row[EXPERT_THIRD_SPECIALTY].nil?
            if row[EXPERT_THIRD_SPECIALTY].length > 0
                cat_string.concat(",")
                cat_string.concat(row[EXPERT_THIRD_SPECIALTY])
            end
        end
        people.categories_string = cat_string
        people.company = row[EXPERT_COMPANY]
        people.twitter = row[EXPERT_TWITTER]
        people.linkedin = row[EXPERT_LINKEDIN]
        people.url = row[EXPERT_URL]
        people.other_info = row[EXPERT_OTHER_INFO]
        # people.image_url = row[EXPERT_IMAGE_URL]
        if people.email.nil? || people.email.length == 0
            people.email = "openhsv+" + people.first_name + people.last_name + "@gmail.com"
        end
        people.save
        print "."
        $stdout.flush
    end
    puts "***"
  end

  task :admins => ['pakyow:stage'] do
    
    # Bryan Powell
    people = People.new
    people.first_name = "Bryan"
    people.last_name = "Powell"
    people.password = "test"
    people.password_confirmation = "test"
    people.categories_string = "Software"
    people.twitter = "bryanp"
    people.linkedin = "bryancp"
    people.url = "http://openhuntsvillestatic.dev/people/#"
    people.image_url = "/img/bryan-powell.jpg"
    people.email = "bryan@metabahn.com"
    people.bio = "Hybrid Developer. Building a better web with @pakyow. Founded @metabahn."
    people.custom_url = "bryan-powell"
    people.admin = true
    people.approved = true
    people.save
    
    # Chris Beaman
    people = People.new
    people.first_name = "Chris"
    people.last_name = "Beaman"
    people.password = "test"
    people.password_confirmation = "test"
    people.categories_string = "Software,Design,Marketing"
    people.twitter = "chrisbeaman"
    people.linkedin = "chrisbeaman"
    people.url = "http://www.chrisbeaman.com/"
    people.image_url = "/img/Chris-Beaman.jpg"
    people.email = "chris.beaman@gmail.com"
    people.bio = "Product Manager for Union for Gamers MCN at Curse, co-founder of Grapevine Logic, UX/UI/CSS designer/developer living in Huntsville, AL."
    people.custom_url = "chris-beaman"
    people.admin = true
    people.approved = true
    people.save
    
    # Tarra Anzalone
    people = People.new
    people.first_name = "Tarra"
    people.last_name = "Anzalone"
    people.password = "test"
    people.password_confirmation = "test"
    people.categories_string = "Design,Marketing"
    people.twitter = "moderntarra"
    people.linkedin = "moderntarra"
    people.url = "http://modernandsmart.com/"
    people.image_url = "/img/Tarra-Anzalone.jpg"
    people.email = "tarra@modernandsmart.com"
    people.bio = "Brand strategist | marketeur | designer | startup upstart | founder @modernandsmart | UX"
    people.custom_url = "tarra-anzalone"
    people.admin = true
    people.approved = true
    people.save
    
    # Joe MacKenzie
    people = People.new
    people.first_name = "Joe"
    people.last_name = "MacKenzie"
    people.password = "test"
    people.password_confirmation = "test"
    people.categories_string = "Design,Software,Marketing"
    people.twitter = "Mackcompany"
    people.linkedin = "joemackenzie"
    people.url = "http://www.letsfindouthow.com"
    people.image_url = "/img/joe-mackenzie.jpg"
    people.email = "joe@letsfindouthow.com"
    people.bio = "Problem solving through design, deep thoughts, and red bull"
    people.custom_url = "joe-mackenzie"
    people.admin = true
    people.approved = true
    people.save
    
    # Kyle Newman
    people = People.new
    people.first_name = "Kyle"
    people.last_name = "Newman"
    people.password = "test"
    people.password_confirmation = "test"
    people.categories_string = "Software,Design"
    people.twitter = "skylenewman"
    people.linkedin = "skylenewman"
    people.url = "http://www.skylenewman.com"
    people.image_url = "/img/Kyle-Newman.jpg"
    people.email = "kyle@skylenewman.com"
    people.bio = "Software and Website Designer and Developer"
    people.custom_url = "kyle-newman"
    people.admin = true
    people.approved = true
    people.save
    
    # Andrew Hall
    people = People.new
    people.first_name = "Andrew"
    people.last_name = "Hall"
    people.password = "test"
    people.password_confirmation = "test"
    people.categories_string = "Design,Photography"
    people.twitter = "refractingdrew"
    people.linkedin = "heywardandrewhall"
    people.url = "http://www.refractingideas.com"
    people.image_url = "/img/Andrew-Hall.jpg"
    people.email = "andrew@refractingideas.com"
    people.bio = "#Strategist, #Marketer, #Photographer, #Gamer, #Kayaker. I've made, sold, trained, researched, designed, photographed, documented, traveled, and consulted."
    people.custom_url = "andrew-hall"
    people.admin = true
    people.approved = true
    people.save

  end
end
