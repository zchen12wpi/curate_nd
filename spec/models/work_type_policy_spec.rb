require 'spec_helper'

describe WorkTypePolicy do
  let(:privileged_groups){ [ 'pid:1234', 'pid:5678' ] }
  let(:current_user){ double( groups: privileged_groups ) }

  context 'With a simple rule declaration' do
    let(:simple_rules) do
      rules = <<-config.strip_heredoc
      ---
      Permitted:
        open: all
      Forbidden:
        open: nobody
      config
      YAML.load(rules)
    end

    subject(:simple_access_policy) do
      described_class.new( user: current_user, permission_rules: simple_rules )
    end

    context 'when work type is open to all' do
      it 'authorized_fors access' do
        expect(simple_access_policy.authorized_for?('Permitted')).to be_truthy
      end
    end

    context 'when work type is open to nobody' do
      it 'denies access' do
        expect(simple_access_policy.authorized_for?('Forbidden')).to be_falsey
      end
    end
  end

  context 'With group access controls' do
    let(:user_without_groups){ double( groups: [] ) }

    let(:group_rules) do
      rules = <<-config.strip_heredoc
      ---
      Single:
        open: 'pid:1234'
      Multiple:
        open:
          - 'pid:1234'
          - 'pid:5678'
      config
      YAML.load(rules)
    end

    let(:authorized_group_access_policy) do
      described_class.new( user: current_user, permission_rules: group_rules )
    end

    let(:unauthorized_group_access_policy) do
      described_class.new( user: user_without_groups, permission_rules: group_rules )
    end

    context 'when work type is open to a single group' do
      context 'and user has group' do
        it 'will authorized_for' do
          expect(authorized_group_access_policy.authorized_for?('Single')).to be_truthy
        end
      end

      context 'and user does not have group' do
        it 'will deny' do
          expect(unauthorized_group_access_policy.authorized_for?('Single')).to be_falsey
        end
      end
    end

    context 'when work type is open to several groups' do
      context 'and user has group' do
        it 'will authorized_for' do
          expect(authorized_group_access_policy.authorized_for?('Multiple')).to be_truthy
        end
      end

      context 'user does not have group' do
        it 'will deny' do
          expect(unauthorized_group_access_policy.authorized_for?('Multiple')).to be_falsey
        end
      end
    end
  end

  context 'With configuration errors' do
    let(:poorly_written_rules) do
      rules = <<-config.strip_heredoc
      ---
      Ambiguous:
        open:
      Unspecified:
      config
      YAML.load(rules)
    end

    subject(:configuration_with_errors) do
      described_class.new( user: current_user, permission_rules: poorly_written_rules )
    end

    context 'when work type permissions are not specified' do
      it 'will deny' do
        expect(configuration_with_errors.authorized_for?('Ambiguous')).to be_falsy
      end
    end

    context 'when work type is not is not declared open' do
      it 'will deny' do
        expect(configuration_with_errors.authorized_for?('Unspecified')).to be_falsy
      end
    end

    context 'when work type is not is not listed' do
      it 'will deny' do
        expect(configuration_with_errors.authorized_for?('Absent')).to be_falsy
      end
    end
  end
end
