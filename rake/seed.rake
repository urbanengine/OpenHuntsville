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

  desc "seed the database using data for development"
  task :dev => ['pakyow:stage'] do

    puts "Starting the seed:categories task"
    Rake::Task["seed:categories"].invoke

    puts "Starting the seed:admins task"
    Rake::Task["seed:admins"].invoke

    # puts "Starting the seed:experts task"
    # Rake::Task["seed:experts"].invoke

    puts "Starting the seed:groups task"
    Rake::Task["seed:groups"].invoke

    puts "Starting the seed:group_admins task"
    Rake::Task["seed:group_admins"].invoke

    puts "Starting the seed:venues task"
    Rake::Task["seed:venues"].invoke

    # puts "Starting the seed:events task"
    # Rake::Task["seed:events"].invoke
  end

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

    # Tyler Hughes
    people = People.new
    people.first_name = "Tyler"
    people.last_name = "Hughes"
    people.password = "test"
    people.password_confirmation = "test"
    people.linkedin = "thughes01"
    people.url = "http://tylerhughes.info/"
    people.image_url = "/img/tyler-hughes.jpg"
    people.email = "tyler@newleafdigital.org"
    people.bio = "Software and Website Designer and Developer"
    people.custom_url = "tyler"
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
    #group.categories_string = "Multidisciplinary"
    #group.image_url = ""
    group.approved = true
    group.save

    group = Group.new
    group.name = "CoWorking Night"
    group.parent_id = Group.where("name = 'New Leaf Digital'").first.id
    #group.categories_string = "Multidisciplinary"
    #group.image_url = ""
    group.approved = true
    group.save

    group = Group.new
    group.name = "32/10"
    group.parent_id = Group.where("name = 'New Leaf Digital'").first.id
    #group.categories_string = "Multidisciplinary"
    #group.image_url = ""
    group.approved = true
    group.save

    group = Group.new
    group.name = "4 Hours To Product"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "Multidisciplinary"
    #group.image_url = "/img/groups/4HoursToProduct.jpg"
    group.approved = true
    group.save

    group = Group.new
    group.name = "Adulting 101"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "Multidisciplinary"
    #group.image_url = "/img/groups/Adulting101.jpg"
    group.approved = true
    group.save

    group = Group.new
    group.name = "After Hours Game Dev"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "Game Development"
    #group.image_url = "/img/groups/AfterHoursGameDev.jpg"
    group.approved = true
    group.save

    group = Group.new
    group.name = "AngularJS"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "Software"
    #group.image_url = ""
    group.approved = true
    group.save

    group = Group.new
    group.name = "Babes Who Blog"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "Writing"
    #group.image_url = "/img/groups/BabesWhoBlog.jpg"
    group.approved = true
    group.save

    group = Group.new
    group.name = "Code the South"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "Software"
    #group.image_url = "/img/groups/CodeTheSouth.jpg"
    group.approved = true
    group.save

    group = Group.new
    group.name = "Coders GSD"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "Software"
    #group.image_url = "/img/groups/CodersGSD.jpg"
    group.approved = true
    group.save

    group = Group.new
    group.name = "Designer's Corner"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "Design"
    #group.image_url = "/img/groups/DesignersCorner.jpg"
    group.approved = true
    group.save

    group = Group.new
    group.name = "Hackster.io Hardware Hacking"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "Hardware"
    #group.image_url = "/img/groups/Hackster.jpg"
    group.approved = true
    group.save

    group = Group.new
    group.name = "Keyframe: Motion Graphics & Animation"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "Animation"
    #group.image_url = "/img/groups/Keyframe.jpg"
    group.approved = true
    group.save

    group = Group.new
    group.name = "Leadership Lounge"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "Leadership"
    #group.image_url = "/img/groups/LeadershipLounge.jpg"
    group.approved = true
    group.save

    group = Group.new
    group.name = "Lean In Circle for Women"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "Leadership"
    #group.image_url = "/img/groups/LeanIn.jpg"
    group.approved = true
    group.save

    group = Group.new
    group.name = "Mathletes of Huntsville"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "Mathematics"
    #group.image_url = "/img/groups/Mathletes.jpg"
    group.approved = true
    group.save

    group = Group.new
    group.name = "Mindfulness at Work"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "Meditation"
    #group.image_url = "/img/groups/MindfulnessAtWork.jpg"
    group.approved = true
    group.save

    group = Group.new
    group.name = "On Target Marketing"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "Marketing"
    #group.image_url = "/img/groups/OnTargetMarketing.jpg"
    group.approved = true
    group.save

    group = Group.new
    group.name = "OverEngineered"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "Engineering"
    #group.image_url = "/img/groups/OverEngineered.jpg"
    group.approved = true
    group.save

    group = Group.new
    group.name = "Photo-Synthesis"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "Photography"
    #group.image_url = "/img/groups/Photo-Synthesis.jpg"
    group.approved = true
    group.save

    group = Group.new
    group.name = "ReactHSV"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "Software"
    #group.image_url = "/img/groups/ReactHSV.jpg"
    group.approved = true
    group.save

    group = Group.new
    group.name = "Responsive Web Design"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "Software"
    #group.image_url = "/img/groups/ResponsiveWebDesign.jpg"
    group.approved = true
    group.save

    group = Group.new
    group.name = "Sales Funnel"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "Sales"
    #group.image_url = ""
    group.approved = true
    group.save

    group = Group.new
    group.name = "Social Tribe"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "Marketing"
    #group.image_url = "/img/groups/TheSocialTribe.jpg"
    group.approved = true
    group.save

    group = Group.new
    group.name = "Startup Book Club"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "Startups"
    #group.image_url = "/img/groups/StartupBookClub.jpg"
    group.approved = true
    group.save

    group = Group.new
    group.name = "Untitled Film Group"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "Film"
    #group.image_url = "/img/groups/UntitledFilmGroup.jpg"
    group.approved = true
    group.save

    group = Group.new
    group.name = "UXPA Tennessee Valley"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "User Experience"
    #group.image_url = "/img/groups/UXPA.png"
    group.approved = true
    group.save

    group = Group.new
    group.name = "Women Who Code"
    group.parent_id = Group.where("name = 'CoWorking Night'").first.id
    #group.categories_string = "Software"
    #group.image_url = "/img/groups/WomenWhoCode.png"
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
    venue.name = "Real Estate Row"
    venue.save

    venue = Venue.new
    venue.name = "Apollo Row"
    venue.save

    venue = Venue.new
    venue.name = "Main Row"
    venue.save

    venue = Venue.new
    venue.name = "Saturn Row"
    venue.save

    venue = Venue.new
    venue.name = "Milky Way Row"
    venue.save

    venue = Venue.new
    venue.name = "Orion Row"
    venue.save

    venue = Venue.new
    venue.name = "Space Station"
    venue.save

  end

  desc "seed the database with event data from a CSV file"
  task :eventsFromCSV => ['pakyow:stage'] do
    date_format = "%m/%d/%Y %H:%M:%S"
    feb_22 = "2/22/2017 18:00:00"
    cwn_start_datetime = DateTime.strptime(feb_22, date_format).utc
    cwn_group_id = Group.where("name = ?", "CoWorking Night").first.id
    cwn_venue_id = Venue.where("name = ?", "Real Estate Row").first.id

    for cwn_instance_number in 94..99
      event = Event.new
      event.name = "CoWorking Night #" + cwn_instance_number.to_s
      event.description = "The " + cwn_instance_number.to_s + "th CoWorking Night"
      event.created_at = DateTime.now
      event.updated_at = DateTime.now
      event.start_datetime = cwn_start_datetime
      cwn_start_datetime = cwn_start_datetime + 7.days
      event.duration = 4
      event.instance_number = cwn_instance_number
      event.group_id = cwn_group_id
      event.venue_id = cwn_venue_id

      event.save
    end
    CSV.foreach(EVENTS_PATH, { :headers => true, :skip_blanks => true }) do |row|
        puts row
        event = Event.new
        if row["Start"].nil?
          next
        else
          start_at_cst = DateTime.strptime(row["Start"], date_format)
          if start_at_cst < DateTime.now
            next
          end
        end
        event.start_datetime = start_at_cst.utc

        # 12/5/2016 9:55:54
        if row["Timestamp"].nil?
          created_at_cst = DateTime.now
        else
          created_at_cst = DateTime.strptime(row["Timestamp"], date_format)
        end
        event.created_at = created_at_cst.utc

        event.name = row["Event Title"]
        event.description = row["Event Description"]

        group = Group.where("name = ?", row["Group Name"]).first

        if group.nil?
          newGroup = Group.new
          newGroup.name = row["Group Name"]
          newGroup.description = row["Group Name"]
          newGroup.parent_id = Group.where("name = 'CoWorking Night'").first.id
          newGroup.save

          event.group_id = newGroup.id
        else
          event.group_id = group.id
        end

        venue = Venue.where("name = ?", row["Room Requested"]).first
        event.venue_id = venue.id

        case row["Numerical Duration"]
          when "1:00:00"
            event.duration = 1
          when "2:00:00"
            event.duration = 2
          when "3:00:00"
            event.duration = 3
        end

        event.approved = row["Approved"]
        if event.approved

          previous_event = Event.where("approved = true AND group_id = ? AND start_datetime < ?", event.group_id, event.start_datetime).order(:start_datetime).last
          instance_number = 1
          unless previous_event.nil?
            instance_number = previous_event.instance_number + 1
          end

          event.instance_number = instance_number
        end

        cwn_events = Event.where("approved = true AND group_id = ?", cwn_group_id).all
        cwn_events.each { |cwn_event|
          hours_between_old_and_new_date = (((cwn_event.start_datetime - event.start_datetime)*24).to_i).abs
          if hours_between_old_and_new_date < 24
            event.parent_id = cwn_event.id
            break
          end
        }

        event.save
    end
  end
end
