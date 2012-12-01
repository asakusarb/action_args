require 'spec_helper'

describe <%= controller_class_name %>Controller do
  # This should return the minimal set of attributes required to create a valid
  # <%= class_name %>. As you add validations to <%= class_name %>, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    {}
  end

<% unless options[:singleton] -%>
  describe 'GET index' do
    before do
      @<%= file_name %> = <%= class_name %>.create! valid_attributes
      controller.index
    end
    describe 'assigns all <%= table_name.pluralize %> as @<%= table_name.pluralize %>' do
      subject { controller.instance_variable_get('@<%= table_name %>') }
      it { should eq([@<%= file_name %>]) }
    end
  end

<% end -%>
  describe 'GET show' do
    before do
      @<%= file_name %> = <%= class_name %>.create! valid_attributes
      controller.show(@<%= file_name %>.to_param)
    end
    describe 'assigns the requested <%= ns_file_name %> as @<%= ns_file_name %>' do
      subject { controller.instance_variable_get('@<%= ns_file_name %>') }
      it { should eq(@<%= file_name %>) }
    end
  end

  describe 'GET new' do
    before do
      controller.new
    end
    describe 'assigns a new <%= ns_file_name %> as @<%= ns_file_name %>' do
      subject { controller.instance_variable_get('@<%= ns_file_name %>') }
      it { should be_a_new(<%= class_name %>) }
    end
  end

  describe 'GET edit' do
    before do
      @<%= file_name %> = <%= class_name %>.create! valid_attributes
      controller.edit(@<%= file_name %>.to_param)
    end
    describe 'assigns the requested <%= ns_file_name %> as @<%= ns_file_name %>' do
      subject { controller.instance_variable_get('@<%= ns_file_name %>') }
      it { should eq(@<%= file_name %>) }
    end
  end

  describe 'POST create' do
    context 'with valid params' do
      before do
        controller.should_receive(:redirect_to) {|u| u.should eq(<%= class_name %>.last) }
      end
      describe 'creates a new <%= class_name %>' do
        it { expect {
          controller.create(valid_attributes)
        }.to change(<%= class_name %>, :count).by(1) }
      end

      describe 'assigns a newly created <%= ns_file_name %> as @<%= ns_file_name %> and redirects to the created <%= ns_file_name %>' do
        before do
          controller.create(valid_attributes)
        end
        subject { controller.instance_variable_get('@<%= ns_file_name %>') }
        it { should be_a(<%= class_name %>) }
        it { should be_persisted }
      end
    end

    context 'with invalid params' do
      describe "assigns a newly created but unsaved <%= ns_file_name %> as @<%= ns_file_name %>, and re-renders the 'new' template" do
        before do
          <%= class_name %>.any_instance.stub(:save) { false }
          controller.should_receive(:render).with(:action => 'new')
          controller.create({})
        end
        subject { controller.instance_variable_get('@<%= ns_file_name %>') }
        it { should be_a_new(<%= class_name %>) }
      end
    end
  end

  describe 'PUT update' do
    context 'with valid params' do
      describe 'updates the requested <%= ns_file_name %>, assigns the requested <%= ns_file_name %> as @<%= ns_file_name %>, and redirects to the <%= ns_file_name %>' do
        before do
          @<%= file_name %> = <%= class_name %>.create! valid_attributes
          controller.should_receive(:redirect_to).with(@<%= file_name %>, anything)
          controller.update(@<%= file_name %>.to_param, valid_attributes)
        end
        subject { controller.instance_variable_get('@<%= ns_file_name %>') }
        it { should eq(@<%= file_name %>) }
      end
    end

    context 'with invalid params' do
      describe "assigns the <%= ns_file_name %> as @<%= ns_file_name %>, and re-renders the 'edit' template" do
        before do
          @<%= file_name %> = <%= class_name %>.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          <%= class_name %>.any_instance.stub(:save) { false }
          controller.should_receive(:render).with(:action => 'edit')
          controller.update(@<%= file_name %>.to_param, {})
        end
        subject { controller.instance_variable_get('@<%= ns_file_name %>') }
        it { should eq(@<%= file_name %>) }
      end
    end
  end

  describe 'DELETE destroy' do
    before do
      @<%= file_name %> = <%= class_name %>.create! valid_attributes
      controller.stub(:<%= index_helper %>_url) { '/<%= index_helper %>' }
      controller.should_receive(:redirect_to).with('/<%= index_helper %>')
    end
    it 'destroys the requested <%= ns_file_name %>, and redirects to the <%= table_name %> list' do
      expect {
        controller.destroy(@<%= file_name %>.to_param)
      }.to change(<%= class_name %>, :count).by(-1)
    end
  end
end
