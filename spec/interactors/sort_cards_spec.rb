require 'rails_helper'

RSpec.describe SortCards, type: :interactor do
  describe '#call' do
    subject(:context) { described_class.call(params: params) }

    context 'when sorting by status in descending order' do
      let(:params) { { order_by: "status_desc" } }

      it 'sets order_by to the correct descending status order' do
        expect(context).to be_success
        expect(context.order_by).to eq({ "columns.position" => { direction: :desc, model: Column } })
      end
    end

    context 'when sorting by status in ascending order' do
      let(:params) { { order_by: "status_asc" } }

      it 'sets order_by to the correct ascending status order' do
        expect(context).to be_success
        expect(context.order_by).to eq({ "columns.position" => { direction: :asc, model: Column } })
      end
    end

    context 'when sorting by deadline in ascending order' do
      let(:params) { { order_by: "deadline_asc" } }

      it 'sets order_by to the correct ascending deadline order' do
        expect(context).to be_success
        expect(context.order_by).to eq({ deadline_at: :asc })
      end
    end

    context 'when sorting by deadline in descending order' do
      let(:params) { { order_by: "deadline_desc" } }

      it 'sets order_by to the correct descending deadline order' do
        expect(context).to be_success
        expect(context.order_by).to eq({ deadline_at: :desc })
      end
    end

    context 'when order_by param is invalid' do
      let(:params) { { order_by: "invalid_sort" } }

      it 'sets order_by to nil' do
        expect(context).to be_success
        expect(context.order_by).to be_nil
      end
    end

    context 'when order_by param is not provided' do
      let(:params) { {} }

      it 'sets order_by to nil' do
        expect(context).to be_success
        expect(context.order_by).to be_nil
      end
    end
  end
end
