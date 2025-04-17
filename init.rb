Redmine::Plugin.register :redmine_issue_field do
  name 'Redmine Issue Field plugin'
  author 'CtrlMajSup'
  description 'This is a plugin for Redmine 6, it add a customfield type as issue'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'


  Rails.application.config.after_initialize do
    RedmineIssueField.apply_new_format
    RedmineIssueField.setup_controller_patches
  end

end
