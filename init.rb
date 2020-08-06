# frozen_string_literal: true

module AkashiWithSlack
  class Config
    SLACK_TOKEN = ENV['']
    COMMAND_NAME = 'akashide'
  end

  class Command
    INIT = 'init'
    CHECK_IN = 'in'
    CHECK_OUT = 'out'
    HELP = 'help'
  end
end
