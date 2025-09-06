require "rails_helper"

RSpec.describe "Home Page", type: :system, js: true do
  scenario "shows the logged-in user a list of their groups with links to add new groups and view ones" do
    group_1 = create(:group)
    group_2 = create(:group)
    group_3 = create(:group)
    other_group = create(:group)

    user = create(
      :user,
      groups: [
        group_1,
        group_2,
        group_3,
      ]
    )

    _other_user = create(
      :user,
      groups: [ other_group ],
    )

    sign_in user

    visit root_path

    expect(page).to have_content(group_1.name)
    expect(page).to have_content(group_2.name)
    expect(page).to have_content(group_3.name)
    expect(page).not_to have_content(other_group.name)

    expect(page).to have_link(href: group_path(group_1))
    expect(page).to have_link(href: group_path(group_2))
    expect(page).to have_link(href: group_path(group_3))

    add_new_group_button_text = "+ Add Group"
    expect(page).to have_link(add_new_group_button_text, href: new_group_path)

    click_link add_new_group_button_text

    fill_in "Group name", with: "My New Group"

    click_button "Create Group"

    expect(page).to have_content("My New Group created")
  end
end
