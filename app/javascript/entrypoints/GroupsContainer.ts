import GroupsContainer from "../apps/GroupsContainer"

import { mountComponent } from "../utils/reactHelper"

document.addEventListener("turbo:load", () => {
  mountComponent(GroupsContainer, "GroupsContainer")
})

