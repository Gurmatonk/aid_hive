module EntrySearchable
  extend ActiveSupport::Concern

  included do
    before_action :search_entries, only: [:index, :my]
    before_action :search_commented_entries, only: :my

    private

    def base_relation
      case params[:action]
      when 'index'
        controller_name.classify.constantize.open
      when 'my'
        current_user.send(controller_name.pluralize)
      end
    end

    def search_entries
      instance_variable = "@#{controller_name}"
      collection = params[:query_location].present? ? base_relation.near(params[:query_location], params[:query_within], units: :km) : base_relation.all
      collection = collection.fuzzy_search({title: params[:query_keywords], description: params[:query_keywords]}, false) if params[:query_keywords].present?
      instance_variable_set(instance_variable, collection.page(params[:query_page]))
    end

    def search_commented_entries
      association_name = "commented_#{controller_name}"
      instance_variable = "@#{association_name}"
      commented_entries = current_user.send(association_name)
      collection =
        if params[:query_commented_location].present?
          commented_entries.near(params[:query_commented_location], params[:query_commented_within], units: :km)
        else
          commented_entries.all
        end
      commented_search_params = {title: params[:query_commented_keywords], description: params[:query_commented_keywords]}
      collection = collection.fuzzy_search(commented_search_params, false) if params[:query_commented_keywords].present?
      instance_variable_set(instance_variable, collection.page(params[:query_commented_page]))
    end
  end
end
