# frozen_string_literal: true

module AkashiWithSlack
  class Config
    SLACK_TOKEN = ENV['SLACK_TOKEN']
    COMMAND_NAME = 'akashide'
    AKASHI_COMPANY_ID = ENV['AKASHI_COMPANY_ID']
  end

  class Command
    INIT = 'init'
    CHECK_IN = 'in'
    CHECK_OUT = 'out'
    HELP = 'help'
  end
end
