require 'digest/md5'
require 'nokogiri'
require 'rack/utils'

module Pakyow::Helpers
  def handle_errors(view)
    if @errors
      render_errors(view, @errors)
    else
      view.scope(:errors).remove
    end
  end

  def render_errors(view, errors)
    unless errors.is_a?(Array)
      errors = pretty_errors(errors.full_messages)
    end

    view.scope(:errors).with do
      prop(:message).repeat(errors) { |context, message|
        context.text = message
      }
    end
  end

  def pretty_errors(errors)
    Array(errors).map { |error|
      error.gsub('_', ' ').capitalize
    }
  end

  def getVal(bindable,pos)
    log_debug("/app/lib/helpers.rb :: getVal :: ", bindable.to_s)
    log_debug("/app/lib/helpers.rb :: getVal :: ", pos.to_s)
    retVal = Array.new(3)

    unless bindable.nil?
      if bindable.include? ","
        retVal = bindable.split(",")
      elsif bindable.include? "/"
        retVal = bindable.split("/")
      else
        retVal[0] = bindable
        retVal[1] = " "
        retVal[2] = " "
      end
    end
    retVal[pos.to_int]
  end

  def log_level()
    level = 0
    if ENV['LOG_LEVEL'] == "TRACE"
      level = 1
    end
    if ENV['LOG_LEVEL'] == "DEBUG"
      level = 2
    end
    if ENV['LOG_LEVEL'] == "INFO"
      level = 3
    end
    if ENV['LOG_LEVEL'] == "WARN"
      level = 4
    end
    if ENV['LOG_LEVEL'] == "ERROR"
      level = 5
    end
    if ENV['LOG_LEVEL'] == "FATAL"
      level = 6
    end
    level
  end

  def log_fatal(log)
    if log_level > 5
      puts log
    end
  end

  def log_error(log)
    if log_level > 4
      puts log
    end
  end

  def log_warn(log)
    if log_level > 3
      puts log
    end
  end

  def log_info(log)
    if log_level > 2
      puts log
    end
  end

  def log_debug(*args)
    if log_level > 1
      if args.size == 1
        puts args[0]
      elsif args.size == 2
        unless args[1].nil?
          puts args[0] + args[1]
        end
      end
    end
  end

  def log_trace(log)
    if log_level > 0
      puts log
    end
  end

  def get_people_from_people_id(id)
    people = Array.new
    unless id.nil?
      people = People.where("lower(custom_url) = ?",id.downcase).all
    end
  end

  def get_first_person_from_people_id(id)
    person = nil
    people = get_people_from_people_id(id)
    unless people.nil? || people[0].nil?
      person = people[0]
    end
    person
  end

  def unique_url(id,url)
    retval = true
    id = id.to_s
    url = url.to_s
    people = People.where("custom_url = ?",url).all
    if people.size > 1
      retval = false
    else
      unless people.nil? || people[0].nil?
        if people[0].id.to_s == id
          retval = false
        end
      end
    end
    retval
  end

  def is_good_url?(url)
      response = HTTParty.get(url)
      result = JSON.parse(response.body)
      #If API response successful create record; else output error to view
      return result['status'] == 200
  end

  def find_image_url(email)

  # # def get_gravatar(email)
  #   nospace = email.gsub(/ /i, '')
  #   down = nospace.downcase
  #   digest = Digest::MD5.hexdigest(down)
  #   # &d=404 will return 404 if no image associated
  #   gravatar = "http://www.gravatar.com/avatar/" + digest + "?s=160&d=404"
  #   response = HTTParty.get(gravatar)
  #   unless response.start_with?("404")
  #     url = gravatar
  #   else
  #     api_key = ENV['FULLCONTACT_API_KEY']

  #     #Building components of the API URL to Full Contact
  #     base_url = "https://api.fullcontact.com/v2/person.json?email="
  #     conj_url = "&apiKey="
  #     # apiKey = ENV['FULL_CONTACT_API_KEY']
  #     # You can get a trial Full Contact API key from:
  #     # https://www.fullcontact.com/developer/try-fullcontact/

  #     url = [base_url, email, conj_url, api_key].join

  #     #Calling API to get JSON response for parsing
  #     response = HTTParty.get(url)
  #     result = JSON.parse(response.body)
  #     return_url = "/img/profile-backup.png"
  #     #If API response successful create record; else output error to view
  #     if result['status'] == 200 then
  #       fullcontact_url = result['photos'][0]['url']
  #       photo = HTTParty.get(url)
  #       unless photo.to_s.start_with?("404")
  #         return_url = fullcontact_url
  #       else
  #         # pp "Unable to find photo for " + email
  #       end
  #     else
  #       # pp "Unable to find photo for " + email
  #     end
  #   end
  #   return_url
    nil
  end # def find_image_url(email)

  def get_css_classes_for_category(category_id)
    category = Category[category_id]
    paths = category.url.split("/")
    classes = ""
    paths.each_with_index { |item,index|
      classes = classes + " "
      unless index < 2
        if index == 2
          classes = item
        else
          paths.each_with_index { |inner_item, inner_index|
            unless inner_index < 2 || inner_index >= index
              classes = classes + " " + inner_item
              for i in 0..inner_index-1
                 classes = classes + "-"
              end
            end
            if index == inner_index
              classes = classes + inner_item
            end
          }
        end # if index == 2
      end # unless index < 2
    }
    classes
  end # def get_css_classes_for_category(category)

  def get_css_classes_for_edit_user_btn()

  end # def get_css_classes_for_edit_user_btn()

  ### ----------------------------
  ### EMAIL
  ### ----------------------------

  def send_email_template(person, email_partial, options = {})
    body = ''
    subject = ''

    to_email = person.email

    if options[:from_email].nil?
      from_email = 'donotreply@openhsv.com'
    else
      from_email = options[:from_email]
    end

    case email_partial
    when :account_suspension
      presenter.view = store.view('mail/account_suspension')
      view.scope(:people).bind(person)
      subject = 'Your #openHSV account has been suspended'
    when :account_approval
      presenter.view = store.view('mail/account_approval')
      view.scope(:people).bind(person)
      subject = 'Congratulations! Your #openHSV account has been approved!'
    when :account_creation
      presenter.view = store.view('mail/account_creation')
      view.scope(:people).bind(person)
      subject = "Your #openHSV account is awaiting approval"
    end

    send_email(person, from_email, view.to_html, subject)
  end # send_email_template(person, email_partial, options = {})

  def send_email(person, from_email, body, subject)
    unless ENV['RACK_ENV'] == 'development'
      recipient = "#{person.first_name} #{person.last_name} <#{person.email}>"

      # First, instantiate the Mailgun Client with your API key
      mg_client = Mailgun::Client.new ENV['MAILGUN_PRIVATE']
      # recipient = YAML.load(%Q(---\n"#{recipient}"\n))
      # subject = YAML.load(%Q(---\n"#{subject}"\n))
      # body = YAML.load(%Q(---\n"#{body}"\n))
      # text = <%=h Nokogiri::HTML(body).text %>
      # body = Rack::Utils.escape_html(body)
      # Define your message parameters
      message_params =  { from: 'postmaster@sandboxa148f93a5c5f4813a81365d1b873ee8f.mailgun.org',
                          to:   recipient,
                          subject: subject,
                          text: Nokogiri::HTML(body).text,
                          html: body
                          # subject: subject,
                          # html: body
                          # text: text
                        }

      # Send your message through the client
      mg_client.send_message 'sandboxa148f93a5c5f4813a81365d1b873ee8f.mailgun.org', message_params
    end # unless ENV['RACK_ENV'] == 'development'
  end # send_email(person, from_email, body, subject)

  def email_us(subject, body)
    unless ENV['RACK_ENV'] == 'development'
      recipient = "The Awesome Team <openhsv@gmail.com>"

      # First, instantiate the Mailgun Client with your API key
      mg_client = Mailgun::Client.new ENV['MAILGUN_PRIVATE']

      # Define your message parameters
      message_params =  { from: 'postmaster@sandboxa148f93a5c5f4813a81365d1b873ee8f.mailgun.org',
                          to:   recipient,
                          subject: subject,
                          html: body,
                          text: Nokogiri::HTML(body).text
                        }

      # Send your message through the client
      mg_client.send_message 'sandboxa148f93a5c5f4813a81365d1b873ee8f.mailgun.org', message_params
    end # unless ENV['RACK_ENV'] == 'development'
  end # email_us(user, from_email, body, subject)

  def create_session(parms)
    @session = Session.new(parms)
    pp @session
    returnValue = false
    if people = People.auth(@session)
      cookies[:people] = people.id
      # cookies[:people] = hash_and_salt_str(people.id)
      unless people.id.nil?
        returnValue = true
      end
    end
    returnValue
  end # create_session(parms)

  def printme(val)
    printval = ""
    unless val.nil?
      printval = val.to_s
    end
    printval
  end #print_me(val)

  def hash_and_salt_str(str)
    salt = ENV['salt']
    return BCrypt::Password.create(salt + str)
  end

  def get_nested_category_id_and_category_name()
    opts = [[]]
    Category.all.each do |category|
      if category.parent_id.nil?
        opts << [category.id, category.category]
        Category.where("parent_id = ?",category.id).each { |item|
          opts << [item.id, category.category + " :: " + item.category]
        }
      end
    end
    opts
  end

  def get_groups_for_logged_in_person()
    opts = [[]]
    people = People[cookies[:people]]
    people.groups().each do |group|
      if group.approved
        opts << [group.id, group.name]
      end
    end
    opts
  end

  def get_venues()
    opts = [[]]
    Venue.all.each do |venue|
      opts << [venue.id, venue.name]
    end
    opts
  end

  def get_people_to_add_as_group_admin(group_id)
    opts = [[]]
    group = Group.where("id = ?", group_id).first
    group_admins = group.people()
    People.order(:first_name).each do |people|
      if group_admins.all? { |group_admin| group_admin.id != people.id }
        person_has_first_name = people.first_name.nil? == false && people.first_name.empty? == false
        person_has_last_name = people.last_name.nil? == false && people.last_name.empty? == false
        if person_has_first_name && person_has_last_name
          person_to_add_string = people.first_name + " " + people.last_name
        else
          person_to_add_string = people.email
        end
        opts << [people.id, person_to_add_string]
      end
    end
    opts
  end

  def resize_and_crop(image, size)
    if image.width < image.height
      remove = ((image.height - image.width)/2).round
      image.shave("0x#{remove}")
    elsif image.width > image.height
      remove = ((image.width - image.height)/2).round
      image.shave("#{remove}x0")
    end
    image.resize("#{size}x#{size}")
    return image
  end

  def slug_contains_invalid(string)
    retval = false
    if string.include? " "
      retval = true
    elsif string.include? "http"
      retval = true
    elsif string.include? ":"
      retval = true
    elsif string.include? "/"
      retval = true
    elsif string.include? "\\"
      retval = true
    end
  end

  def logged_in_user_is_group_admin_or_site_admin()
    people = People[cookies[:people]]
    if people.nil?
      return false
    end
    if people.admin
      return true
    end
    if people.groups().length == 0
      return false
    end
    return true
  end

  def logged_in_user_is_manager_of_event(event)
    people = People[cookies[:people]]
    people.groups().each{ |group|
      logged_in_users_events = Event.where("group_id = ?", group.id).all
      logged_in_users_events.each { |logged_in_user_event|
        if logged_in_user_event.id == event.id
          return true
        end
      }
    }
    return false
  end

  def logged_in_user_is_manager_of_group(group)
    people = People[cookies[:people]]
    if people.nil?
      return false
    end
    return people.groups().any?{ |persons_group| persons_group.id == group.id }
  end

  def update_group_admins_for_person(person)
    if person.admin == true
      groups_to_admin = Group.all - person.groups
      groups_to_admin.each { |group|
        group.add_person(person)
      }
    end
  end

  #traverse down the tree returning all the events on the way
  def get_child_events_for_event(event)
    all_events = []
    unless event.nil? || event.id.nil?
      child_events = Event.where("approved = true AND parent_id = ? AND archived = ?", event.id, false).all
      #while child_events.length != 0
      #  child_event = child_events.shift
      #  child_events += Event.where("approved = true AND parent_id = ?", child_event.id).all
      #  all_events << child_event
      #end
      child_events
    end
  end

  def readjust_event_instance_number_for_group(start_datetime, group_id)
    #an event has been created, edited, or deleted. Therefore we adjust all the future events
    previous_event = Event.where("approved = true AND group_id = ? AND start_datetime < ?", group_id, start_datetime).order(:start_datetime).last
    unless previous_event.nil?
      previous_event_instance_number = previous_event.instance_number
      future_events = Event.where("approved = true AND group_id = ? AND start_datetime > ?", group_id, previous_event.start_datetime).order(:start_datetime).all
    else
      previous_event_instance_number = 1
      future_events = Event.where("approved = true AND group_id = ? AND start_datetime > ?", group_id, start_datetime).order(:start_datetime).all
    end
    future_events.each { |event|
      previous_event_instance_number = previous_event_instance_number + 1
      event.instance_number = previous_event_instance_number
      event.save
    }
  end

  def get_events_for_group_id(group_id)
    opts = [[]]
    unless group_id.nil?
      nextThursday = Date.parse('Thursday')
      delta = nextThursday > Date.today ? 0 : 7
      nextThursday = nextThursday + delta

      people = People[cookies[:people]]
      if people.nil? == false && people.admin
        time_limit = DateTime.now.utc
      else      
        time_limit = if (nextThursday - Date.today) < 4 then nextThursday else DateTime.now.utc end
      end

      group_events = Event.where("group_id = ? AND start_datetime > ?", group_id, time_limit).all
      parent_group = Group.where("id = ?", group_id).first
      unless parent_group.parent_id.nil?
        group_events.concat(Event.where("group_id = ? AND start_datetime > ?", parent_group.parent_id, time_limit).all)
      end
      group_events.each { |event|
        opts << [event.id, event.name + "   (" + event.start_datetime.in_time_zone("Central Time (US & Canada)").strftime('%m/%d/%Y') + ")"]
      }
    end
    opts
  end

  def get_events_for_coworkingnight()
    opts = [[]]
    cwn = Group.where("name = 'CoWorking Night'").first
    unless cwn.nil? || cwn.id.nil?
      nextThursday = Date.parse('Thursday')
      delta = nextThursday > Date.today ? 0 : 7
      nextThursday = nextThursday + delta

      people = People[cookies[:people]]
      if people.nil? == false
        time_limit = DateTime.now.utc
      else      
        time_limit = if (nextThursday - Date.today) < 4 then nextThursday else DateTime.now.utc end
      end

      group_events = Event.where("group_id = ? AND start_datetime > ?", cwn.id, time_limit).order(:start_datetime).all
      group_events.each { |event|
        opts << [event.id, event.name + "   (" + event.start_datetime.in_time_zone("Central Time (US & Canada)").strftime('%m/%d/%Y') + ")"]
      }
    end
    opts
  end

end # module Pakyow::Helpers

class String
  def is_number?
    true if Float(self) rescue false
  end
end