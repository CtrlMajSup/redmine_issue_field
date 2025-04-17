# frozen_string_literal: true

module RedmineIssueField
    module CustomFieldFormats
      class IssueFormat < Redmine::FieldFormat::RecordList
        add 'issue'
        field_attributes :tracker_filter
        self.form_partial = 'custom_fields/formats/issue'
        self.customized_class_names = nil
        self.multiple_supported = true
  
        def label
          'label_issue'
        end
  
        def target_class
          @target_class ||= Issue
        end
  
  
        def group_statement(custom_field)
          # La clause SQL pour grouper par le custom field
          <<~SQL
            (SELECT GROUP_CONCAT(related.id SEPARATOR ',')
             FROM custom_values cv
             LEFT JOIN issues related ON FIND_IN_SET(related.id, cv.value)
             WHERE cv.custom_field_id = #{custom_field.id}
               AND cv.customized_id = issues.id)
          SQL
        end
        
  
        def query_filter_options(custom_field, query)
          super.merge(
            field_format: 'issue',
            group_by: query_filter_group_by_options(custom_field, query)
          )
        end
  
        def query_filter_group_by_options(custom_field, query)
          {
            field_format: 'issue',
            field_name: custom_field.name,
            label: custom_field.name,
            group_statement: group_statement(custom_field)
          }
        end
  
  
        def edit_tag(view, tag_id, tag_name, custom_value, **options)
          extra_options = { id: tag_id,
                            multiple: custom_value.custom_field.multiple,
                            placeholder: nil}
  
          # Ajoutez tracker_filter uniquement si custom_value.custom_field.tracker_filter est présent
          if custom_value.custom_field.tracker_filter.present?
            tracker_filter = custom_value.custom_field.tracker_filter.reject(&:blank?).map(&:to_i)
            extra_options[:tracker_filter] = tracker_filter if tracker_filter.any?
          end
  
          unless custom_value.custom_field.is_required
            extra_options[:include_blank] = true
            extra_options[:allow_clear] = true
          end
  
          issues = Issue.where id: custom_value.value if Array(custom_value.value).compact_blank.any?
          view.autocomplete_select_issues(tag_name,
                                           'autocomplete_issues',
                                           issues,
                                           **options.merge(extra_options))
        end
  
        def validate_custom_value(_custom_value)
          # Ici vous pouvez ajouter une logique de validation si nécessaire
          []
        end
  
        def query_filter_options(custom_field, query)
          super.merge field_format: 'issue'
        end
  
        def possible_values_records(_custom_field, object)
          # Implémentez la logique pour récupérer les objets possibles ici
      return Issue.none if object.nil? || object.id.nil?  # condition d'utiliation pour l'api
          Issue.where(project_id: object.id)
        end
  
        def possible_values_options(custom_field, object = nil)
          possible_values_records(custom_field, object).map { |i| [i.subject, i.id.to_s] }
        end
  
        def set_custom_field_value(custom_field, custom_field_value, value)
          if value.is_a?(Array)
            value.flatten!
            value.compact!
          end
  
          super custom_field, custom_field_value, value
        end
  
        # def formatted_value(view, custom_value, html = false)
        #   issue_ids = custom_value.value
        #   issues = Issue.where(id: issue_ids).map(&:subject).join(', ')
        #   html ? view.content_tag('span', issues) : issues
        # end
  
        def bulk_edit_tag(view, tag_id, tag_name, custom_field, objects, value, options={})
          edit_tag(view, tag_id, tag_name, value, options)
        end
  
        def bulk_clear_tag(view, tag_id, tag_name, custom_field, objects, value, options={})
          view.select_tag(tag_name, view.options_for_select([]), options.merge(:id => tag_id))
        end
      end
    end
  end
  