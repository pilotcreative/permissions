require "test_helper"

ActionController::Routing::Routes.draw do |map|
  map.resources :photos, :has_many => :comments
  map.connect ':controller/:action/:id'
end

class RequirePermissionsTest < ActionController::TestCase

  class PhotosController < ActionController::Base
    def show; render :inline => "ran action show" end
    def edit; render :inline => "ran action edit" end
  end

  class CommentsController < ActionController::Base
    require_permissions :comment => [:edit, :update, :destroy], :method => :editable_by?
    require_permissions :photo => [:new, :create]

    def new; render :inline => "ran action new" end
    def create; render :inline => "ran action create" end
    def edit; render :inline => "ran action edit" end
    def update; render :inline => "ran action update" end
    def destroy; render :inline => "ran action destroy" end
   end

  context "Require permission lib" do
    setup do
      @options = {:photo => [:edit]}
    end

    should "call require_permission action" do
      PhotosController.expects(:require_permissions).with(@options)
      PhotosController.require_permissions(@options)
    end

    should "call require_permissions when call require_visibility action" do
      PhotosController.expects(:require_permissions).with(@options.merge!(:method => :visible_to?))
      PhotosController.require_visibility(@options)
    end

    should "call filter before" do
      PhotosController.expects(:before_filter).once
      PhotosController.require_permissions(@options)
    end

    should "be available in ActionController" do
      options = {:photo => [:show]}
      options.should == ActionController::Base.require_permissions(options)
    end

    should "call edit" do
      assert_nothing_raised do
        test_process(CommentsController, "edit")
        @response.body.should == "ran action edit"
      end
    end
  end

  private
    def test_process(controller, action = "show")
      @controller = controller.is_a?(Class) ? controller.new : controller
      @request = ActionController::TestRequest.new
      @response = ActionController::TestResponse.new
      process(action)
    end
end
