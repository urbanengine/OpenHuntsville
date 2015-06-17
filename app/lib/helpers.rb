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
  
end