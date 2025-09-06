;
import { mountGroupDetails } from './GroupDetails';
import { mountGroupsListContainer } from './GroupsListContainer';
import './tailwind.css'

document.addEventListener("turbo:load", () => {
  if (document.getElementById("GroupDetails")) {
    mountGroupDetails();
  }

  if (document.getElementById("GroupsListContainer")) {
    mountGroupsListContainer();
  }
});
