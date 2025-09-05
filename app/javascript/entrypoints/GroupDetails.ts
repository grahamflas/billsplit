import GroupDetails from "../apps/GroupDetails"

import { mountComponent } from "../utils/reactHelper"

document.addEventListener("turbo:load", () => {
  mountComponent(GroupDetails, "GroupDetails")
})
