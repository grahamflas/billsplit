require 'rails_helper'

RSpec.describe "Api::Groups", type: :request do
  describe "POST /groups" do
    it "creates a group and responds with an OK status and the group" do
      user = create(:user)
      other_user_1 = create(:user)
      other_user_2 = create(:user)

      sign_in user

      expect do
        post api_groups_path, params: {
          group: {
            name: "Berlin trip group",
            user_ids: [
              user.id,
              other_user_1.id,
              other_user_2.id,
            ],
          },
          new_contacts: [],
        }
      end.to change(Group, :count).by(1)

      expect(response).to have_http_status(:success)
      expect(response.parsed_body["group"]["name"]).to eq("Berlin trip group")
    end

    context "with missing params" do
      it "responds with unprocessable entity and error messages" do
        user = create(:user)

        sign_in user

        expect do
          post api_groups_path, params: {
            group: {
              name: "",
              user_ids: [user.id],
            }
          }
        end.not_to change(Group, :count)

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.parsed_body["errors"]).to eq(["Name can't be blank"])
      end
    end

    context "when the current_user is not included in the group's members" do
      it "returns unprocessable_content and an error" do
        user = create(:user)
        other_user = create(:user)

        sign_in user

        expect do
          post api_groups_path, params: {
            group: {
              name: "Group without self",
              user_ids: [other_user.id],
            }
          }
        end.not_to change(Group, :count)

        expect(response).to have_http_status(:unprocessable_content)
        expect(response.parsed_body["errors"]).to eq(["You must add yourself to the group"])
      end
    end
  end

  describe "PUT /groups/:id" do
    it "updates the group" do
      group = create(:group, name: "My group")
      user = create(:user, groups: [ group ])
      other_user_1 = create(:user, groups: [ group ])
      _other_user_2 = create(:user, groups: [ group ])

      sign_in user

      put api_group_path(group), params: {
        group: {
          name: "Updated name",
          user_ids: [user.id, other_user_1.id]
        },
        new_contacts: [],
      }

      expect(group.reload.name).to eq("Updated name")
      expect(group.users).to match_array([other_user_1, user])
    end

    context "when the user is not a member of the group" do
      it "returns unauthorized" do
        group = create(:group, name: "My group")
        other_group = create(:group, name: "Other Group")

        user = create(:user, first_name: "User", groups: [ group ])
        _other_user = create(:user, first_name: "Other User", groups: [ other_group ])


        sign_in user

        put api_group_path(other_group), params: {
          group: {
            name: "Updated name",
            user_ids: [ user.id ],
          },
          new_contacts: [],
        }

        expect(other_group.reload.name).to eq("Other Group")
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe "PUT /groups/:id/archive" do
    it "archives the group and returns head :ok" do
      group = create(:group)
      user = create(:user, groups: [ group ])

      sign_in user

      put archive_api_group_path(group)

      expect(group.reload.archived?).to eq(true)
      expect(response).to have_http_status(:ok)
    end

    context "when the current_user is not a group member" do
      it "does not archive the group and returns unauthorized" do
        group = create(:group)
        _user = create(:user, groups: [ group ])

        other_group = create(:group)
        other_user = create(:user, groups: [ other_group ])


        sign_in other_user

        put archive_api_group_path(group)

        expect(group.reload.archived?).to eq(false)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
