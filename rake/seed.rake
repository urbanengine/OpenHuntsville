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
        user = User.new

        user.first_name = row[EXPERT_FIRST_NAME]
        user.last_name = row[EXPERT_LAST_NAME]
        cat_string = row[EXPERT_FIRST_SPECIALTY]
        unless row[EXPERT_SECOND_SPECIALTY].nil?
            if row[EXPERT_SECOND_SPECIALTY].length > 0
                cat_string.concat(",")
                cat_string.concat(row[SECOND_SPECIALTY])
            end
        end
        unless row[EXPERT_THIRD_SPECIALTY].nil?
            if row[EXPERT_THIRD_SPECIALTY].length > 0
                cat_string.concat(",")
                cat_string.concat(row[THIRD_SPECIALTY])
            end
        end
        user.categories_string = cat_string
        user.company = row[EXPERT_COMPANY]
        user.twitter = row[EXPERT_TWITTER]
        user.linkedin = row[EXPERT_LINKEDIN]
        user.url = row[EXPERT_URL]
        user.other_info = row[EXPERT_OTHER_INFO]
        user.image_url = row[EXPERT_IMAGE_URL]
        if user.email.nil? || user.email.length == 0
            user.email = "openhsv+" + user.first_name + user.last_name + "@gmail.com"
        end
        user.save
    end
  end
end
