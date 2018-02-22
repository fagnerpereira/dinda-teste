require 'spec_helper'

describe GitClient do
  let(:git_client) { described_class.new('abc123', 'braspag-rest', 'Dinda-com-br') }

  describe '#generate_lines' do
    subject(:lines) { git_client.generate_lines }

    it { should include('pmatiello') }
    it { should include('antoniofilho') }
    it { should include('bvicenzo') }
    it { should include('Pedro Matiello') }
    it { should include('pedro@pmatiello.me') }
  end

  describe '#rank' do
    context 'attributes' do
      subject(:rank) { git_client.rank.first }

      it { should include('name') }
      it { should include('email') }
      it { should include('login') }
      it { should include('avatar_url') }
      it { should include('contributions') }
    end

    context 'order' do
      subject(:rank) { git_client.rank }

      it { expect(rank[0]['login']).to eq('pmatiello') }
      it { expect(rank[1]['login']).to eq('antoniofilho') }
      it { expect(rank[2]['login']).to eq('bvicenzo') }
    end
  end

  describe '#get_contributors' do
    subject(:contributor) { git_client.get_contributors.first }

    it { should include('login') }
    it { should include('avatar_url') }
    it { should include('contributions') }
  end

  describe '#get_user' do
    subject(:user) { git_client.get_user('pmatiello') }

    it { should include('name') }
    it { should include('email') }
  end
end
