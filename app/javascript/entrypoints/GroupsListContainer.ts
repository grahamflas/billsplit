import GroupsListContainer from "../apps/GroupsListContainer"

import { mountComponent } from "../utils/reactHelper"

document.addEventListener("turbo:load", () => {
  mountComponent(GroupsListContainer, "GroupsListContainer")
})
