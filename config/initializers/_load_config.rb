APP_CONFIG = HashWithIndifferentAccess.new(YAML.load(ERB.new(File.read("#{Rails.root}/config/config.yml")).result))[Rails.env]
