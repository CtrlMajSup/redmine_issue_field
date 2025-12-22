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

            q = params[:q].to_s.strip
            params[:tracker_filter] ||= params[:"amp;tracker_filter"]


            tracker_filter =
              if params[:tracker_filter].present?
                Array(params[:tracker_filter]).reject(&:blank?).map(&:to_i)
              else
                []
              end

            Rails.logger.info("tracker_filter : ")
            Rails.logger.info(tracker_filter)

            scope = Issue
                      .joins(:project)
                      .where(Issue.visible_condition(User.current))
                      .distinct
                      .order(updated_on: :desc)

            scope = scope.where(tracker_id: tracker_filter) unless tracker_filter.empty?

            # ---- Remplacement de AdditionalsConf.select2_init_entries ----
            default_limit = 10
            max_limit     = 20

            raw_limit =
              begin
                Integer(params[:limit])
              rescue ArgumentError, TypeError
                nil
              end

            limit = [[raw_limit || default_limit, 1].compact.max, max_limit].min
            scope = scope.limit(limit)

            # Recherche full-text par tokens (si q présent)
            if q.present?
              q.split(/\s+/).each do |token|
                scope = scope.like(token) # <= conserve ton scope custom si existant
              end
            end

            # Trie côté SQL plutôt que Ruby pour éviter to_a + sort_by
            scope = scope.order(:subject)

            data = scope.map { |issue| { 'id' => issue.id, 'subject' => issue.subject } }

            respond_to do |format|
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
  
  