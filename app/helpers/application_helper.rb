module ApplicationHelper
  def current_user_demo_users
    if current_user
      User.
        joins(:groups).
        merge(
          current_user.groups.where(demo: true),
        ).
        where(demo: true)
    end
  end
end
