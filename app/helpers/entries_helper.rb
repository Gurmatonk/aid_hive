module EntriesHelper
  def entry_toolbar(entry)
    capture do
      concat action_button(entry, :complete, method: :post, icon: 'ok-circle')
      concat action_button(entry, :destroy, method: :delete, icon: :trash)
    end
  end
end
