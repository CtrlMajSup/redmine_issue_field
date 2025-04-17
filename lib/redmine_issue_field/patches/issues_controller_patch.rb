module RedmineIssueField
    module Patches
      module IssuesControllerPatch
        extend ActiveSupport::Concern
  
  
        included do
          include InstanceMethods
          include ClassMethods
          prepend InstanceOverwriteMethods
  
          before_action :authorize, :except => [:index, :new, :create, :autocomplete_issues]

  
          def autocomplete_issues
            Rails.logger.info("__________Recherche d'issue autocomplete")
            q = params[:q] #.downcase
            if params[:tracker_filter].present?
              tracker_filter = params[:tracker_filter].reject(&:blank?).map(&:to_i)
            else
              tracker_filter = []
            end
            scope = Issue.joins(:project)
                           .where(Issue.visible_condition(User.current))
                           .distinct
                           .order(updated_on: :desc)
  
            scope = scope.where(tracker_id: tracker_filter) unless tracker_filter.empty?
        
            scope = scope.limit(params[:limit] || AdditionalsConf.select2_init_entries)
            q.split.collect { |search_string| scope = scope.like search_string } if q.present?
            data = []
            scope.to_a.sort_by(&:subject).each do |issue|
              data << { 'id' => issue.id,
                        'subject' => issue.subject}
            end
            respond_to do |format|
              # format.text 
              format.json { render json: data }
            end
          end
  
          
        end
  
        def self.apply_patch
          IssuesController.send(:include, RedmineIssueField::Patches::IssuesControllerPatch)
        end
  
        module InstanceOverwriteMethods
          # Ajoutez ici toute méthode que vous souhaitez surcharger
        end
  
        module ClassMethods
          # Ajouter ici les méthode appelable sans insctance creer auparavant
        end
  
        module InstanceMethods
            # Ajoutez ici toute méthode que vous souhaitez créer
        end # InstanceMethods
  
      end # IssuesControllerPatch
    end # Patches
  end # RedmineIssueField
  
  