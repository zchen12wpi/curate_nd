shared_examples 'is_doi_assignable_model' do
  it { should respond_to(:assign_doi) }
  its(:terms_for_display) { should_not include(:assign_doi) }
  its(:terms_for_editing) { should include(:assign_doi) }
end
