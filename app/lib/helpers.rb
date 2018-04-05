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
      # http://sequel.jeremyevans.net/rdoc/files/doc/cheat_sheet_rdoc.html#label-Filtering+-28see+also+Dataset+Filtering-29
      # First attempt ad making this sequel 5.0.0 compatible
      # people = People.where(Sequel.lit("lower(custom_url) = ?", id.downcase)).all
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

  def send_auth_email(person, auth, template_name)
    subject = ''

    to_email = person.email
    from_email = 'donotreply@openhsv.com'

    case template_name
      when :verifyemail
        subject = "Urban Engine: Welcome"
        auth.class.module_eval { attr_accessor :mail_description}
        auth.mail_description = 'Urban Engine: 📬 Welcome to your first Urban Engine event! To make arriving at our Events easier we created you an Urban Engine account.'
        presenter.view = store.view('mail/account_verifyemail')
      when :accountcreation
        subject = "Urban Engine: Welcome"
        auth.class.module_eval { attr_accessor :mail_description}
        auth.mail_description = 'Urban Engine: 📬 Thank you for creating an account! Please verify your email to complete the account creation process.'
        presenter.view = store.view('mail/mail_accountcreation')
      when :passwordreset
        subject = "Urban Engine: Password Reset"
        auth.class.module_eval { attr_accessor :mail_description}
        auth.mail_description = 'Alert: 📬 You requested to reset the password for your Urban Engine account. Follow the instruction below to complete your password reset.'
        presenter.view = store.view('mail/account_passwordreset')
    end

    view.scope(:people).bind(person)
    view.scope(:auth).bind(auth)

    send_email(person, from_email, view.to_html, subject)
  end

  def send_email_template(person, email_partial, options = {})
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
    when :checkin
      presenter.view = store.view('mail/account_creation')
      view.scope(:people).bind(person)
      subject = "Account created through checking in"
    when :auth
      #pp options[:passwordResetLink]
      if options[:passwordResetLink].nil? == false
        pp options[:passwordResetLink]
        # Somehow pass the line containing the password reset link to the template
        presenter.view = store.view('mail/account_creation')
      else
        # Notify the user that their password has been reset successfully
        presenter.view = store.view('mail/account_creation')
      end

      presenter.view = store.view('mail/account_creation')
      view.scope(:people).bind(person)
      subject = "openHuntsville Password Reset"
    end

    send_email(person, from_email, view.to_html, subject)
  end # send_email_template(person, email_partial, options = {})

  def send_email(person, from_email, body, subject)
    unless ENV['RACK_ENV'] == 'development'
      recipient = "#{person.email} <#{person.email}>"
      # First, instantiate the Mailgun Client with your API key
      mg_client = Mailgun::Client.new ENV['MAILGUN_PRIVATE']

      # Define your message parameters
      fromAddress = ENV['EMAIL_FROM_ADDRESS']
      message_params =  { from: fromAddress,
                          to:   recipient,
                          subject: subject,
                          text: Nokogiri::HTML(body).text,
                          html: body
                        }

      # Send your message through the client
      domain = ENV['EMAIL_DOMAIN']
      mg_client.send_message domain, message_params
    end # unless ENV['RACK_ENV'] == 'development'
  end # send_email(person, from_email, body, subject)

  def email_us(subject, body)
    unless ENV['RACK_ENV'] == 'development'
      recipient = "The Awesome Team <openhsv@gmail.com>"

      # First, instantiate the Mailgun Client with your API key
      mg_client = Mailgun::Client.new ENV['MAILGUN_PRIVATE']

      # Define your message parameters
      fromAddress = ENV['EMAIL_FROM_ADDRESS']
      message_params =  { from: fromAddress,
                          to:   recipient,
                          subject: subject,
                          html: body,
                          text: Nokogiri::HTML(body).text
                        }

      # Send your message through the client
      domain = ENV['EMAIL_DOMAIN']

      mg_client.send_message domain, message_params
    end # unless ENV['RACK_ENV'] == 'development'
  end # email_us(user, from_email, body, subject)

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  def is_valid_email(email)
    (email =~ VALID_EMAIL_REGEX)
  end

  def create_session(parms)
    @session = Session.new(parms)

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
    people = get_user_from_cookies()
    people.groups().each do |group|
      if group.approved
        opts << [group.id, group.name]
      end
    end
    opts
  end

  def get_hsv_venues()
    opts = [[]]
    group = Group.where("name = 'CoWorking Night'").first
    Venue.all.each do |venue|
      if venue.group_id == group.id && venue.deprecated == false
        opts << [venue.id, venue.name]
      end
    end
    opts
  end

  def get_bhm_venues()
    opts = [[]]
    group = Group.where("name = 'CoWorking Night: Birmingham'").first
    Venue.all.each do |venue|
      if venue.group_id == group.id && venue.deprecated == false
        opts << [venue.id, venue.name]
      end
    end
    opts
  end

  def get_people_to_add_as_group_admin(group_id)
    opts = [[]]
    group = Group.where("id = ?", group_id).first
    group_admins = group.people()
    People.order(:email).each do |people|
      if group_admins.all? { |group_admin| group_admin.id != people.id }
        person_to_add_string = people.email
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

  def isUserSiteAdmin()
    loggedInUser = get_user_from_cookies()
    if loggedInUser.nil?
      return false
    end
    if loggedInUser.admin.nil?
      return false;
    end
    if loggedInUser.admin == true
      return true
    else
      return false
    end
  end

  def logged_in_user_is_hsv_admin_or_site_admin()
    people = get_user_from_cookies()
    if people.nil?
      return false
    end
    if people.admin
      return true
    end
    groups = people.groups().select{ |group| group.name != 'CoWorking Night: Birmingham' && group.name != 'CoWorking Night Events: Birmingham' }
    if groups.empty?
      return false
    end
    return true
  end

  def logged_in_user_is_bhm_admin_or_site_admin()
    people = get_user_from_cookies()
    if people.nil?
      return false
    end
    if people.admin
      return true
    end
    cwn = Group.where("name = 'CoWorking Night: Birmingham'").first
    admin = cwn.people().select{ |person| person.id == people.id }
    if admin.empty?
      return false
    else
      return true
    end
  end

  def logged_in_user_is_bhm_manager_or_site_admin()
    people = get_user_from_cookies()
    if people.nil?
      return false
    end
    if people.admin
      return true
    end
    cwn = Group.where("name = 'CoWorking Night: Birmingham'").first
    admin = cwn.people().select{ |person| person.id == people.id }
    if admin.empty?
      cwn = Group.where("name = 'CoWorking Night Events: Birmingham'").first
      admin = cwn.people().select{ |person| person.id == people.id }
      if admin.empty?
        return false
      end
    end
    return true
  end

  def logged_in_user_is_manager_of_event(event)
    people = get_user_from_cookies()
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
    people = get_user_from_cookies()
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

      people = get_user_from_cookies()
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

      people = get_user_from_cookies()
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

  def get_events_for_bhm_coworkingnight()
    opts = [[]]
    cwn = Group.where("name = 'CoWorking Night: Birmingham'").first
    unless cwn.nil? || cwn.id.nil?
      nextWednesday = Date.parse('Wednesday')
      delta = nextWednesday > Date.today ? 0 : 7
      nextWednesday = nextWednesday + delta

      people = get_user_from_cookies()
      if people.nil? == false
        time_limit = DateTime.now.utc
      else
        time_limit = if (nextWednesday - Date.today) < 4 then nextWednesday else DateTime.now.utc end
      end

      group_events = Event.where("group_id = ? AND start_datetime > ?", cwn.id, time_limit).order(:start_datetime).all
      group_events.each { |event|
        opts << [event.id, event.name + "   (" + event.start_datetime.in_time_zone("Central Time (US & Canada)").strftime('%m/%d/%Y') + ")"]
      }
    end
    opts
  end

  def api_key_is_authenticated(apiKey)
    apiKeys = ENV['APIKEYS'].split(',');
    if apiKeys.include?(apiKey)
      return true
    else
      return false
    end
  end

  def get_token_from_cookies()
    #box = RbNaCl::SimpleBox.from_secret_key(Base64.decode64(ENV['RBNACL_KEY']))
    cookie = cookies[:userinfo]
    if cookie.to_s.empty?
      return nil
    end
    #token = Marshal.load(box.decrypt(cookies[:userinfo]))
    cookie
  end

  def find_or_create_user_from_auth0_id(token)
    tokensplit = token.uid.split('|')
    if tokensplit.length != 2
      return nil
    end
    if tokensplit[0] != 'auth0'
      return nil
    end
    auth0id = tokensplit[1]
    user = People.where(Sequel.lit('auth0_id = ?', auth0id)).first

    if user.nil?
      #we don't have a user with the auth0_id.
      #either find the user from their email, or if that doesn't exist, create a new one
      user = People.where(Sequel.lit('email = ?', token.info.name)).first
      if user.nil?
        #create a new user
        c_params = { "auth0_id" => auth0id, "email" => token.info.name, "custom_url" => auth0id, "admin" => false, "approved" => true, "opt_in" => true, "opt_in_time" => Time.now.utc, "is_elite" => false }
        user = People.new(c_params)
        user.save
      else
        #update to store auth0_id
        user.auth0_id = auth0id
        user.save
      end


    else
      #if we have user with auth0_id, keep their email up to date
      user.email = token.info.name
      user.save
    end
    
    user
  end

  def get_user_from_token(tokenStr)
    if tokenStr.to_s.empty?
      return nil
    end
    token = YAML.load(tokenStr)
    if token.to_s.empty?
      return nil
    end

    user = find_or_create_user_from_auth0_id(token)
    user
  end

  def get_user_from_cookies()
    token = get_token_from_cookies()
    if token.nil?
      return nil
    end
    user = get_user_from_token(token)
    user
  end

  def put_token_in_cookies(token)
    if token.nil?
      return
    end
    #box = RbNaCl::SimpleBox.from_secret_key(Base64.decode64(ENV['RBNACL_KEY']))
    #puts box.encrypt(Marshal.dump(token))
    #session[:userinfo] = box.encrypt(Marshal.dump(token))
    cookies[:userinfo] = token.to_yaml
  end

end # module Pakyow::Helpers

class String
  def is_number?
    true if Float(self) rescue false
  end
end
