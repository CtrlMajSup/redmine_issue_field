module RedmineIssueField
    def self.apply_new_format
      Redmine::FieldFormat.add 'issue', RedmineIssueField::CustomFieldFormats::IssueFormat
      ActionView::Base.include RedmineIssueField::CustomFieldFormats::SelectIssueTool
    end

    def self.setup_controller_patches
      RedmineIssueField::Patches::IssuesControllerPatch.apply_patch 
    end

end
