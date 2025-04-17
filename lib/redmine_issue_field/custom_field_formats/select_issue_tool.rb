# frozen_string_literal: true

module RedmineIssueField
  module CustomFieldFormats
    module SelectIssueTool
  
      def autocomplete_select_issues(name, type, option_tags, **options)
        if option_tags.present?
          if option_tags.is_a? ActiveRecord::Relation
            option_tags = options_for_select option_tags.map { |u| [u.subject, u.id] }, option_tags.map(&:id)
          elsif !option_tags.is_a?(String)
            # if option_tags is not an array, it should be an object
            option_tags = options_for_select [[option_tags.try(:subject), option_tags.try(:id)]], option_tags.try(:id)
          end
        else
          # NOTE: without data select_tag raise error if include_blank is used,
          # e.g. ActionView::Template::Error (no implicit conversion of DbEntry::ActiveRecord_Relation into String)
          option_tags = ''
        end
  
        ajax_params = options.delete(:ajax_params) || {}
        if options[:project].present?
          ajax_params[:project_id] = options[:project]
        elsif @project
          ajax_params[:project_id] = @project
        end
  
        if options[:tracker_filter].present?
          ajax_params[:tracker_filter] = options[:tracker_filter]
        end
  
        s = []
        s << hidden_field_tag("#{name}[]", '') if options[:multiple]
        s << select_tag(name,
                        option_tags,
                        include_blank: options[:include_blank],
                        multiple: options[:multiple],
                        disabled: options[:disabled])
        s << render(layout: false,
                    partial: 'redmine_issue_field/select2_ajax_call_for_issue',
                    formats: [:js],
                    locals: { field_id: sanitize_to_id(name),
                              ajax_url: send("#{type}_path", ajax_params), # ça envoie au patch de issue controller
                              options: options })
        safe_join s
      end
    end
  end
end