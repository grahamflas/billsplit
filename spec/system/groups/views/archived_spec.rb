require "rails_helper"

RSpec.describe "Archived Groups Page", :aggregate_failures, type: :system, js: true  do
  include ActionView::Helpers::DateHelper

  scenario "shows the logged-in user a list of their archived groups with links to view them" do
    archived_group_1 = create(:group, :archived)
    archived_group_2 = create(:group, :archived)
    archived_group_3 = create(:group, :archived)
    other_archived_group = create(:group, :archived)

    active_group = create(:group)

    user = create(
      :user,
      groups: [
        archived_group_1,
        archived_group_2,
        archived_group_3,
        active_group,
      ]
    )

    _other_user = create(
      :user,
      groups: [ other_archived_group ],
    )

    sign_in user

    visit archived_groups_path

    expect(page).to have_content("My Archived Groups")

    expect(page).to have_content(archived_group_1.name)
    expect(page).to have_content(archived_group_2.name)
    expect(page).to have_content(archived_group_3.name)
    expect(page).not_to have_content(other_archived_group.name)
    expect(page).not_to have_content(active_group.name)

    expect(page).to have_link(href: group_path(archived_group_1))
    expect(page).to have_link(href: group_path(archived_group_2))
    expect(page).to have_link(href: group_path(archived_group_3))

    add_new_group_button_text = "+ Add Group"
    expect(page).not_to have_link(add_new_group_button_text, href: new_group_path)

    within "#group-#{archived_group_1.id}" do
      expect(page).to have_css("span", text: "Archived")
      expect(page).to have_content(
        "Archived #{time_ago_in_words(archived_group_1.archived_on)}"
      )
    end
  end
end
