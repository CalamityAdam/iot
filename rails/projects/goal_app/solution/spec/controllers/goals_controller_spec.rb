require 'rails_helper'

RSpec.describe GoalsController, type: :controller do
    let(:jack) { User.create!(username: 'jack_bruce', password: 'abcdef') }
  
    before(:each) do
      allow_message_expectations_on_nil
    end
  
    describe 'GET #new' do
      context 'when logged in' do
        before do
          allow(controller).to receive(:current_user) { jack }
        end
  
        it 'renders the new Goals page' do
          get :new
          expect(response).to render_template('new')
        end
      end
  
      context 'when logged out' do
        before do
          allow(controller).to receive(:current_user) { nil }
        end
  
        it 'redirects to the login page' do
          get :new
          expect(response).to redirect_to(new_user_url)
        end
      end
    end
end  