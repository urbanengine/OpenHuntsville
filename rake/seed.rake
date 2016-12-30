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
CATS_PATH = File.dirname(__FILE__) + '/cats.csv'

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


  desc "seed the database with categories"
  task :categories => ['pakyow:stage'] do
    r = 1
    total = 16
    CSV.foreach(CATS_PATH, { :headers => false, :skip_blanks => true }) do |row|
        if r == 1
            row.each_with_index { |item,index|
                has_em = Category.where("category = ?",item).all
                if has_em.nil? || has_em.length == 0
                    category = Category.new
                    category.category = item
                    down = item.downcase
                    with_dashes = down.gsub(/[^0-9a-z]/i, '-')
                    category.slug = with_dashes
                    category.url = "/categories/" + with_dashes
                    category.save
                    print "< " + r.to_s + " :: " + (index+1).to_s + " >\n"
                    $stdout.flush
                end
            }
        else
            row.each_with_index { |item,index|
                unless item.nil?

                    has_em = Category.where("category = ?",item).all
                    if has_em.nil? || has_em.length == 0
                        category = Category.new
                        category.category = item
                        category.parent_id = index + 1
                        down = item.downcase
                        with_dashes = down.gsub(/[^0-9a-z]/i, '-')
                        category.slug = with_dashes
                        category.url = Category[category.parent_id].url + "/" + with_dashes
                        category.save
                        print "< " + r.to_s + " :: " + (index+1).to_s + " >\n"
                        $stdout.flush
                    end
                end
            }
        end

        r += 1
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

    # David Jones
    people = People.new
    people.first_name = "David"
    people.last_name = "Jones"
    people.password = "test"
    people.password_confirmation = "test"
    people.linkedin = "david-h-jones"
    people.url = "http://www.refractingideas.com"
    people.image_url = "/img/David-Jones.jpg"
    people.email = "david@newleafdigital.org"
    people.bio = "Software and Website Designer and Developer"
    people.custom_url = "david-jones"
    people.admin = true
    people.approved = true
    people.save
  end


  task :sillycats => ['pakyow:stage'] do

    cat = Category.new
    cat.category = "Bacon"
    cat.description = "Bacon ipsum dolor amet salami porchetta cupim andouille corned beef ball tip boudin."
    cat.save

    cat = Category.new
    cat.category = "Turkey"
    cat.description = "Turkey salami meatloaf, tri-tip landjaeger pork chop ball tip turducken bresaola leberkas brisket boudin sausage pork loin drumstick."
    cat.parent_id = 1
    cat.save

    cat = Category.new
    cat.category = "Biltong"
    cat.description = "Biltong turducken ham hock spare ribs chuck t-bone. "
    cat.parent_id = 1
    cat.save

    cat = Category.new
    cat.category = "Strip steak"
    cat.description = "Strip steak meatloaf boudin, shankle cow filet mignon landjaeger bacon shoulder frankfurter ground round ball tip beef pastrami."
    cat.save

  end

  task :groups => ['pakyow:stage'] do
    group = Group.new
    group.name = "New Leaf Digital"
    group.description = "The parent 501c(3) organization for CoWorking Night, 32/10, and Huntsville Founders."
    group.categories_string = "Engineering"
    group.approved = true
    group.save

    group = Group.new
    group.name = "CoWorking Night"
    group.parent_id = Group.where("name = 'New Leaf Digital'").first.id
    group.categories_string = "Engineering"
    group.approved = true
    group.save

    group = Group.new
    group.name = "32/10"
    group.parent_id = Group.where("name = 'New Leaf Digital'").first.id
    group.categories_string = "Engineering"
    group.approved = true
    group.save

    group = Group.new
    group.name = "Designer's Corner"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    group.categories_string = "Art and Design"
    group.approved = true
    group.save

    group = Group.new
    group.name = "4 Hours To Product"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    group.approved = true
    group.save

    group = Group.new
    group.name = "Dumb not approved group"
    group.description = "Dont allow stupid groups that aren't approved"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    group.save
  end

  task :group_admins => ['pakyow:stage'] do
    admins = People.where("admin = true").all
    groups = Group.all
    admins.each { |person|
      groups.each { |group|
        person.add_group(group)
      }
    }
  end

  task :events => ['pakyow:stage'] do
    cwn = Group.where("name = 'CoWorking Night'").first
    unless cwn.nil?
      event = Event.new
      event.name = "CoWorking Night #99"
      event.description = "The 99th weekly CoWorking Night"
      event.group_id = cwn.id
      event.save

      event = Event.new
      event.name = "CoWorking Night #100"
      event.description = "The 100th weekly CoWorking Night"
      event.group_id = cwn.id
      event.save

      event = Event.new
      event.name = "CoWorking Night #101"
      event.description = "The 101th weekly CoWorking Night"
      event.group_id = cwn.id
      event.save

      event = Event.new
      event.name = "CoWorking Night #102"
      event.description = "The 102th weekly CoWorking Night"
      event.group_id = cwn.id
      event.save
    end

    dc = Group.where("name = 'Designer''s Corner'").first
    unless dc.nil?
      event = Event.new
      event.name = "Designer's Corner #13"
      event.description = "The 13th meeting of Designer's Corner"
      event.group_id = dc.id
      event.parent_id = Event.where("name = 'CoWorking Night #100'").first.id
      event.save
    end
  end

  task :venues => ['pakyow:stage'] do
    venue = Venue.new
    venue.name = "AL.com Building"
    venue.save

    venue = Venue.new
    venue.name = "Space Station Area"
    venue.save

    venue = Venue.new
    venue.name = "2nd Floor Open Area"
    venue.save

    venue = Venue.new
    venue.name = "Orion Open Area"
    venue.save

    venue = Venue.new
    venue.name = "Apollo Room"
    venue.save

    venue = Venue.new
    venue.name = "The Vault"
    venue.save

    venue = Venue.new
    venue.name = "John Hunt Room"
    venue.save

    venue = Venue.new
    venue.name = "Redstone Room"
    venue.save

    venue = Venue.new
    venue.name = "Saturn V Room"
    venue.save

    venue = Venue.new
    venue.name = "Limestone Room"
    venue.save

    venue = Venue.new
    venue.name = "Madison Room"
    venue.save
  end
end
