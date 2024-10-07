class GoalsController < ApplicationController
  def new
    @goal = Goal.new
    @goal.goal_rule_groups.build  # Builds an initial rule group
    @goal.goal_rules.build        # Builds an initial standalone rule
  end

  def create
    @goal = Goal.new(goal_params)
    @goal.account = Account.last # Not implemented

    if @goal.save
      respond_to do |format|
        format.html { redirect_to @goal, notice: "Goal was successfully created." }
        format.turbo_stream { flash.now[:notice] = "Goal was successfully created." }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :new, status: :unprocessable_entity }
      end
    end
  end

  def show
    @goal = Goal.find(params[:id])
  end

  def index
    @goals = Goal.all
  end

  private

  def goal_params
    params.require(:goal).permit(:name, :description, :data,
      goal_rules_attributes: [ :id, :rule_id, :operator, :_destroy ],
      goal_rule_groups_attributes: [ :id, :rule_group_id, :operator, :_destroy,
        rule_group_attributes: [ :name, :data,
          rule_group_memberships_attributes: [ :id, :parent_group_id,
                                               :child_group_id, :operator,
                                               :_destroy ]
        ]
      ]
    )
  end
end
