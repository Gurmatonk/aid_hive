module EntrySearchable
  extend ActiveSupport::Concern

  included do
    before_action :search_entries, only: [:index]

    private

    def search_entries
      instance_variable = "@#{controller_name}"
      model = controller_name.classify.constantize
      collection = params[:query_location].present? ? model.near(params[:query_location], params[:query_within], units: :km).page(params[:page]) : model.all.page(params[:page])
      instance_variable_set(instance_variable, collection)
      instance_variable_set(instance_variable, collection.fuzzy_search({title: params[:query_keywords], description: params[:query_keywords]}, false)) if params[:query_keywords].present?
    end
  end
end
