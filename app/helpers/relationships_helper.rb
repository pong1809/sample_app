module RelationshipsHelper
  def current_user_active_relationships
    current_user.active_relationships.find_by followed_id: @user.id
  end
end
