class RuleGroupsController < ApplicationController
  def new
    @rule_group = RuleGroup.new
    @state = params[:state]
    @parent_group_id = params[:parent_group_id]
    respond_to do |format|
      format.turbo_stream
    end
  end
end
