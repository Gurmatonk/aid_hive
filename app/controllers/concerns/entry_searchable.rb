module EntrySearchable
  extend ActiveSupport::Concern

  included do
    before_action :search_entries, only: [:index, :my]

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
      instance_variable_set(instance_variable, collection.page(params[:page]))
    end
  end
end
