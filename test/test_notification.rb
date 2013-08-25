require 'test_helper'

describe 'UserNotification::Notification Rendering' do
  describe '#text' do
    subject { UserNotification::Notification.new(:key => 'notification.test', :parameters => {:one => 1}) }

    specify '#text uses translations' do
      subject.save
      I18n.config.backend.store_translations(:en,
        {:notification => {:test => '%{one} %{two}'}}
      )
      subject.text(:two => 2).must_equal('1 2')
      subject.parameters.must_equal({:one => 1})
    end
  end

  describe '#render' do
    subject do
      s = UserNotification::Notification.new(:key => 'notification.test', :parameters => {:one => 1})
      s.save && s
    end

    let(:template_output) { "<strong>1, 2</strong>\n<em>notification.test, #{subject.id}</em>\n" }
    before { @controller.view_paths << File.expand_path('../views', __FILE__) }

    it 'uses view partials when available' do
      UserNotification.set_controller(Struct.new(:current_user).new('fake'))
      subject.render(self, :two => 2)
      rendered.must_equal template_output + "fake\n"
    end

    it 'uses requested partial'

    it 'uses view partials without controller' do
      UserNotification.set_controller(nil)
      subject.render(self, :two => 2)
      rendered.must_equal template_output + "\n"
    end

    it 'provides local variables' do
      UserNotification.set_controller(nil)
      subject.render(self, locals: {two: 2})
      rendered.chomp.must_equal "2"
    end

    it 'uses translations only when requested' do
      I18n.config.backend.store_translations(:en,
        {:notification => {:test => '%{one} %{two}'}}
      )
      @controller.view_paths.paths.clear
      subject.render(self, two: 2, display: :i18n)
      rendered.must_equal '1 2'
    end

    it "uses specified layout" do
      UserNotification.set_controller(nil)
      subject.render(self, :layout => "notification")
      rendered.must_include "Here be the layouts"

      subject.render(self, :layout => "layouts/notification")
      rendered.must_include "Here be the layouts"

      subject.render(self, :layout => :notification)
      rendered.must_include "Here be the layouts"
    end
  end
end