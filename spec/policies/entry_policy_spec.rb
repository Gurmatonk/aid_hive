describe EntryPolicy do
  subject { EntryPolicy }

  shared_examples_for 'entry policy for' do |child_class_factory|
    let(:entry_params) { {} }
    let(:entry_factory) { child_class_factory }

    shared_context 'not logged in' do
      let(:current_user) { nil }
    end

    shared_context 'logged in as normal user' do
      let(:current_user) { FactoryGirl.build_stubbed :user }
    end

    shared_context 'logged in as admin' do
      let(:current_user) { FactoryGirl.build_stubbed :user, :admin }
    end

    shared_context 'entry from current_user' do
      let(:entry) { FactoryGirl.build_stubbed entry_factory, entry_params.merge(user: current_user) }
    end

    shared_context 'entry from different user' do
      let(:entry) { FactoryGirl.build_stubbed entry_factory, entry_params.merge(user: FactoryGirl.build_stubbed(:user)) }
    end

    shared_examples_for 'forbidden' do
      it do
        expect(subject).not_to permit(current_user, entry)
      end
    end

    shared_examples_for 'permitted' do
      it do
        expect(subject).to permit(current_user, entry)
      end
    end

    shared_examples_for 'permitted for own entry' do
      context do
        include_context 'entry from current_user'

        it_behaves_like 'permitted'
      end
    end

    shared_examples_for 'forbidden for own entry' do
      context do
        include_context 'entry from current_user'

        it_behaves_like 'forbidden'
      end
    end

    shared_examples_for 'permitted for entry from different user' do
      context do
        include_context 'entry from different user'

        it_behaves_like 'permitted'
      end
    end

    shared_examples_for 'forbidden for entry from different user' do
      context do
        include_context 'entry from different user'

        it_behaves_like 'forbidden'
      end
    end

    shared_examples_for 'permitted without login' do
      context do
        include_context 'not logged in'
        include_context 'entry from different user'

        it_behaves_like 'permitted'
      end
    end

    shared_examples_for 'forbidden without login' do
      context do
        include_context 'not logged in'
        include_context 'entry from different user'

        it_behaves_like 'forbidden'
      end
    end

    shared_examples_for 'publically available action' do
      context 'not logged in' do
        include_context 'not logged in'

        it_behaves_like 'permitted'
      end

      context 'logged in as normal user' do
        include_context 'logged in as normal user'

        it_behaves_like 'permitted'
      end

      context 'logged in as admin' do
        include_context 'logged in as admin'

        it_behaves_like 'permitted'
      end
    end

    permissions :create?, :new? do
      it_behaves_like 'forbidden without login'

      ['logged in as normal user', 'logged in as admin'].each do |user_context|
        context user_context do
          include_context user_context

          it_behaves_like 'permitted for own entry'
          it_behaves_like 'forbidden for entry from different user'
        end
      end
    end

    permissions :edit?, :update? do
      it_behaves_like 'forbidden without login'

      context 'logged in as normal user' do
        include_context 'logged in as normal user'

        it_behaves_like 'permitted for own entry'
        it_behaves_like 'forbidden for entry from different user'
      end

      context 'logged in as admin' do
        include_context 'logged in as admin'

        it_behaves_like 'permitted for own entry'
        it_behaves_like 'permitted for entry from different user'
      end
    end

    permissions :index? do
      let(:entry) { Request }

      it_behaves_like 'publically available action'
    end

    permissions :show? do
      include_context 'entry from different user'

      it_behaves_like 'publically available action'
    end

    permissions :destroy? do
      it_behaves_like 'forbidden without login'

      context 'logged in as normal user' do
        include_context 'logged in as normal user'

        it_behaves_like 'forbidden for own entry'
        it_behaves_like 'forbidden for entry from different user'
      end

      context 'logged in as admin' do
        include_context 'logged in as admin'

        it_behaves_like 'permitted for own entry'
        it_behaves_like 'permitted for entry from different user'
      end
    end

    permissions :complete? do
      context 'for open entry' do
        let(:entry_params) { super().merge(status: :open) }

        it_behaves_like 'forbidden without login'

        context 'logged in as normal user' do
          include_context 'logged in as normal user'

          it_behaves_like 'permitted for own entry'
          it_behaves_like 'forbidden for entry from different user'
        end

        context 'logged in as admin' do
          include_context 'logged in as admin'

          it_behaves_like 'permitted for own entry'
          it_behaves_like 'permitted for entry from different user'
        end
      end

      context 'for completed entry' do
        let(:entry_params) { super().merge(status: :completed) }

        it_behaves_like 'forbidden without login'

        context 'logged in as normal user' do
          include_context 'logged in as normal user'

          it_behaves_like 'forbidden for own entry'
          it_behaves_like 'forbidden for entry from different user'
        end

        context 'logged in as admin' do
          include_context 'logged in as admin'

          it_behaves_like 'forbidden for own entry'
          it_behaves_like 'forbidden for entry from different user'
        end
      end
    end
  end

  it_behaves_like 'entry policy for', :offer
  it_behaves_like 'entry policy for', :request
end
